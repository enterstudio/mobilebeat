#import "MBHeartbeat.h"

#define UPDATE_TIME .05

@implementation MBHeartbeat

- (id)initWithBPM:(int)bpm
{
    if(!(self = [super init])) return nil;

    beatsPerMinute = bpm;

    return self;
}

- (void)startBeat
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_TIME
													  target:self
													selector:@selector(update:)
													userInfo:nil
													 repeats:YES];
}

- (void)update:(NSTimer *)timer
{
    //NSLog(@"update");
    float currentTime = [_gridView time];
    float secondsLong = ((float)120 / beatsPerMinute);

    [_gridView setTime:currentTime + (UPDATE_TIME / secondsLong)];
}

- (void)setBPM:(int)bpm
{
    beatsPerMinute = bpm;
}

- (int)bpm
{
    return beatsPerMinute;
}

- (void)setGridView:(id)gridView
{
    [_gridView release];
    _gridView = [gridView retain];
}

@end
