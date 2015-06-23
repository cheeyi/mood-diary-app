//
//  NewEntryViewController.h
//  Diary
//
//  Created by Chee Yi Ong on 6/20/15.
//  Copyright (c) 2015 Chee Yi Ong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiaryEntry;

@interface EntryViewController : UIViewController
@property (strong,nonatomic) DiaryEntry *entry;
@end
