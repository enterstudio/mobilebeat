#import <Foundation/Foundation.h>
//#import <CoreGraphics/CoreGraphics.h>
#import <CoreGraphics/CGGeometry.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>

#import "MBGridView.h"

//#import "NSTimer.h"

@interface MBHeartbeat : NSObject
{
	int beatsPerMinute;
	
	MBGridView *_gridView;
}
- (id)initWithBPM:(int)bpm;

- (void)startBeat;

- (void)update:(NSTimer *)timer;

- (void)setBPM:(int)bpm;
- (int)bpm;

- (void)setGridView:(id)gridView;

@end