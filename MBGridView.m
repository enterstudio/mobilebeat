#import "MBGridView.h"

#define GRID_WIDTH 8
#define GRID_HEIGHT 8

struct CGRect GSEventGetLocationInWindow(struct __GSEvent *ev);

// struct CGRect GSEventGetLocationInWindow(GSEvent *ev);

@implementation MBGridView

//keep track of the last milestone we reached.
int lastMilestone;

- (id)initWithFrame:(struct CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;

    _frame = frame;
    playheadPosition = 0.0;
	lastMilestone = -1;
	
    int i,j;
    data = [[NSMutableArray alloc] initWithCapacity:GRID_WIDTH];
    for(i = 0; i < GRID_WIDTH; i++) {
        NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:GRID_HEIGHT];
        for(j = 0; j < GRID_HEIGHT; j++) {
            NSNumber *new = [[NSNumber alloc] initWithBool:NO];
            [temp addObject:new];
            [new release];
        }
        [data addObject:temp];
        [temp release];
    }

    float boxback[4] = {.85, .85, .85, 1};
    [self setBackgroundColor: CGColorCreate( CGColorSpaceCreateDeviceRGB(), boxback)];

    return self;
}

- (void)drawRect:(struct CGRect)rect
{
    [self _drawFilledIn];
    [self _drawGrid];
    [self _drawPlayhead];
}

- (void)setTime:(float)newTime
{
	//NSLog(@"setTime: %f", newTime);
    newTime = fmod(newTime, 1);

	//check if we have reached a new milestone and send a message to
	//our delegate if we have.
	int section = (int)(newTime * (float)GRID_WIDTH);
	if(section == 0 && lastMilestone == 7) lastMilestone = -1;
	if(section > lastMilestone){
		//NSLog(@"newTime: %f lastMilestone: %d", newTime, lastMilestone);
		lastMilestone = (int)(newTime * (float)GRID_WIDTH);
		if(_delegate != nil && [_delegate respondsToSelector:@selector(milestoneReachedWithData:)]){
			//send the delegate the array with our boolean values in it.
			[_delegate milestoneReachedWithData:[data objectAtIndex:lastMilestone]];
		}
	}

    playheadPosition = newTime;
    [self setNeedsDisplay];
}

- (float)time
{
    return playheadPosition;
}

- (void)setDelegate:(id)delegate
{
	[_delegate release];
	_delegate = [delegate retain];
}

- (id)delegate{
	return _delegate;
}

- (void)_drawGrid
{
    struct CGRect bds = _frame;
    float i, jump;
	
	CGContextSetShouldAntialias(UICurrentContext(), NO);
	
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:1];

    jump = (bds.size.width / (float)GRID_WIDTH);

    for(i = 0; i <= bds.size.width; i += jump) {
        struct CGPoint start = CGPointMake(i,bds.size.height);
        struct CGPoint end = CGPointMake(i,0);

        [path moveToPoint:start];
        [path lineToPoint:end];
    }

    jump = (bds.size.height / (float)GRID_HEIGHT);

    for(i = 0; i <= bds.size.height; i += jump) {
        struct CGPoint start = CGPointMake(0, i);
        struct CGPoint end = CGPointMake(bds.size.width, i);
        [path moveToPoint:start];
        [path lineToPoint:end];
    }

    [path moveToPoint:CGPointMake(0, bds.size.height-1)];
    [path lineToPoint:CGPointMake(bds.size.width-1, bds.size.height-1)];

    [path lineToPoint:CGPointMake(bds.size.width-1, 0)];

    [path stroke];

	CGContextSetShouldAntialias(UICurrentContext(), YES);
}

- (void)_drawFilledIn
{
    //go through and draw fill in the ones that should be filled in.
    float blueArray[4] = { .2353f, .6627f, 1.0f, 1.0f };
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef begin = CGColorCreate(colorSpace, blueArray);

    float blueArray2[4] = { .0745f, .349f, .9294f, 1.0f };
    CGColorRef end = CGColorCreate(colorSpace, blueArray2);

    // + (id)aquaSelectedGradient;
    // + (id)aquaNormalGradient;
    // + (id)aquaPressedGradient;

    CTGradient *gradient = [CTGradient gradientWithBeginningColor:begin endingColor:end];

    int i,j;
    for(i = 0; i < [data count]; i++) {
        for(j = 0; j < [[data objectAtIndex:i] count]; j++) {
            if(![[[data objectAtIndex:i] objectAtIndex:j] boolValue]) continue;
            struct CGRect rect = CGRectMake((float)i * (_frame.size.width / (float)GRID_WIDTH),
                (float)j * (_frame.size.height / (float)GRID_HEIGHT),
                _frame.size.width / (float)GRID_WIDTH,
                _frame.size.height / (float)GRID_HEIGHT);

            [gradient fillRect:NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height) angle:90.];
            //CGContextFillRect( UICurrentContext(), rect );
        }
    }

    //GBColorSpaceRelease(genericRGBSpace);
    //[context release];
}

- (void)_drawPlayhead
{
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
    //NSLog(@"MBGridView: mouseDown:%d, %d", rect.origin.x, rect.origin.y);
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
    //NSLog(@"MBGridView: mouseDragged:%d, %d", rect.origin.x, rect.origin.y);
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
    //NSLog(@"MBGridView: mouseUp:");
    [super mouseUp:event];
}

- (void)dealloc{
	[_delegate release];
	[data release];
	[super dealloc];
}

@end
