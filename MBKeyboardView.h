#import <Foundation/Foundation.h>
#import <GraphicsServices/GraphicsServices.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CGColor.h>
#import <CoreGraphics/CGGeometry.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIControl.h>
#import <UIKit/UIBezierPath.h>
#import <UIKit/UIView-Geometry.h>

#include "math.h"

typedef struct _MBDoublePoint {
    CGPoint first;
    CGPoint second;
} MBDoublePoint;

@interface MBKeyboardView : UIControl
{
    struct CGRect _frame;
	
	struct CGPoint left;
	struct CGPoint right;
	
	id _delegate;
}

- (void)setDelegate:(id)delegate;
- (id)delegate;

- (MBDoublePoint)_bothPointsFromRect:(CGRect)rect;

- (void)_drawKeys;
- (void)_drawDownKeys;

@end
