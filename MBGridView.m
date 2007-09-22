#import <CoreFoundation/CoreFoundation.h>

#import "MBGridView.h"

#import <UIKit/UIBezierPath.h>

struct CGRect GSEventGetLocationInWindow(struct __GSEvent *ev);

// struct CGRect GSEventGetLocationInWindow(GSEvent *ev);

@implementation MBGridView

- (id)initWithFrame:(struct CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
	
	//NSLog(@"IFTweetKeyboard: initWithFrame:");
	//[UIKeyboard initImplementationNow];
	//NSLog(@"IFTweetKeyboard: initWithFrame: delegate = %@", [self delegate]);
	//NSLog(@"IFTweetKeyboard: initWithFrame: defaultTextTraits = %@", [self defaultTextTraits]);
	//NSLog(@"IFTweetKeyboard: initWithFrame: editingDelegate = %@", [[self defaultTextTraits] editingDelegate]);
	
	_frame = frame;
	
	float boxback[4] = {1, 1, 1, 1};
	[self setBackgroundColor: CGColorCreate( CGColorSpaceCreateDeviceRGB(), boxback)];	
	
	return self;
}

- (void)drawRect:(struct CGRect)rect{
	NSLog(@"BLAH");
	[self _drawGrid];
	[self _drawFilledIn];
	[self _drawPlayhead];
}

- (void)setTime:(float)time{
	//time is a number between 0 and 1.
}

#define GRID_WIDTH 8
#define GRID_HEIGHT 8

- (void)_drawGrid{
	//draw a grid of 1m x 1m squares.
	
	//NSRect bds = [self bounds];
	struct CGRect bds = _frame;
	int i, jump;
	
	UIBezierPath *path = [UIBezierPath bezierPath];
	[path setLineWidth:1];
	
	jump = (bds.size.width / GRID_WIDTH);
	
	for(i = 0; i <= bds.size.width; i+=jump){
		struct CGPoint start = CGPointMake(i,bds.size.height);
		struct CGPoint end = CGPointMake(i,0);

        [path moveToPoint:start];
        [path lineToPoint:end];
	}
	
	jump = (bds.size.height / GRID_HEIGHT);
	
	for(i = 0; i <= bds.size.height; i += jump){
        struct CGPoint start = CGPointMake(0, i);
		struct CGPoint end = CGPointMake(bds.size.width, i);

        [path moveToPoint:start];
        [path lineToPoint:end];
    }
	
	[path moveToPoint:CGPointMake(0, bds.size.height-1)];
	[path lineToPoint:CGPointMake(bds.size.width-1, bds.size.height-1)];
	
	[path lineToPoint:CGPointMake(bds.size.width-1, 0)];
	
    [path stroke];
}

- (void)_drawFilledIn{
	//go through and draw fill in the ones that should be filled in.
}

- (void)_drawPlayhead{
	//blah.
}

- (void)mouseDown:(struct __GSEvent *)event
{
	struct CGRect rect = GSEventGetLocationInWindow(event);
	NSLog(@"MBGridView: mouseDown:%d, %d", rect.origin.x, rect.origin.y);
	CGPointMake(rect.origin.x, rect.origin.y);
	[self setNeedsDisplay];
	[super mouseDown:event];
}

- (void)mouseDragged:(struct __GSEvent *)event
{
	NSLog(@"MBGridView: mouseDragged:");
	GSEventGetLocationInWindow(event).origin;
	[self setNeedsDisplay];
	[super mouseDragged:event];
}

- (void)mouseUp:(struct __GSEvent *)event
{
	NSLog(@"MBGridView: mouseUp:");
	[super mouseUp:event];
}

@end