#import <Foundation/Foundation.h>
//#import <CoreGraphics/CoreGraphics.h>
#import <CoreGraphics/CGGeometry.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UIControl.h>
#import <UIKit/UISliderControl.h>
//#import <UIKit/UIBezierPath.h>

@interface MBGridView : UIControl
{
	struct CGRect _frame;
	
	NSMutableArray *data;
}

- (void)_drawGrid;
- (void)_drawFilledIn;
- (void)_drawPlayhead;

@end