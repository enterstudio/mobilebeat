#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <UIKit/CDStructures.h>

#include "audiocore/audiocore.h"
#include "audiocore/stack.h"
#include <pthread.h>

@interface MBAudioCore : NSObject
{

}

- (void)playItem:(int)id;
- (void)audioThread;

@end
