//
//  TeamTaskFilterLabel.m
//  CooperNative
//
//  Created by sunleepy on 12-9-20.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TeamTaskFilterLabel.h"

@implementation TeamTaskFilterLabel

@synthesize picker;
@synthesize values;
@synthesize currentValue;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    values = [[NSMutableArray array] retain];
    [values addObject:@"默认"];
    [values addObject:@"按执行人"];
    [values addObject:@"按项目"];
    [values addObject:@"按标签"];
    currentValue = @"默认";
              
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initalizeInputView];
        self.picker.delegate = self;
		self.picker.dataSource = self;
    }
    return self;
}

- (UIView *)inputAccessoryView {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return nil;
	} else {
		if (!inputAccessoryView) {
			inputAccessoryView = [[UIToolbar alloc] init];

            if(MODEL_VERSION > 5.0)
            {
                [inputAccessoryView setBackgroundImage:[UIImage imageNamed:TABBAR_BG_IMAGE] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
            }
            else
            {
                UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:TABBAR_BG_IMAGE]] autorelease];
                [imageView setFrame:CGRectMake(0, 0, [Tools screenMaxWidth], 49)];
                [inputAccessoryView insertSubview:imageView atIndex:0];
            }    
			inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
			[inputAccessoryView sizeToFit];
			CGRect frame = inputAccessoryView.frame;
			frame.size.height = 44.0f;
			inputAccessoryView.frame = frame;
			
			UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
			UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
			
			NSArray *array = [NSArray arrayWithObjects:flexibleSpaceLeft, doneBtn, nil];
			[inputAccessoryView setItems:array];
		}
		return inputAccessoryView;
	}
}

- (void)done:(id)sender
{
	[self resignFirstResponder];
    
    [delegate doneFilterCallback:self withValue:currentValue];
}
- (void)initalizeInputView {
	self.picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
	self.picker.showsSelectionIndicator = YES;
	self.picker.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		UIViewController *popoverContent = [[UIViewController alloc] init];
		popoverContent.view = self.picker;
		popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
		popoverController.delegate = self;
	}
}

- (BOOL)becomeFirstResponder {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CGSize pickerSize = [self.picker sizeThatFits:CGSizeZero];
        CGRect frame = self.picker.frame;
        frame.size = pickerSize;
        self.picker.frame = frame;
        popoverController.popoverContentSize = pickerSize;
        
        [popoverController presentPopoverFromRect:CGRectMake(self.frame.origin.x - 550, self.frame.origin.y, self.frame.size.width, self.frame.size.height) inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        // resign the current first responder
        for (UIView *subview in self.superview.subviews) {
            if ([subview isFirstResponder]) {
                [subview resignFirstResponder];
            }
        }
        return NO;
    } else {
        [self.picker setNeedsLayout];
    }
	return [super becomeFirstResponder];
}

- (void)deviceDidRotate:(NSNotification*)notification {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		// we should only get this call if the popover is visible
        //TODO:...
		[popoverController presentPopoverFromRect:self.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
}

- (BOOL)resignFirstResponder {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	//UITableView *tableView = (UITableView *)self.superview;
	//[tableView deselectRowAtIndexPath:[tableView indexPathForCell:self] animated:YES];
	return [super resignFirstResponder];
}

- (UIView *)inputView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return nil;
	} else {
		return self.picker;
	}
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    NSLog(@"setSelected");
//    [super setSelected:selected animated:animated];
//	if (selected) {
//		[self becomeFirstResponder];
//	}
//}

- (BOOL)hasText {
    return YES;
}

- (void)insertText:(NSString *)theText {
}

- (void)deleteBackward {
}

//- (void)setValue:(NSString *)v {
//	self.detailTextLabel.text = v;
//	[self.picker selectRow:[values indexOfObject:v] inComponent:0 animated:YES];
//}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return self.values.count;
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [self.values objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 44.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return 300.0f; //pickerView.bounds.size.width - 20.0f;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString* value = [values objectAtIndex:row];
    
    currentValue = value;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (delegate && [delegate respondsToSelector:@selector(tableViewCell:didEndEditingWithValue:)]) {
            [delegate tableViewCell:self didEndEditingWithValue:value];
        }
    }

}

@end
