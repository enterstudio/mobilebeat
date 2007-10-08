#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CGColor.h>
#import <CoreGraphics/CGGeometry.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIControl.h>
#import <UIKit/UIBezierPath.h>

#import "CTGradient.h"
#include "math.h"


@interface MBGridView : UIControl
{
    struct CGRect _frame;

    NSMutableArray *data;

    float playheadPosition;

	id _delegate;
}

- (void)setTime:(float)newTime;
- (float)time;

- (void)setDelegate:(id)delegate;
- (id)delegate;

- (void)_drawGrid;
- (void)_drawFilledIn;
- (void)_drawPlayhead;

@end
