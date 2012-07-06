@protocol IMCalendarDelegate;
@class IMGradientButton;

@interface IMCalendarView : UIView

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, weak) id<IMCalendarDelegate> delegate;

@property(nonatomic, strong) UIView *calendarContainer;
@end

@protocol IMCalendarDelegate <NSObject>

- (void)calendar:(IMCalendarView *)calendar didSelectDate:(NSDate *)date;

@end