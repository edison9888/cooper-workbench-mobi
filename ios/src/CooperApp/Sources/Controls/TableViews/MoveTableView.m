//
//  MoveTableView.m
//  CodesharpSDK
//
//  Created by sunleepy on 12-8-21.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "MoveTableView.h"
#import "MoveTableViewCell.h"

@interface SnapShotImageView : UIImageView

- (void)moveByOffset:(CGPoint)offset;

@end


@implementation SnapShotImageView

#pragma mark -
#pragma mark Autoscroll utilites

- (void)moveByOffset:(CGPoint)offset 
{
    CGRect frame = [self frame];
    frame.origin.x += offset.x;
    frame.origin.y += offset.y;
    [self setFrame:frame];
}

@end


@interface UIGestureRecognizer(Utilities)

- (void)cancelTouch;

@end



@implementation UIGestureRecognizer(Utilities)

- (void)cancelTouch
{
	[self setEnabled:NO];
	[self setEnabled:YES];
}

@end



@interface MoveTableView()

@property (nonatomic, assign) CGPoint touchOffset;
@property (nonatomic, strong) SnapShotImageView *snapShotImageView;
@property (nonatomic, strong) UILongPressGestureRecognizer *movingGestureRecognizer;

@property (nonatomic, strong) NSTimer *autoscrollTimer;
@property (nonatomic, assign) NSInteger autoscrollDistance;
@property (nonatomic, assign) NSInteger autoscrollThreshold;

@end



/**
 * The autoscroll methods are based on Apple's sample code 'ScrollViewSuite'
 */

@interface MoveTableView(AutoscrollingMethods)

- (void)maybeAutoscrollForSnapShotImageView:(SnapShotImageView *)snapShot;
- (void)autoscrollTimerFired:(NSTimer *)timer;
- (void)legalizeAutoscrollDistance;
- (float)autoscrollDistanceForProximityToEdge:(float)proximity;
- (void)stopAutoscrolling;

@end




@implementation MoveTableView

@dynamic dataSource;
@dynamic delegate;
@synthesize movingIndexPath = _movingIndexPath;
@synthesize touchOffset = _touchOffset;
@synthesize snapShotImageView = _snapShotImageView;
@synthesize movingGestureRecognizer = _movingGestureRecognizer;

@synthesize autoscrollTimer = _autoscrollTimer;
@synthesize autoscrollDistance = _autoscrollDistance;
@synthesize autoscrollThreshold = _autoscrollThreshold;


#pragma mark -
#pragma mark View life cycle

- (void)setup
{
	UILongPressGestureRecognizer *movingGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
	[self addGestureRecognizer:movingGestureRecognizer];
	[self setMovingGestureRecognizer:movingGestureRecognizer];
}


- (void)awakeFromNib
{
	[super awakeFromNib];
	
	[self setup];
}


- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
	self = [super initWithFrame:frame style:style];
	
	if (self) {
		[self setup];
	}
	
	return self;
}



#pragma mark -
#pragma mark Helper methods

- (BOOL)indexPathIsMovingIndexPath:(NSIndexPath *)indexPath
{
	return ([indexPath compare:[self movingIndexPath]] == NSOrderedSame);
}


- (void)moveRowToLocation:(CGPoint)location 
{
	NSIndexPath *newIndexPath = [self indexPathForRowAtPoint:location];
    if(newIndexPath == nil)
        return;
    NSLog(@"moveRowToLocation:%d,%d", newIndexPath.section, newIndexPath.row);
	
	if ([newIndexPath section] != NSNotFound && [newIndexPath row] != NSNotFound 
        //		&& [newIndexPath compare:[self movingIndexPath]] != NSOrderedSame
        //		&& newIndexPath == [[self delegate] moveTableView:self targetIndexPathForMoveFromRowAtIndexPath:[self movingIndexPath] toProposedIndexPath:newIndexPath]
		) 
	{  
        NSLog(@"newIndexPath:%d,%d", newIndexPath.section, newIndexPath.row);
        
        if(newIndexPath.section != self.movingIndexPath.section)
        {
            //[self deleteRowsAtIndexPaths:[NSArray arrayWithObject:[self movingIndexPath]] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [self beginUpdates];
            
            // Move the row
            [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:[self movingIndexPath]] withRowAnimation:UITableViewRowAnimationAutomatic];
            if(newIndexPath) 
                [self insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            else {
                [self insertRowsAtIndexPaths:[NSArray arrayWithObject:self.movingIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            // Inform the delegate to update it's model
            if ([[self dataSource] respondsToSelector:@selector(moveTableView:moveRowFromIndexPath:toIndexPath:)]) {
                [[self dataSource] moveTableView:self moveRowFromIndexPath:[self movingIndexPath] toIndexPath:newIndexPath];
            }
            
            // Update the moving index path
            [self setMovingIndexPath:newIndexPath];
            [self endUpdates];
        }
        else 
        {
            [self beginUpdates];
            
            // Move the row
            [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:[self movingIndexPath]] withRowAnimation:UITableViewRowAnimationAutomatic];
            if(newIndexPath) 
                [self insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            else {
                [self insertRowsAtIndexPaths:[NSArray arrayWithObject:self.movingIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            // Inform the delegate to update it's model
            if ([[self dataSource] respondsToSelector:@selector(moveTableView:moveRowFromIndexPath:toIndexPath:)]) {
                [[self dataSource] moveTableView:self moveRowFromIndexPath:[self movingIndexPath] toIndexPath:newIndexPath];
                [self.dataSource numberOfSectionsInTableView:self];
            }
            
            // Update the moving index path
            [self setMovingIndexPath:newIndexPath];
            [self endUpdates];
        }
	}
}



#pragma mark -
#pragma mark Handle long press

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
	switch ([gestureRecognizer state]) 
	{
		case UIGestureRecognizerStateBegan:
		{
			CGPoint touchPoint = [gestureRecognizer locationInView:self];
			
			// Grap the touched index path
			NSIndexPath *touchedIndexPath = [self indexPathForRowAtPoint:touchPoint];
            
			// Check for a valid index path, otherwise cancel the touch
			if (!touchedIndexPath || [touchedIndexPath section] == NSNotFound || [touchedIndexPath row] == NSNotFound) {
				[gestureRecognizer cancelTouch];
				break;
			}
			
			[self setMovingIndexPath:touchedIndexPath];
			
			// Get the touched cell and reset it's selection state
			MoveTableViewCell *touchedCell = (MoveTableViewCell *)[self cellForRowAtIndexPath:touchedIndexPath];
			[touchedCell setSelected:NO];
			[touchedCell setHighlighted:NO];
			
			// Compute the touch offset from the cell's center
			CGPoint touchOffset = CGPointMake([touchedCell center].x - touchPoint.x, [touchedCell center].y - touchPoint.y);
			[self setTouchOffset:touchOffset];
			
			
			// Create a snap shot of the touched cell and store it
			CGRect cellFrame = [touchedCell bounds];
			
			if ([[UIScreen mainScreen] scale] == 2.0) {
				UIGraphicsBeginImageContextWithOptions(cellFrame.size, NO, 2.0);
			} else {
				UIGraphicsBeginImageContext(cellFrame.size);
			}
			
			[[touchedCell layer] renderInContext:UIGraphicsGetCurrentContext()];
			UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();
			
			SnapShotImageView *snapShotOfMovingCell = [[SnapShotImageView alloc] initWithImage:image];
			CGRect snapShotFrame = [self rectForRowAtIndexPath:touchedIndexPath];
			snapShotFrame.size = cellFrame.size;
			[snapShotOfMovingCell setFrame:snapShotFrame];
			[snapShotOfMovingCell setAlpha:0.95];
			
			[self setSnapShotImageView:snapShotOfMovingCell];
			[self addSubview:[self snapShotImageView]];
			
			
			// Prepare the cell for moving (e.g. clear it's labels and imageView)
			//[touchedCell prepareForMove];
            touchedCell.textLabel.text = @"";
			
			// Inform the delegate about the beginning of the move
			if ([[self delegate] respondsToSelector:@selector(moveTableView:willMoveRowAtIndexPath:)]) {
				[[self delegate] moveTableView:self willMoveRowAtIndexPath:touchedIndexPath];
			}
			
			// Set a threshold for autoscrolling and reset the autoscroll distance
			[self setAutoscrollThreshold:([[self snapShotImageView] frame].size.height * 0.6)];
			[self setAutoscrollDistance:0.0];
			
			break;
		}
			
		case UIGestureRecognizerStateChanged:
		{
			CGPoint touchPoint = [gestureRecognizer locationInView:self];
			
			// Update the snap shot's position
			CGPoint currentCenter = [[self snapShotImageView] center];
			[[self snapShotImageView] setCenter:CGPointMake(currentCenter.x, touchPoint.y + [self touchOffset].y)];
			
			// Check if the table view has to scroll
			[self maybeAutoscrollForSnapShotImageView:[self snapShotImageView]];
			
			// If the table view does not scroll, compute a new index path for the moving cell
			if ([self autoscrollDistance] == 0) {
				[self moveRowToLocation:touchPoint];
			}
			
			break;
		}
			
		case UIGestureRecognizerStateEnded:
		{
			[self stopAutoscrolling];
			
			// Get to final index path
			CGRect finalFrame = [self rectForRowAtIndexPath:[self movingIndexPath]];
			
			// Place the snap shot to it's final position and fade it out
			[UIView animateWithDuration:0.2
							 animations:^{
								 
								 [[self snapShotImageView] setFrame:finalFrame];
								 [[self snapShotImageView] setAlpha:1.0];
								 
							 }
							 completion:^(BOOL finished) {
								 
								 if (finished) 
								 {
									 // Clean up snap shot
									 [[self snapShotImageView] removeFromSuperview];
									 [self setSnapShotImageView:nil];
									 
									 // Reload row at moving index path to reset it's content
									 NSIndexPath *movingIndexPath = [self movingIndexPath];
									 //[self setMovingIndexPath:nil];
									 [self reloadRowsAtIndexPaths:[NSArray arrayWithObject:movingIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                                     [self setMovingIndexPath:nil];
								 }
								 
							 }];			
			
			break;
		}
			
		default:
		{
			// Do some cleanup if necessary
			if ([self movingIndexPath]) 
			{
				[self stopAutoscrolling];
				
				[[self snapShotImageView] removeFromSuperview];
				[self setSnapShotImageView:nil];
				
				NSIndexPath *movingIndexPath = [self movingIndexPath];
				[self setMovingIndexPath:nil];
				[self reloadRowsAtIndexPaths:[NSArray arrayWithObject:movingIndexPath] withRowAnimation:UITableViewRowAnimationNone];
			}
			
			break;
		}
	}
}



#pragma mark -
#pragma mark Autoscrolling

- (void)maybeAutoscrollForSnapShotImageView:(SnapShotImageView *)snapShot
{
    [self setAutoscrollDistance:0];
    
    if (CGRectIntersectsRect([snapShot frame], [self bounds])) 
	{
		CGPoint touchLocation = [[self movingGestureRecognizer] locationInView:self];
		touchLocation.y += [self touchOffset].y;
		
        float distanceToTopEdge  = touchLocation.y - CGRectGetMinY([self bounds]);
        float distanceToBottomEdge = CGRectGetMaxY([self bounds]) - touchLocation.y;
		
        if (distanceToTopEdge < [self autoscrollThreshold]) 
		{
            [self setAutoscrollDistance:[self autoscrollDistanceForProximityToEdge:distanceToTopEdge] * -1];
        } 
		else if (distanceToBottomEdge < [self autoscrollThreshold]) 
		{
            [self setAutoscrollDistance:[self autoscrollDistanceForProximityToEdge:distanceToBottomEdge]];
        }
    }
    
    if ([self autoscrollDistance] == 0) 
	{
        [[self autoscrollTimer] invalidate];
        [self setAutoscrollTimer:nil];
    } 
    else if (![self autoscrollTimer]) 
	{
        NSTimer *autoscrollTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 60.0) target:self selector:@selector(autoscrollTimerFired:) userInfo:snapShot repeats:YES];
		[self setAutoscrollTimer:autoscrollTimer];
    } 
}


- (float)autoscrollDistanceForProximityToEdge:(float)proximity 
{
    return ceilf(([self autoscrollThreshold] - proximity) / 5.0);
}


- (void)legalizeAutoscrollDistance 
{
    float minimumLegalDistance = [self contentOffset].y * -1;
    float maximumLegalDistance = [self contentSize].height - ([self frame].size.height + [self contentOffset].y);
    [self setAutoscrollDistance:MAX([self autoscrollDistance], minimumLegalDistance)];
    [self setAutoscrollDistance:MIN([self autoscrollDistance], maximumLegalDistance)];
}


- (void)autoscrollTimerFired:(NSTimer *)timer 
{
    [self legalizeAutoscrollDistance];
    
    CGPoint contentOffset = [self contentOffset];
    contentOffset.y += [self autoscrollDistance];
    [self setContentOffset:contentOffset];
    
	// Move the snap shot appropriately
    SnapShotImageView *snapShot = (SnapShotImageView *)[timer userInfo];
    [snapShot moveByOffset:CGPointMake(0, [self autoscrollDistance])];
	
	// Even if we autoscroll we need to update the moved cell's index path
	CGPoint touchLocation = [[self movingGestureRecognizer] locationInView:self];
	[self moveRowToLocation:touchLocation];
}


- (void)stopAutoscrolling
{
	[self setAutoscrollDistance:0];
	[[self autoscrollTimer] invalidate];
	[self setAutoscrollTimer:nil];
}


#pragma mark -
#pragma mark Accessor methods

- (void)setSnapShotImageView:(SnapShotImageView *)snapShotImageView
{
	if (snapShotImageView)
	{
		// Create the shadow if a new snap shot is created
		[[snapShotImageView layer] setShadowOpacity:0.7];
		[[snapShotImageView layer] setShadowRadius:3];
		[[snapShotImageView layer] setShadowOffset:CGSizeZero];
		
		CGPathRef shadowPath = [[UIBezierPath bezierPathWithRect:[[snapShotImageView layer] bounds]] CGPath];
		[[snapShotImageView layer] setShadowPath:shadowPath];
	}
	
	_snapShotImageView = snapShotImageView;
}


@end
