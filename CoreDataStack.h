//
//  CoreDataStack.h
//  Diary
//
//  Created by Chee Yi Ong on 6/20/15.
//  Copyright (c) 2015 Chee Yi Ong. All rights reserved.
//
//  Purpose: Provide functionality to access Core Data

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CoreDataStack : NSObject // this is a singleton object!

+ (instancetype)defaultStack;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
