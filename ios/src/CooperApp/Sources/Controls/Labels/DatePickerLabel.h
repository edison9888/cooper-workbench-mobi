//
//  DateTextField.h
//  CooperNative
//
//  Created by sunleepy on 12-12-23.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

@class DatePickerLabel;

@protocol DatePickerLabelDelegate <NSObject>
@optional
- (void)tableViewCell:(DatePickerLabel *)label didEndEditingWithDate:(NSDate *)value;
@end

@interface DatePickerLabel : UILabel<UIPopoverControllerDelegate>
{
    UIPopoverController *popoverController;
	UIToolbar *inputAccessoryView;
}

@property (nonatomic, strong) NSDate *dateValue;
@property (nonatomic, assign) UIDatePickerMode datePickerMode;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (strong) IBOutlet id<DatePickerLabelDelegate> delegate;

- (void)setMaxDate:(NSDate *)max;
- (void)setMinDate:(NSDate *)min;
- (void)setMinuteInterval:(NSUInteger)value;
@end
