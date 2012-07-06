//
//  CKAppDelegate.h
//  Calendar
//
//  Created by Jason Kozemczak on 07/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CKViewController;

@interface CKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CKViewController *viewController;

@end