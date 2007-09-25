#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UITextField.h>
#import <UIKit/UITextLabel.h>
#import <UIKit/UITextView.h>
#import <UIKit/UIKeyboard.h>
#import <UIKit/UINavigationBar.h>
#import <UIKit/UIWindow.h>

#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIHardware.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UITableColumn.h>
#import <UIKit/UITouchDiagnosticsLayer.h>
#import <UIKit/UIFontChooser.h>

#import "MBGridView.h"
#import "MBApplication.h"

@implementation MBApplication

#define BUTTON_WIDTH 80
#define BUTTON_HEIGHT 80

- (id)init{
	if(!(self = [super init])) return nil;
	
	return self;
}

- (void)_updateUI{

}

- (void)setUpUI
{
	
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
	
	[mainView addSubview:grid];
	//[mainView addSubview:control];
	[window setContentView:mainView];
	
	heartbeat = [[MBHeartbeat alloc] initWithBPM:60];
	
	[heartbeat setGridView:grid];
	[heartbeat startBeat];
}

@end
