//#ifndef __AUDIOCORE_H_
//# define __AUDIOCORE_H_

#include <CoreFoundation/CoreFoundation.h>
#include <AudioToolbox/AudioQueue.h>
#include <sndfile.h>
#include <glib.h>
#include <sys/mman.h>

#define BUFFERS 3

typedef struct audiosample_s
{
  SNDFILE	*sndfile;
  SF_INFO	*sndinfo;
  short		*buffer;
  unsigned long	size;
} audiosample_t;

typedef struct samplesnapshot_s
{
  int		channels;
  unsigned int 	sample_type;
  short		*buffer;
  short		*cur;			// cur pointer
  short		*end;			// last frame
} samplesnapshot_t;

enum AudioCoreStatus
  {
    kAudioCoreStatusStopped,
    kAudioCoreStatusPlaying
  };

typedef struct audio_cb_s
{
  AudioQueueRef					queue;
  UInt32					frameCount;
  AudioQueueBufferRef				buffers[BUFFERS];
  AudioStreamBasicDescription			dataFormat;
  GHashTable					*samples;
} audio_cb_t;

void	audiocore_cb(void *, AudioQueueRef, AudioQueueBufferRef);
void	*audiocore_thread(void *);
void	audiocore_stop();
int	audiocore_load_samples(audio_cb_t *);



//#endif /* !__AUDIOCORE_H_ */
