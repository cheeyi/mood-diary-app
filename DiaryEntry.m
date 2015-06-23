//
//  DiaryEntry.m
//  Diary
//
//  Created by Chee Yi Ong on 6/20/15.
//  Copyright (c) 2015 Chee Yi Ong. All rights reserved.
//

#import "DiaryEntry.h"


@implementation DiaryEntry

@dynamic date;
@dynamic body;
@dynamic imageData;
@dynamic mood;
@dynamic location;

- (NSString *) sectionName {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM yyyy"];
    
    return [dateFormatter stringFromDate:date];
}
@end
