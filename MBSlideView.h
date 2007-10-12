#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CGColor.h>
#import <CoreGraphics/CGGeometry.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIControl.h>
#import <UIKit/UIBezierPath.h>
#import <UIKit/UITransitionView.h>
#import <UIKit/UIAlertSheet.h>

typedef enum
{
	kUIViewSwipeUp = 1,
	kUIViewSwipeDown = 2,
	kUIViewSwipeLeft = 4,
	kUIViewSwipeRight = 8
} UIViewSwipeDirection;

typedef enum _UICompositingOperation {
    UICompositeClear		= 0,
    UICompositeCopy		= 1,
    UICompositeSourceOver	= 2,
    UICompositeSourceIn		= 3,
    UICompositeSourceOut	= 4,
    UICompositeSourceAtop	= 5,
    UICompositeDestinationOver	= 6,
    UICompositeDestinationIn	= 7,
    UICompositeDestinationOut	= 8,
    UICompositeDestinationAtop	= 9,
    UICompositeXOR		= 10,
    UICompositePlusDarker	= 11,
    UICompositeHighlight	= 12,
    UICompositePlusLighter	= 13
} UICompositingOperation;

typedef enum
{
  UITransitionShiftImmediate = 0, // actually, zero or anything > 9
  UITransitionShiftLeft = 1,
  UITransitionShiftRight = 2,
  UITransitionShiftUp = 3,
  UITransitionFade = 6,
  UITransitionShiftDown = 7
} UITransitionStyle;

@interface MBSlideView : UIView
{
	NSMutableArray *views;
	CGRect _frame;
	
	int _currentIndex;
	
	UIImage *selectedDot;
	UIImage *unselectedDot;
	
	UITransitionView *transition;
}

- (void)addView:(UIView *)view;

- (void)removeViewAtPosition:(int)position;

- (void)insertView:(UIView *)view atPosition:(int)position;

@end