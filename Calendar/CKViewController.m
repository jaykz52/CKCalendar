//
//  CKViewController.m
//  Calendar
//
//  Created by Jason Kozemczak on 07/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CKViewController.h"
#import "IMCalendarView.h"

@interface CKViewController ()

@end

@implementation CKViewController

- (id)init {
    self = [super init];
    if (self) {
        IMCalendarView *calendar = [[IMCalendarView alloc] init];
        calendar.frame = CGRectMake(10, 10, 320, 292);
        [self.view addSubview:calendar];

        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end