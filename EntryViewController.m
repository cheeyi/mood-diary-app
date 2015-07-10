//
//  NewEntryViewController.m
//  Diary
//
//  Created by Chee Yi Ong on 6/20/15.
//  Copyright (c) 2015 Chee Yi Ong. All rights reserved.
//

#import "EntryViewController.h"
#import "DiaryEntry.h"
#import "CoreDataStack.h"
#import <CoreLocation/CoreLocation.h>

@interface EntryViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>
#pragma mark - Initialization and boilerplate code
@property (strong,nonatomic) NSString *location;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) UIImage *pickedImage;
@property (assign,nonatomic) enum DiaryEntryMood pickedMood; //!?

// Outlets (most are owned by views that they are located in, hence weak)
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (weak, nonatomic) IBOutlet UIButton *averageButton;
@property (weak, nonatomic) IBOutlet UIButton *badButton;
@property (strong, nonatomic) IBOutlet UIView *accessoryView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;

@end

@implementation EntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.locationManager requestWhenInUseAuthorization];
    NSDate *date;
    
    if (self.entry != nil) { // editing mode
        self.textView.text = self.entry.body;
        self.pickedMood = self.entry.mood;
        date = [NSDate dateWithTimeIntervalSinceNow:self.entry.date];
        [self setPickedImage:[UIImage imageWithData:self.entry.imageData]];
    } else { // new entry
        self.pickedMood = DiaryEntryMoodGood; // default
        date = [NSDate date]; // now
        [self loadLocation];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE MMM d, yyyy"];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    self.textView.inputAccessoryView = self.accessoryView;
    self.imageButton.layer.cornerRadius = CGRectGetWidth(self.imageButton.frame)/2.0f;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Core Location
- (void)loadLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = 1000; //metres
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
    CLLocation *location = [locations firstObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        self.location = placemark.name;
    }];
    
}

#pragma mark - User/data interactions
- (void)dismissSelf {
    // Dismiss this view controller
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateDiaryEntry {
    // Let the self.entry.body be whatever's in the UI text field
    self.entry.body = self.textView.text;
    self.entry.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    self.entry.mood = self.pickedMood;
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [coreDataStack saveContext];
}

- (IBAction)doneWasPressed:(id)sender {
    if (self.entry != nil) { // this is an edit/update operation
        [self updateDiaryEntry];
    } else { // this is an entry creation operation
        [self insertDiaryEntry];
    }
    [self dismissSelf];
}

- (IBAction)cancelWasPressed:(id)sender {
    [self dismissSelf];
}

- (void)insertDiaryEntry {
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    DiaryEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"DiaryEntry" inManagedObjectContext: coreDataStack.managedObjectContext ];
    entry.body = self.textView.text;
    entry.date = [[NSDate date] timeIntervalSince1970];
    entry.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    entry.mood = self.pickedMood;
    entry.location = self.location;
    [coreDataStack saveContext];
}

/*-- Finished handling the TextView box --*/


#pragma mark - Handle picture attachment
- (void)setPickedImage:(UIImage *)pickedImage {
    _pickedImage = pickedImage;
    
    if (pickedImage == nil) { // default to placeholder
        [self.imageButton setImage:[UIImage imageNamed:@"icn_noimage"] forState:UIControlStateNormal];
    } else {
        [self.imageButton setImage:pickedImage forState:UIControlStateNormal];
    }
}

- (IBAction)picturePressed:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // If camera is available
        [self promptForSource];
    } else {
        [self promptForPhotoRoll];
    }
}

- (void)promptForSource {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Roll", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) { // User did not tap on Cancel
        if (buttonIndex == actionSheet.firstOtherButtonIndex) {
            [self promptForCamera]; // User tapped on camera
        } else {
            [self promptForPhotoRoll]; // User tapped on photo roll
        }
    }
}

- (void)promptForCamera {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)promptForPhotoRoll {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // User picked something
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.pickedImage = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    // User canceled image picker
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*-- Finished handling pictures --*/


#pragma mark - Handle moods
- (void) setPickedMood:(enum DiaryEntryMood)pickedMood {
    _pickedMood = pickedMood;
    
    self.badButton.alpha = 0.5f;
    self.averageButton.alpha = 0.5f;
    self.goodButton.alpha = 0.5f;
    
    switch (pickedMood) {
        case DiaryEntryMoodGood:
            self.goodButton.alpha = 1.0f;
            break;
        case DiaryEntryMoodAverage:
            self.averageButton.alpha = 1.0f;
            break;
        case DiaryEntryMoodBad:
            self.badButton.alpha = 1.0f;
            break;
        default:
            break;
    }
}

- (IBAction)goodPressed:(id)sender {
    self.pickedMood = DiaryEntryMoodGood;
}

- (IBAction)averagePressed:(id)sender {
    self.pickedMood = DiaryEntryMoodAverage;
}

- (IBAction)badPressed:(id)sender {
    self.pickedMood = DiaryEntryMoodBad;
}

@end
