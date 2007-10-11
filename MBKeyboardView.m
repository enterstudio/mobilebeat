#import "MBKeyboardView.h"

struct CGRect GSEventGetLocationInWindow(struct __GSEvent *ev);
struct CGPoint GSEventGetInnerMostPathPosition(struct __GSEvent *ev);
struct CGPoint GSEventGetOuterMostPathPosition(struct __GSEvent *ev);

// struct CGRect GSEventGetLocationInWindow(GSEvent *ev);

@implementation MBKeyboardView

CGRect _currentRect;
- (id)initWithFrame:(struct CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;

    _frame = frame;
	left = CGPointMake(-100,-100);
	right = CGPointMake(-100, -100);

    float boxback[4] = {.85, .85, .85, 1};
    [self setBackgroundColor: CGColorCreate( CGColorSpaceCreateDeviceRGB(), boxback)];

    return self;
}

- (BOOL)ignoresMouseEvents {

    return NO;
}

- (BOOL)canHandleGestures {

   return YES;
}

- (void)drawRect:(struct CGRect)rect
{
	[self _drawKeys];
	[self _drawDownKeys];
}

- (void)setDelegate:(id)delegate
{
	[_delegate release];
	_delegate = [delegate retain];
}

- (id)delegate{
	return _delegate;
}

- (void)_drawKeys
{
	CGContextSetRGBFillColor(UICurrentContext(), .2353f, .6627f, 1.0f, 1.0f);
    CGContextFillRect( UICurrentContext(), _currentRect);
}

- (void)_drawDownKeys
{
	CGContextSetRGBFillColor(UICurrentContext(), 1., 0, 0, 1.0f);
    CGContextFillRect( UICurrentContext(), CGRectMake(left.x-5, left.y-5, 10,10));
	CGContextFillRect( UICurrentContext(), CGRectMake(right.x-5, right.y-5, 10,10));
}

- (void)gestureStarted:(struct __GSEvent *)event {
    [ self gestureChanged: event ];
}

- (void)gestureEnded:(struct __GSEvent *)event {
	NSLog(@"gestureEnded");
	[self setNeedsDisplay];
	//right = CGPointMake(-100,-100);
}

- (void)gestureChanged:(struct __GSEvent *)event {
    left = [self convertPoint:GSEventGetInnerMostPathPosition(event) fromView:nil];
	right = [self convertPoint:GSEventGetOuterMostPathPosition(event) fromView:nil];
    
	NSLog(@"gestureChanged: mouseDown:%f, %f and %f, %f", left.x, left.y, right.x, right.y);
	[self setNeedsDisplay];
}

- (void)mouseDown:(struct __GSEvent *)event
{
    struct CGRect rect = GSEventGetLocationInWindow(event);
	//NSLog(@"MBKeyboardView: mouseDown:%f, %f", rect.origin.x, rect.origin.y);

	left = [self convertPoint:CGPointMake(rect.origin.x, rect.origin.y) fromView:nil];
	right = CGPointMake(-100,-100);
	//NSLog(@"MBKeyboardView: mouseDown:%f, %f and %f, %f", points.first.x, points.first.y, points.second.x, points.second.y);
	
    [self setNeedsDisplay];
    [super mouseDown:event];
}

- (void)mouseDragged:(struct __GSEvent *)event
{
    struct CGRect rect = GSEventGetLocationInWindow(event);
	
	left = [self convertPoint:CGPointMake(rect.origin.x, rect.origin.y) fromView:nil];
	right = CGPointMake(-100,-100);
	//NSLog(@"MBKeyboardView: mouseDragged:%f, %f and %f, %f", points.first.x, points.first.y, points.second.x, points.second.y);

    [self setNeedsDisplay];
    [super mouseDown:event];
}

- (void)mouseUp:(struct __GSEvent *)event
{
    NSLog(@"MBKeyboardView: mouseUp:");
	//right = CGPointMake(-100,-100);
	//left = CGPointMake(-100, -100);
    [super mouseUp:event];
}

- (void)dealloc{
	[_delegate release];
	[super dealloc];
}

@end
