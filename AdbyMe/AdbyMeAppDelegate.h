//
//  AdbyMeAppDelegate.h
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/2/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface AdbyMeAppDelegate : NSObject <UIApplicationDelegate> {
    HomeViewController *hViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) HomeViewController *hViewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
