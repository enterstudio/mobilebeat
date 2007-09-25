#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UITable.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UIImageAndTextTableCell.h>
#import <UIKit/UISliderControl.h>

#import "MBHeartbeat.h"

@interface MBApplication : UIApplication {
	MBHeartbeat *heartbeat;
}

- (void)setUpUI;
@end
