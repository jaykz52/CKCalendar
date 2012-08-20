#import <CoreGraphics/CoreGraphics.h>
#import "CKViewController.h"
#import "CKCalendarView.h"

@interface CKViewController () <CKCalendarDelegate>

@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation CKViewController

@synthesize dateLabel = _dateLabel;
@synthesize dateFormatter = _dateFormatter;

- (id)init {
    self = [super init];
    if (self) {
        CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
        calendar.delegate = self;

        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
        calendar.selectedDate = [self.dateFormatter dateFromString:@"18/07/2012"];
        calendar.minimumDate = [self.dateFormatter dateFromString:@"09/07/2012"];
        calendar.maximumDate = [self.dateFormatter dateFromString:@"29/07/2012"];

        calendar.frame = CGRectMake(10, 10, 300, 320);
        [self.view addSubview:calendar];

        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(calendar.frame) + 4, self.view.bounds.size.width, 24)];
        [self.view addSubview:self.dateLabel];

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

#pragma mark -
#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    self.dateLabel.text = [self.dateFormatter stringFromDate:date];
}


@end