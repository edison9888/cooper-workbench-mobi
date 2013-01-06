//
//  DateLabel.h
//  Cooper
//
//  Created by Ping Li on 12-7-26.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

@class DateButton;

@protocol DateButtonDelegate <NSObject>

- (void)returnValue:(NSDate *)value;

@end

@interface DateButton : UIButton<UIPopoverControllerDelegate>
{
    UIPopoverController *popoverController;
	UIToolbar *inputAccessoryView;
}
@property (retain, nonatomic) IBOutlet UILabel *dateField;

@property (nonatomic, strong) NSDate *dateValue;
@property (nonatomic, assign) UIDatePickerMode datePickerMode;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, assign) id<DateButtonDelegate> delegate;

- (void)setMaxDate:(NSDate *)max;
- (void)setMinDate:(NSDate *)min;
- (void)setMinuteInterval:(NSUInteger)value;
@end
