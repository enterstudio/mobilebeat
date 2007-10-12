#import "MBSlideView.h"

struct CGRect GSEventGetLocationInWindow(struct __GSEvent *ev);
struct CGPoint GSEventGetInnerMostPathPosition(struct __GSEvent *ev);
struct CGPoint GSEventGetOuterMostPathPosition(struct __GSEvent *ev);

@implementation MBSlideView

- (id)initWithFrame:(struct CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;

    _frame = frame;
	_currentIndex = 0;

    float boxback[4] = {1, 1, 1, 1};
    [self setBackgroundColor: CGColorCreate( CGColorSpaceCreateDeviceRGB(), boxback)];

	views = [[NSMutableArray alloc] init];
	
	transition = [[UITransitionView alloc] initWithFrame:frame];
	[transition setDelegate:self];
	
	selectedDot = [[UIImage imageNamed:@"selected.png"] retain];
	unselectedDot = [[UIImage imageNamed:@"unselected.png"] retain];
	
	[self addSubview:transition];

    return self;
}

- (void)drawRect:(struct CGRect)rect
{
	[super drawRect:rect];
	[self _drawDots];
}

- (void)_drawDots{
	int i;
	UIImage *imageToComposite;
	
	float offset = _frame.size.width / (float)2 - (10 * [views count])/(float)2;
	
	for(i = 0; i < [views count]; i++){
		if(i == _currentIndex) imageToComposite = selectedDot;
		else imageToComposite = unselectedDot;
		[imageToComposite compositeToPoint:CGPointMake(offset + i * 10, _frame.size.height) operation:UICompositeSourceOver];
	}
}

- (BOOL)ignoresMouseEvents{
	return NO;
}

- (BOOL)canHandleGestures{
	return YES;
}

- (BOOL)canHandleSwipes{
	return YES;
}

#pragma mark -
#pragma mark Adding/Removing views

- (void)addView:(UIView *)view{
	[views addObject:view];
}

- (void)removeViewAtPosition:(int)position{
	
}

- (void)insertView:(UIView *)view atPosition:(int)position{
	
}

- (void)selectViewAtIndex:(int)index{
	if(index >= [views count] || index < 0) return;
	[transition transition:UITransitionShiftImmediate toView:[views objectAtIndex:index]];
	_currentIndex = index;
}

#pragma mark -
#pragma mark Gesture Handling

- (void)gestureStarted:(struct __GSEvent *)event {
    [ self gestureChanged: event ];
}

- (void)gestureEnded:(struct __GSEvent *)event {
	NSLog(@"gestureEnded");
	[self setNeedsDisplay];
	//right = CGPointMake(-100,-100);
}

- (void)gestureChanged:(struct __GSEvent *)event {
    //left = [self convertPoint:GSEventGetInnerMostPathPosition(event) fromView:nil];
	//right = [self convertPoint:GSEventGetOuterMostPathPosition(event) fromView:nil];
    
	//NSLog(@"gestureChanged: mouseDown:%f, %f and %f, %f", left.x, left.y, right.x, right.y);
	//[self setNeedsDisplay];
}

- (int)swipe:(UIViewSwipeDirection)num withEvent:(struct __GSEvent *)event{
	NSLog(@"swipe: %d", num);
	
	int previousIndex = _currentIndex;
	
	UITransitionStyle style;
	if(num == kUIViewSwipeLeft){
		if(_currentIndex < ([views count]-1)) _currentIndex++;
		style = UITransitionShiftLeft;
	}else if(num == kUIViewSwipeRight){
		if(_currentIndex > 0) _currentIndex--;
		style = UITransitionShiftRight;
	}
	
	[transition transition:style fromView:[views objectAtIndex:previousIndex] toView:[views objectAtIndex:_currentIndex]];
}

#pragma mark -
#pragma mark UITransitionView delegate methods

- (void)transitionViewDidStart:(UITransitionView*)view{
	
}

- (void)transitionViewDidComplete:(UITransitionView*)view fromView:(UIView*)from toView:(UIView*)to{
	//NSLog(@"1FINISHED transitioning to: %d", _currentIndex);
	[self setNeedsDisplay];
}

- (void)transitionViewDidComplete:(UITransitionView*)view finished:(BOOL)flag{
	//change the little indicator thing.
	NSLog(@"2FINISHED transitioning to: %d", _currentIndex);
}

- (void)transitionViewDidComplete:(UITransitionView*)view{
	NSLog(@"3FINISHED transitioning to: %d", _currentIndex);
}

@end