#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CGColor.h>
#import <CoreGraphics/CGGeometry.h>

#import "MBGridView.h"

#include "math.h"

#import <UIKit/UIBezierPath.h>

#define GRID_WIDTH 8
#define GRID_HEIGHT 8

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
	playheadPosition = 0.0;
	
	int i,j;
	data = [[NSMutableArray alloc] initWithCapacity:GRID_WIDTH];
	for(i = 0; i < GRID_WIDTH; i++){
		NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:GRID_HEIGHT];
		for(j = 0; j < GRID_HEIGHT; j++){
			NSNumber *new = [[NSNumber alloc] initWithBool:NO];
			[temp addObject:new];
			[new release];
		}
		[data addObject:temp];
		[temp release];
	}
	
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

- (void)setTime:(float)newTime{
	newTime = fmod(newTime, 1);
	playheadPosition = newTime;
	[self setNeedsDisplay];
}

- (float)time{
	return playheadPosition;
}

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
	float blueArray[4] = { 0.0f, 0.0f, 1.0f, 1.0f };
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextSetFillColorWithColor( UICurrentContext(), CGColorCreate(colorSpace, blueArray) );
	
	int i,j;
	for(i = 0; i < [data count]; i++){
		for(j = 0; j < [[data objectAtIndex:i] count]; j++){
			if(![[[data objectAtIndex:i] objectAtIndex:j] boolValue]) continue;
			struct CGRect rect = CGRectMake(i * (_frame.size.width / GRID_WIDTH),
											j * (_frame.size.height / GRID_HEIGHT),
											_frame.size.width / GRID_WIDTH,
											_frame.size.height / GRID_HEIGHT);
			
			CGContextFillRect( UICurrentContext(), rect );
		}
	}

	//GBColorSpaceRelease(genericRGBSpace);
	//[context release];
}

- (void)_drawPlayhead{
	//blah.
	float grayArray[4] = { 1.0f, 1.0f, 1.0f, 0.5f };
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextSetFillColorWithColor( UICurrentContext(), CGColorCreate(colorSpace, grayArray) );
	
	UIBezierPath *path = [UIBezierPath bezierPath];
	[path setLineWidth:1];
	
	[path moveToPoint:CGPointMake(_frame.size.width * playheadPosition, 0)];
	[path lineToPoint:CGPointMake(_frame.size.width * playheadPosition, _frame.size.height)];
	
	[path stroke];
}

BOOL repeatAction;
- (void)mouseDown:(struct __GSEvent *)event
{
	struct CGRect rect = GSEventGetLocationInWindow(event);
	NSLog(@"MBGridView: mouseDown:%d, %d", rect.origin.x, rect.origin.y);
	CGPointMake(rect.origin.x, rect.origin.y);
	
	int xPos = (int)((rect.origin.x/_frame.size.width) * GRID_WIDTH);
	int yPos = (int)((rect.origin.y/_frame.size.height) * GRID_HEIGHT);
	
	if(xPos > GRID_WIDTH || yPos > GRID_HEIGHT) return;
	
	//x value first.
	NSNumber *current = [[data objectAtIndex:xPos] objectAtIndex:yPos];
	
	repeatAction = ![current boolValue];
	
	NSNumber *new = [[NSNumber alloc] initWithBool:repeatAction];
	
	[[data objectAtIndex:xPos] replaceObjectAtIndex:yPos withObject:new];
	
	[new release];
	[self setNeedsDisplay];
	[super mouseDown:event];
}

BOOL mouseDragged = YES;

- (void)mouseDragged:(struct __GSEvent *)event
{
	struct CGRect rect = GSEventGetLocationInWindow(event);
	NSLog(@"MBGridView: mouseDragged:%d, %d", rect.origin.x, rect.origin.y);
	CGPointMake(rect.origin.x, rect.origin.y);
	
	int xPos = (int)((rect.origin.x/_frame.size.width) * GRID_WIDTH);
	int yPos = (int)((rect.origin.y/_frame.size.height) * GRID_HEIGHT);
	
	if(xPos >= GRID_WIDTH || yPos >= GRID_HEIGHT) return;
	
	//x value first.	
	NSNumber *new = [[NSNumber alloc] initWithBool:repeatAction];
	
	[[data objectAtIndex:xPos] replaceObjectAtIndex:yPos withObject:new];
	
	[new release];
	[self setNeedsDisplay];
	[super mouseDown:event];
}

- (void)mouseUp:(struct __GSEvent *)event
{
	NSLog(@"MBGridView: mouseUp:");
	[super mouseUp:event];
}

@end