CKCalendar
==========

CKCalendar is a sleek, easily customizable calendar control for iOS. Simply add the header, implementation, and resource files to your project and link against it's framework dependencies: QuartzCore and CoreGraphics. 

![CKCalendar screenshot](http://cloud.github.com/downloads/jaykz52/CKCalendar/CKCalendar.png)

The default calendar design is courtesy of [John Anderson](http://twitter.com/jrileyd). Thanks John!

## Interacting with CKCalendar
CKCalendar provides delegate callbacks to interact with the calendar. To start, make sure to set the `delegate` property on your `CKCalendarView` instance:

``` objc
- (void)someMethod {
  CKCalendarView *calendar = [[CKCalendarView alloc] init];
  [self.view addSubview:calendar];
  calendar.delegate = self;
}
```

There are a number of delegate methods in the `CKCalendarDelegate` protocol that make it easy to customize and extend the calendar's behavior.

When a user attempts to select a date (via a tap), the calendar will call its delegate's `calendar:willSelectDate:` method (if your delegate implements it), passing in the date the user selected. Returning `NO` will deny the selection. If your app was for booking, for example, you might not want to allow selection if the date is already booked.

After the date has been selected, the calendar will call your delegate's `calendar:didSelectDate:` method, if you happen to implement it. You could use this callback to keep track of the date(s) the user has selected.

When a user taps an already selected date, the calendar will invoke the `calendar:willDeselectDate:`, followed by `calendar:didDeselectDate:` in the same way the above described selection lifecycle occurs.

Along the same lines, when a user attempts to move to the previous or next month, the calendar will call `calendar:willChangeToMonth:` on the delegate if the delegate implements it to give you a chance to decide whether you want to allow this. After the month has changed, the `calendar:didChangeToMonth:` delegate method will be called, passing the first day of the month along with it to the delegate.

### Configuring date items

To allow full control over the dates displayed, the delegate method `calendar:configureDateItem:forDate:` can be implemented. The calendar will pass an instance of a `CKDateItem` to its delegate; this dateItem can be modified, which will affect the display of the date it represents.

## Back-filling previous/next month
You can enable fully filling the remaining calendar space before and after the current month. The styling of the non-current month cells can be customized.
``` objc
calendarView.onlyShowCurrentMonth = NO;
```

## Customizing
The calendar was written to be easily styled so that you can make it feel seamless in your app. You can customize the fonts, text colors, and background colors of nearly every element. You can also configure what day of the week the calendar should start on. The calendar allows you to set optional minimum and/or maximum selectable dates (which are also stylable). If you still have a feature not yet met, add it! The code is readable and quite extendable at this point. Enjoy!

## License (MIT)
Copyright (c) 2013 Jason Kozemczak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.