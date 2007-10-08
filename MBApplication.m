#import "MBApplication.h"

@implementation MBApplication

- (id)init{
	if(!(self = [super init])) return nil;
	
	return self;
}

- (void)_updateUI{

}

- (void)setUpUI
{
	
}

- (void)playSoundFile:(NSString *)path{
	// Set up the playback
	NSError *error;
	AVItem *item;
	AVController *av = [[AVController alloc] init];
	item = [[AVItem alloc] initWithPath:path error:&error];
	[av setCurrentItem:item preservingRate:YES];
	BOOL ok = [av play:nil];
	//[av release];
}

- (void)milestoneReachedWithData:(NSArray *)data{
	//data should be an array of NSNumber bools that tell us what things
	//are enabled. Send those through the MBAudioCore class.
	//NSLog(@"milestone reached");
	//[self playSoundFile:@"/Applications/MobileBeat.app/beep.caf"];
	int i;
	for(i = 0; i < [data count]; i++){
		if([[data objectAtIndex:i] boolValue]){
			[core playItem:i];
		}
	}
}

- (void) applicationDidFinishLaunching: (id) unused
{
	UIWindow *window;

	window = [[UIWindow alloc] initWithContentRect: [UIHardware
					    fullScreenApplicationContentRect]];
	//[self setUpUI];
	
	[window orderFront: self];
	[window makeKey: self];
	[window _setHidden: NO];
	
	struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
	
	rect.origin.x = rect.origin.y = 0.0f;
	UIView *mainView;
	mainView = [[UIView alloc] initWithFrame: rect];
	
	float boxback[4] = {1, 1, 1, 1};
	[mainView setBackgroundColor: CGColorCreate( CGColorSpaceCreateDeviceRGB(), boxback)];
	
	//create the MBGridView
	MBGridView *grid = [[MBGridView alloc] initWithFrame:CGRectMake(0.0,0.0,rect.size.width,rect.size.width-37)];
	
	//now we will get milestone reached data.
	[grid setDelegate:self];
	
	[mainView addSubview:grid];
	//[mainView addSubview:control];
	[window setContentView:mainView];
	
	core = [[MBAudioCore alloc] init];
	heartbeat = [[MBHeartbeat alloc] initWithBPM:60];
	
	[heartbeat setGridView:grid];
	[heartbeat startBeat];
}

@end
