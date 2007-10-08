#import "MBAudioCore.h"

@implementation MBAudioCore

- (id)init
{
    if(!(self = [super init])) return nil;

    [NSThread detachNewThreadSelector:@selector(audioThread) toTarget:self withObject:nil];

    return self;
}

- (void)playItem:(int)id
{

    event_push(id);
}

- (void)audioThread
{
    audiocore_thread(NULL);
}

@end
