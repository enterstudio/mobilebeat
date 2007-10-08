
#import "BeatPhone.h"
#import <UIKit/CDStructures.h>
#include "audiocore.h"
#include "stack.h"
#include "sampleid.h"

extern sampleid_t sampleDB[];

@implementation BeatPhone

- (void) buttonEvent:(SamplePushButton *)button
{
  if ([button isPressed]) 
    {
      unsigned int num = [button getID];

      if (IS_SAMPLE_LOOP(num)) // looped sample
	{
	  if ([button isSelected])
	    {
	      event_push((num & 0xffff) | SAMPLE_STOP);
	      [button setSelected:NO];
	      return;
	    }
	  event_push(num);
	  [button setSelected:YES];
	  [button setShowPressFeedback:YES];
	}
      else // one shot sample
	event_push(num);
    }
}

- (void) audioThread
{
  audiocore_thread(NULL);
}

- (void) loadPads
{
  int i, j, k;

  /* One-shot pads */
  UIImage* btnImageT = [UIImage imageNamed:@"pad.png"];
  UIImage* btnImagePressedT = [UIImage imageNamed:@"pad2.png"];

  beatBoxButtons[0] = [[SamplePushButton alloc] initWithTitle:@"Kick" autosizesToFit:YES];
  beatBoxButtons[1] = [[SamplePushButton alloc] initWithTitle:@"Snare 1" autosizesToFit:YES];
  beatBoxButtons[2] = [[SamplePushButton alloc] initWithTitle:@"Snare 2" autosizesToFit:YES];
  beatBoxButtons[3] = [[SamplePushButton alloc] initWithTitle:@"CHH" autosizesToFit:YES];
  beatBoxButtons[4] = [[SamplePushButton alloc] initWithTitle:@"OHH" autosizesToFit:YES];
  beatBoxButtons[5] = [[SamplePushButton alloc] initWithTitle:@"Cymbal" autosizesToFit:YES];
  beatBoxButtons[6] = [[SamplePushButton alloc] initWithTitle:@"Ride" autosizesToFit:YES];
  beatBoxButtons[7] = [[SamplePushButton alloc] initWithTitle:@"FX 1" autosizesToFit:YES];
  beatBoxButtons[8] = [[SamplePushButton alloc] initWithTitle:@"FX 2" autosizesToFit:YES];

  /* Loop pads */
  UIImage *image_loop[6];

  image_loop[0] = [UIImage imageNamed:@"pad-green-1.png"];
  image_loop[1] = [UIImage imageNamed:@"pad-green-2.png"];
  image_loop[2] = [UIImage imageNamed:@"pad-purple-1.png"];
  image_loop[3] = [UIImage imageNamed:@"pad-purple-2.png"];
  image_loop[4] = [UIImage imageNamed:@"pad-yellow-1.png"];
  image_loop[5] = [UIImage imageNamed:@"pad-yellow-2.png"];

  beatBoxButtons[9] = [[SamplePushButton alloc] initWithTitle:@"Loop 1" autosizesToFit:YES];
  beatBoxButtons[10] = [[SamplePushButton alloc] initWithTitle:@"Loop 2" autosizesToFit:YES];
  beatBoxButtons[11] = [[SamplePushButton alloc] initWithTitle:@"Loop 3" autosizesToFit:YES];

  /* Draw one-shot pads */
  for (i = 0, k = 0; i < 3; i++)
    {
      for (j = 0; j < 3; j++)
	{
	  [beatBoxButtons[i * 3 + j] setID: sampleDB[k++].num];
	  [beatBoxButtons[i * 3 + j] setFrame: CGRectMake(j * 100 + 8, i * 100 + 20, 100.0, 100.0)];
	  [beatBoxButtons[i * 3 + j] setDrawsShadow: YES];
	  [beatBoxButtons[i * 3 + j] setEnabled:YES];  //may not be needed
	  [beatBoxButtons[i * 3 + j] setStretchBackground:YES];
	  [beatBoxButtons[i * 3 + j] setBackground:btnImageT forState:0];  //up state
	  [beatBoxButtons[i * 3 + j] setBackground:btnImagePressedT forState:1]; //down state
	  [beatBoxButtons[i * 3 + j] addTarget:self action:@selector(buttonEvent:) forEvents:kUIControlEventMouseDown];
	  [mainView addSubview: beatBoxButtons[i * 3 + j]];
	}
    }

  /* Draw loop pads */
  for (i = 0; i < 3; i++)
    {
      [beatBoxButtons[9 + i] setID: sampleDB[k++].num];
      [beatBoxButtons[9 + i] setFrame: CGRectMake(i * 100 + 8, 350, 100.0, 100.0)];
      [beatBoxButtons[9 + i] setDrawsShadow: YES];
      [beatBoxButtons[9 + i] setEnabled:YES];  //may not be needed
      [beatBoxButtons[9 + i] setStretchBackground:YES];
      [beatBoxButtons[9 + i] setBackground:image_loop[i * 2] forState:0];  //up state
      [beatBoxButtons[9 + i] setBackground:image_loop[i * 2 + 1] forState:1]; //down state
      [beatBoxButtons[9 + i] addTarget:self action:@selector(buttonEvent:) forEvents:kUIControlEventMouseDown];
      //      [beatBoxButtons[9 + i] addTarget:self action:@selector(buttonEvent:) forEvents:255];
      [mainView addSubview: beatBoxButtons[9 + i]];      
    }
}

- (void) applicationDidFinishLaunching: (id) unused
{

  struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
  rect.origin.x = rect.origin.y = 0.0f;

  window = [[UIWindow alloc] initWithContentRect: rect];
  mainView = [[UIView alloc] initWithFrame: rect];

  //  [window setRotationDegrees:90 duration:0.1];

  UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, rect.size.width, rect.size.height)];
  [bg setImage:[UIImage applicationImageNamed:@"bg2.jpg"]];
  [mainView addSubview: bg];
  [bg release];

  textView = [[UITextView alloc]
	       initWithFrame: CGRectMake(0.0f, 440.0f, 320.0f, 40.0f)];
  [textView setEditable:NO];
  [textView setTextSize:8];

  textViewString = [[NSMutableString alloc] initWithString: @"BeatPhone 0.2.2 -                                     mg (mateo@bblk.net)"];
  [textView setText: textViewString];

  [NSThread detachNewThreadSelector:@selector(audioThread) toTarget:self withObject:nil];
  [self loadPads];

  [window orderFront: self];
  [window makeKey: self];
  [window _setHidden: NO];
  [window setContentView: mainView];
  [mainView addSubview: textView];

}


@end
