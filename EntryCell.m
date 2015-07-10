//
//  EntryCell.m
//  Diary
//
//  Created by Chee Yi Ong on 6/20/15.
//  Copyright (c) 2015 Chee Yi Ong. All rights reserved.
//

#import "EntryCell.h"
#import "DiaryEntry.h"
#import <QuartzCore/QuartzCore.h>

@interface EntryCell()
// Private IBOutlet
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIImageView *moodImageView;

@end

@implementation EntryCell


#pragma mark - Boilerplate code
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Method implementations 
// Dynamically calculate the height of the entry label
+(CGFloat) heightForEntry: (DiaryEntry *)entry {
    const CGFloat topMargin = 35.0f;
    const CGFloat bottomMargin = 90.0f;
    const CGFloat minHeight = 165.0f;
    
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGRect boundingBox = [entry.body boundingRectWithSize:CGSizeMake(210.0f, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: font} context:nil];
    
    return MAX(minHeight, CGRectGetHeight(boundingBox) + topMargin + bottomMargin);
}


- (void)configureCellForEntry: (DiaryEntry *)entry {
    self.bodyLabel.text = entry.body;
    self.locationLabel.text = entry.location;
    
    // Set up date label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm a - MMMM d"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:entry.date];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    // Show image if present
    if (entry.imageData) {
        self.mainImageView.image = [UIImage imageWithData:entry.imageData];
    } else {
        self.mainImageView.image = [UIImage imageNamed:@"icn_noimage"];
    }
    // Nice rounded circular edges around image
    self.mainImageView.layer.cornerRadius = CGRectGetWidth(self.mainImageView.frame)/2.0f;
    
    // Show mood if present
    if (entry.mood == DiaryEntryMoodGood) {
        self.moodImageView.image = [UIImage imageNamed:@"icn_happy"];
    } else if (entry.mood == DiaryEntryMoodBad) {
        self.moodImageView.image = [UIImage imageNamed:@"icn_bad"];
    } else if (entry.mood == DiaryEntryMoodAverage) {
        self.moodImageView.image = [UIImage imageNamed:@"icn_average"];
    }
    
    // Show location if found
    if (entry.location.length > 0) {
        self.locationLabel.text = entry.location;
    } else {
        self.locationLabel.text = @"No location";
    }
    
}

@end
