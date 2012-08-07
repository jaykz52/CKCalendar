CKCalendar
==========

CKCalendar is a sleek, easily customizable calendar control for iOS. Simply add the header, implementation, and resource files to your project and link against it's framework dependencies: QuartzCore and CoreGraphics. 

![CKCalendar screenshot](http://cloud.github.com/downloads/jaykz52/CKCalendar/CKCalendar.png)

The default calendar design is courtesy of [John Anderson](http://twitter.com/jrileyd). Thanks John!

## Interacting with CKCalendar
CKCalendar provides delegate callbacks to interact with the calendar in the way you would expect:

``` objc
- (void)someMethod {
  CKCalendarView *calendar = [[CKCalendarView alloc] init];
  [self.view addSubview:calendar];
  calendar.delegate = self;
}

// snip...

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
  // show the user the date they selected  
  self.dateLabel.text = [date description];
}

```

## Customizing
The calendar was written to be easily styled so that you can make it feel seamless in your app. You can customize the fonts, text colors, and background colors of nearly every element. You can also configure what day of the week the calendar should start on. The calendar allows you to set optional minimum and/or maximum selectable dates (which are also stylable). If you still have a feature not yet met, add it! The code is readable and quite extendable at this point. Enjoy!

## License (MIT)
Copyright (c) 2012 Jason Kozemczak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.