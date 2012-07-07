#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "IMCalendarView.h"
#import "GradientView.h"

#define CELL_WIDTH 43
#define BUTTON_MARGIN 4

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface DateButton : UIButton

@property (nonatomic, strong) NSDate *date;

@end

@implementation DateButton

@synthesize date = _date;

- (void)setDate:(NSDate *)aDate {
    _date = aDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"d";
    [self setTitle:[dateFormatter stringFromDate:_date] forState:UIControlStateNormal];
}

@end

@interface IMCalendarView ()

@property(nonatomic, strong) UIButton *prevButton;
@property(nonatomic, strong) UIButton *nextButton;
@property(nonatomic, strong) GradientView *daysHeader;
@property(nonatomic, strong) NSArray *dayOfWeekLabels;
@property(nonatomic, strong) NSMutableArray *dateButtons;
@property(nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSDate *monthShowing;
@property (nonatomic, strong) NSCalendar *calendar;

@end

@implementation IMCalendarView

@synthesize prevButton = _prevButton;
@synthesize nextButton = _nextButton;
@synthesize daysHeader = _daysHeader;
@synthesize dayOfWeekLabels = _dayOfWeekLabels;
@synthesize dateButtons = _dateButtons;
@synthesize titleLabel = _titleLabel;
@synthesize calendarContainer = _calendarContainer;

@synthesize monthShowing = _monthShowing;
@synthesize calendar = _calendar;

@synthesize selectedDate = _selectedDate;
@synthesize delegate = _delegate;

@synthesize selectedDateTextColor = _selectedDateTextColor;
@synthesize selectedDateBackgroundColor = _selectedDateBackgroundColor;
@synthesize currentDateTextColor = _currentDateTextColor;
@synthesize currentDateBackgroundColor = _currentDateBackgroundColor;

- (id)init {
    self = [super init];
    if (self) {
        self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

        self.layer.cornerRadius = 6.0f;
        self.layer.shadowOffset = CGSizeMake(3, 3);
        self.layer.shadowRadius = 3.0f;
        self.layer.shadowOpacity = 0.4f;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

        // SET UP THE HEADER
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;

        UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [prevButton setImage:[UIImage imageNamed:@"left_arrow.png"] forState:UIControlStateNormal];
//        [prevButton setTitle:@"Prev" forState:UIControlStateNormal];
        prevButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [prevButton addTarget:self action:@selector(moveCalendarToPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:prevButton];
        self.prevButton = prevButton;

        UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextButton setImage:[UIImage imageNamed:@"right_arrow.png"] forState:UIControlStateNormal];
//        [nextButton setTitle:@"Next" forState:UIControlStateNormal];
        nextButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        [nextButton addTarget:self action:@selector(moveCalendarToNextMonth) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextButton];
        self.nextButton = nextButton;

        // THE CALENDAR ITSELF
        UIView *calendarContainer = [[UIView alloc] initWithFrame:CGRectZero];
        calendarContainer.layer.borderWidth = 1.0f;
        calendarContainer.layer.borderColor = [UIColor blackColor].CGColor;
        calendarContainer.backgroundColor = UIColorFromRGB(0xDAE1E6);
        calendarContainer.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        calendarContainer.layer.cornerRadius = 4.0f;
        calendarContainer.clipsToBounds = YES;
        [self addSubview:calendarContainer];
        self.calendarContainer = calendarContainer;

        GradientView *daysHeader = [[GradientView alloc] initWithFrame:CGRectZero];
        daysHeader.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self.calendarContainer addSubview:daysHeader];
        self.daysHeader = daysHeader;

        NSMutableArray *labels = [NSMutableArray array];
        for (NSString *day in [NSArray arrayWithObjects:@"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", nil]) {
            UILabel *dayOfWeekLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            dayOfWeekLabel.text = [day uppercaseString];
            dayOfWeekLabel.textAlignment = UITextAlignmentCenter;
            dayOfWeekLabel.backgroundColor = [UIColor clearColor];
            dayOfWeekLabel.shadowColor = [UIColor whiteColor];
            dayOfWeekLabel.shadowOffset = CGSizeMake(0, 1);
            [labels addObject:dayOfWeekLabel];
            [self.calendarContainer addSubview:dayOfWeekLabel];
        }
        self.dayOfWeekLabels = labels;

        // at most we'll need 40 or so buttons, so let's just bite the bullet and make them now...
        NSMutableArray *dateButtons = [NSMutableArray array];
        dateButtons = [NSMutableArray array];
        for (int i = 0; i < 50; i++) {
            DateButton *dateButton = [DateButton buttonWithType:UIButtonTypeCustom];
            [dateButton setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
            [dateButton addTarget:self action:@selector(dateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [dateButtons addObject:dateButton];
        }
        self.dateButtons = dateButtons;

        // TODO: we need to "backfill" the remaining spots in the first and last row with dates in previous/next month..

        // JUST TO GET US IN A GOOD STATE
        self.monthShowing = [NSDate date];
    }

    // set some default colors
    [self setDefaultStyle];

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.titleLabel.frame = CGRectMake(0, 0, self.bounds.size.width, 44);
    self.prevButton.frame = CGRectMake(BUTTON_MARGIN, BUTTON_MARGIN, 48, 38);
    self.nextButton.frame = CGRectMake(self.bounds.size.width - 48 - BUTTON_MARGIN, BUTTON_MARGIN, 48, 38);

    self.calendarContainer.frame = CGRectMake(5, CGRectGetMaxY(self.titleLabel.frame), self.bounds.size.width - (5 * 2), self.bounds.size.height - CGRectGetMaxY(self.titleLabel.frame) - 5);
    self.daysHeader.frame = CGRectMake(0, 0, self.calendarContainer.frame.size.width, 22);

    CGRect lastDayFrame = CGRectZero;
    for (UILabel *dayLabel in self.dayOfWeekLabels) {
        dayLabel.frame = CGRectMake(CGRectGetMaxX(lastDayFrame) + 1, lastDayFrame.origin.y, CELL_WIDTH, self.daysHeader.frame.size.height);
        lastDayFrame = dayLabel.frame;
    }

    for (DateButton *dateButton in self.dateButtons) {
        [dateButton removeFromSuperview];
    }

    NSDate *date = [self firstDayOfMonthContainingDate:self.monthShowing];
    int dateButtonPosition = 0;
    while ([self dateIsInMonthShowing:date]) {
        DateButton *dateButton = [self.dateButtons objectAtIndex:dateButtonPosition];

        dateButton.date = date;
        if ([dateButton.date isEqualToDate:self.selectedDate]) {
            dateButton.backgroundColor = UIColorFromRGB(0x88B6DB);
            [dateButton setTitleColor:UIColorFromRGB(0xF2F2F2) forState:UIControlStateNormal];
        } else if ([self dateIsToday:dateButton.date]) {
            dateButton.backgroundColor = [UIColor lightGrayColor];
            [dateButton setTitleColor:UIColorFromRGB(0xF2F2F2) forState:UIControlStateNormal];
        } else {
            dateButton.backgroundColor = [self dateBackgroundColor];
            [dateButton setTitleColor:[self dateTextColor] forState:UIControlStateNormal];
        }

        dateButton.frame = [self calculateDayCellFrame:date];

        [self.calendarContainer addSubview:dateButton];

        date = [self nextDay:date];
        dateButtonPosition++;
    }
}

- (void)setMonthShowing:(NSDate *)aMonthShowing {
    _monthShowing = aMonthShowing;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMMM YYYY";
    self.titleLabel.text = [dateFormatter stringFromDate:aMonthShowing];
    [self setNeedsLayout];
}

- (void)setDefaultStyle {
    self.backgroundColor = UIColorFromRGB(0x393B40);

    [self setTitleColor:[UIColor whiteColor]];
    [self setTitleFont:[UIFont boldSystemFontOfSize:17.0]];

    [self setDayOfWeekFont:[UIFont boldSystemFontOfSize:12.0]];
    [self setDayOfWeekTextColor:UIColorFromRGB(0xA9A9A9)];
    [self setDayOfWeekBottomColor:UIColorFromRGB(0xCCCFD5) topColor:[UIColor whiteColor]];

    [self setDateFont:[UIFont boldSystemFontOfSize:16.0f]];
    [self setDateTextColor:UIColorFromRGB(0x393B40)];
    [self setDateBackgroundColor:UIColorFromRGB(0xF2F2F2)];
}

- (CGRect)calculateDayCellFrame:(NSDate *)date {
    int row = [self weekNumberInMonthForDate:date] - 1;
    int placeInWeek = [self dayOfWeekForDate:date] - 1;

    return CGRectMake(placeInWeek * (CELL_WIDTH + 1), (row * (CELL_WIDTH + 1)) + CGRectGetMaxY(self.daysHeader.frame) + 1, CELL_WIDTH, CELL_WIDTH);
}

- (void)moveCalendarToNextMonth {
    NSDateComponents* comps = [[NSDateComponents alloc]init];
    [comps setMonth:1];
    self.monthShowing = [self.calendar dateByAddingComponents:comps toDate:self.monthShowing options:0];
}

- (void)moveCalendarToPreviousMonth {
    self.monthShowing = [[self firstDayOfMonthContainingDate:self.monthShowing] dateByAddingTimeInterval:-100000];
}

- (void)dateButtonPressed:(id)sender {
    DateButton *dateButton = sender;
    self.selectedDate = dateButton.date;
    [self setNeedsLayout];
}

#pragma mark - Styling getters/setters

- (void)setTitleFont:(UIFont *)font {
    self.titleLabel.font = font;
}
- (UIFont *)titleFont {
    return self.titleLabel.font;
}

- (void)setTitleColor:(UIColor *)color {
    self.titleLabel.textColor = color;
}
- (UIColor *)titleColor {
    return self.titleLabel.textColor;
}

- (void)setDayOfWeekFont:(UIFont *)font {
    for (UILabel *label in self.dayOfWeekLabels) {
        label.font = font;
    }
}
- (UIFont *)dayOfWeekFont {
    return (self.dayOfWeekLabels.count > 0) ? ((UILabel *)[self.dayOfWeekLabels lastObject]).font : nil;
}

- (void)setDayOfWeekTextColor:(UIColor *)color {
    for (UILabel *label in self.dayOfWeekLabels) {
        label.textColor = color;
    }
}
- (UIColor *)dayOfWeekTextColor {
    return (self.dayOfWeekLabels.count > 0) ? ((UILabel *)[self.dayOfWeekLabels lastObject]).textColor : nil;
}

- (void)setDayOfWeekBottomColor:(UIColor *)bottomColor topColor:(UIColor *)topColor {
    [self.daysHeader setColors:[NSArray arrayWithObjects:topColor, bottomColor, nil]];
}

- (void)setDateFont:(UIFont *)font {
    for (DateButton *dateButton in self.dateButtons) {
        dateButton.titleLabel.font = font;
    }
}
- (UIFont *)dateFont {
    return (self.dateButtons.count > 0) ? ((DateButton *)[self.dateButtons lastObject]).titleLabel.font : nil;
}

- (void)setDateTextColor:(UIColor *)color {
    for (DateButton *dateButton in self.dateButtons) {
        [dateButton setTitleColor:color forState:UIControlStateNormal];
    }
}
- (UIColor *)dateTextColor {
    return (self.dateButtons.count > 0) ? [((DateButton *)[self.dateButtons lastObject]) titleColorForState:UIControlStateNormal] : nil;
}

- (void)setDateBackgroundColor:(UIColor *)color {
    for (DateButton *dateButton in self.dateButtons) {
        dateButton.backgroundColor = color;
    }
}
- (UIColor *)dateBackgroundColor {
    return (self.dateButtons.count > 0) ? ((DateButton *)[self.dateButtons lastObject]).backgroundColor : nil;
}

- (void)setDateBorderColor:(UIColor *)color {
    self.calendarContainer.backgroundColor = color;
}
- (UIColor *)dateBorderColor {
    return self.calendarContainer.backgroundColor;
}

#pragma mark - Calendar helpers

- (NSDate *)firstDayOfMonthContainingDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [comps setDay:1];
    return [self.calendar dateFromComponents:comps];
}

- (int)dayOfWeekForDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:NSWeekdayCalendarUnit fromDate:date];
    return comps.weekday;
}

- (BOOL)dateIsToday:(NSDate *)date {
    NSDateComponents *otherDay = [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSDateComponents *today = [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    return ([today day] == [otherDay day] &&
            [today month] == [otherDay month] &&
            [today year] == [otherDay year] &&
            [today era] == [otherDay era]);
}

- (int)weekNumberInMonthForDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:(NSWeekOfMonthCalendarUnit) fromDate:date];
    return comps.weekOfMonth;
}

- (BOOL)dateIsInMonthShowing:(NSDate *)date {
    NSDateComponents *comps1 = [self.calendar components:(NSMonthCalendarUnit) fromDate:self.monthShowing];
    NSDateComponents *comps2 = [self.calendar components:(NSMonthCalendarUnit) fromDate:date];
    return comps1.month == comps2.month;
}

- (NSDate *)nextDay:(NSDate *)date {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    return [self.calendar dateByAddingComponents:comps toDate:date options:0];
}

@end