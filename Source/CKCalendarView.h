//
// Copyright (c) 2012 Jason Kozemczak
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
// ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

@protocol CKCalendarDelegate;

@interface CKDateItem : NSObject

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *selectedBackgroundColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *selectedTextColor;

@end

typedef enum {
    startSunday = 1,
    startMonday = 2,
} CKCalendarStartDay;

@interface CKCalendarView : UIView

- (id)initWithStartDay:(CKCalendarStartDay)firstDay;
- (id)initWithStartDay:(CKCalendarStartDay)firstDay frame:(CGRect)frame;

@property (nonatomic) CKCalendarStartDay calendarStartDay;
@property (nonatomic, strong) NSLocale *locale;
@property (nonatomic) BOOL onlyShowCurrentMonth;
@property (nonatomic) BOOL adaptHeightToNumberOfWeeksInMonth;

@property (nonatomic, weak) id<CKCalendarDelegate> delegate;

// Theming
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *dateOfWeekFont;
@property (nonatomic, strong) UIColor *dayOfWeekTextColor;
@property (nonatomic, strong) UIFont *dateFont;

- (void)setMonthButtonColor:(UIColor *)color;
- (void)setInnerBorderColor:(UIColor *)color;
- (void)setDayOfWeekBottomColor:(UIColor *)bottomColor topColor:(UIColor *)topColor;

- (void)selectDate:(NSDate *)date makeVisible:(BOOL)visible;
- (void)reloadData;
- (void)reloadDates:(NSArray *)dates;

// Helper methods for delegates, etc.
- (BOOL)date:(NSDate *)date1 isSameDayAsDate:(NSDate *)date2;
- (BOOL)dateIsInCurrentMonth:(NSDate *)date;

@end

@protocol CKCalendarDelegate <NSObject>


@optional
- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date;
- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date;
- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date;
- (BOOL)calendar:(CKCalendarView *)calendar willDeselectDate:(NSDate *)date;
- (void)calendar:(CKCalendarView *)calendar didDeselectDate:(NSDate *)date;

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date;
- (void)calendar:(CKCalendarView *)calendar didChangeToMonth:(NSDate *)date;

@end