//
//  DateView.h
//  CooperApp
//
//  Created by sunleepy on 13-1-6.
//  Copyright (c) 2013年 codesharp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateViewDelegate <NSObject>
@optional
- (void)returnValue:(NSDate *)value;
@end

@interface DateView : UIView<UIPopoverControllerDelegate>
{
    UIPopoverController *popoverController;
	UIToolbar *inputAccessoryView;
}
@property (retain, nonatomic) IBOutlet UILabel *dateField;

@property (nonatomic, strong) NSDate *dateValue;
@property (nonatomic, assign) UIDatePickerMode datePickerMode;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (strong) IBOutlet id<DateViewDelegate> delegate;

- (void)setMaxDate:(NSDate *)max;
- (void)setMinDate:(NSDate *)min;
- (void)setMinuteInterval:(NSUInteger)value;
@end
