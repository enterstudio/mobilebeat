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

- (void)handleBPMChange:(id)sender{
	//NSLog(@"sender value: %f", [slider value]);
	[heartbeat setBPM:(int)[slider value]];
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
	
	rect.size.height = rect.size.height - 10;
	
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
	[grid release];
	
	slider = [[UISliderControl alloc] initWithFrame:CGRectMake(10.0, rect.size.height-150, rect.size.width-20, 20)];
	
	[slider setMaxValue:120];
	[slider setMinValue:30];
	[slider setNumberOfTickMarks:90];
	[slider setAllowsTickMarkValuesOnly:YES];
	[slider setValue:60];
	[slider setShowValue:YES];
	
	[slider addTarget:self action:@selector(handleBPMChange:) forEvents:7];
	
	[mainView addSubview:slider];
	
	MBSlideView *slideView = [[MBSlideView alloc] initWithFrame:rect];
	[slideView addView:mainView];
	[mainView release];
	
	
	UIView *secondView = [[UIView alloc] initWithFrame:rect];
	MBKeyboardView *keyboard = [[MBKeyboardView alloc] initWithFrame:CGRectMake(0.0,rect.size.height-100,rect.size.width,100)];
	[secondView addSubview:keyboard];
	
	[slideView addView:secondView];
	[secondView release];
	
	UIView *thirdView = [[UIView alloc] initWithFrame:rect];
	UISliderControl *slider1 = [[UISliderControl alloc] initWithFrame:CGRectMake(10.0, rect.size.height-150, rect.size.width-20, 20)];
	[thirdView addSubview:slider1];
	[slider1 release];
	
	[slideView addView:thirdView];
	[thirdView release];
	
	[window setContentView:slideView];
	
	core = [[MBAudioCore alloc] init];
	heartbeat = [[MBHeartbeat alloc] initWithBPM:60];
	
	[heartbeat setGridView:grid];
	[heartbeat startBeat];
	
	//go to the first view.
	[slideView selectViewAtIndex:0];
}

@end
