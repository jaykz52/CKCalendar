#import "CKViewController.h"
#import "CKCalendarView.h"

@interface CKViewController ()

@end

@implementation CKViewController

- (id)init {
    self = [super init];
    if (self) {
        CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        calendar.selectedDate = [dateFormatter dateFromString:@"18/07/2012"];
        calendar.minimumDate = [dateFormatter dateFromString:@"09/07/2012"];
        calendar.maximumDate = [dateFormatter dateFromString:@"29/07/2012"];
        calendar.frame = CGRectMake(10, 10, 300, 470);
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