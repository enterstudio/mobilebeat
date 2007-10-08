#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UIWindow.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIHardware.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UITextView.h>
#import <UIKit/UIView.h>
#import <UIKit/UIKit.h>
#import <UIKit/CDStructures.h>
#import <Celestial/AVController.h>
#import <Celestial/AVItem.h>

#import "SamplePushButton.h"

typedef enum {
  kUIControlEventMouseDown = 1 << 0,
  kUIControlEventMouseMovedInside = 1 << 2, // mouse moved inside control target
  kUIControlEventMouseMovedOutside = 1 << 3, // mouse moved outside control target
  kUIControlEventMouseUpInside = 1 << 6, // mouse up inside control target
  kUIControlEventMouseUpOutside = 1 << 7, // mouse up outside control target
  kUIControlAllEvents = (kUIControlEventMouseDown | kUIControlEventMouseMovedInside |
			 kUIControlEventMouseMovedOutside | kUIControlEventMouseUpInside | kUIControlEventMouseUpOutside)
} UIControlEventMasks;

@interface BeatPhone : UIApplication 
{
  UIWindow		*window;
  UIView		*mainView;
  UITextView		*textView;
  NSMutableString	*textViewString;
  SamplePushButton     	*beatBoxButtons[12];
}
- (void) buttonEvent:(SamplePushButton *)button;
- (void) loadPads;
- (void) audioThread;
- (void) applicationDidFinishLaunching: (id) unused;

@end
