#include "audiocore.h"
#include "sampleid.h"
#include "stack.h"

extern sampleid_t sampleDB[];

short *workBuffer;
short *monoWorkBuffer;
short *stereoWorkBuffer;
GSList *curSamples = NULL;

inline short clip16(long num)
{
  if (num > 32767)
    num = 32767;
  if (num < -32767)
    num = -32767;
  return (short) (num);
}

/*
inline float clip16(float f)
{
  //  return f > 1.0 ? 1.0 : f < -1.0 ? -1.0 : f;
  return f;
}
*/

// return 1 : remove from current played samples
int mono_to_stereo(short *dst, samplesnapshot_t *sample, unsigned int framecount)
{
  register int i, j;
  int loop = framecount * 2;
  int ret = 0;
  short *work;

  if ((sample->cur + framecount) > sample->end)
    {
      framecount = (long) sample->end - (long) sample->cur;
      if (IS_SAMPLE_ONE_SHOT(sample->sample_type))
	ret = 1;
      else
	{
	  ret = 0;
	  sample->cur = sample->buffer;
	}
      loop = framecount * 2;
    }
  work = sample->cur;
  for (i = 0, j = 0; i < loop; i += 8, j += 4)
    {
      /*      
	      dst[i + 0] = (dst[i + 0] + work[j + 0]) >> 1;
      dst[i + 1] = (dst[i + 1] + work[j + 0]) >> 1;
      dst[i + 2] = (dst[i + 2] + work[j + 1]) >> 1;
      dst[i + 3] = (dst[i + 3] + work[j + 1]) >> 1;
      dst[i + 4] = (dst[i + 4] + work[j + 2]) >> 1;
      dst[i + 5] = (dst[i + 5] + work[j + 2]) >> 1;
      dst[i + 6] = (dst[i + 6] + work[j + 3]) >> 1;
      dst[i + 7] = (dst[i + 7] + work[j + 3]) >> 1;
      */
      dst[i + 0] = clip16(dst[i + 0] + work[j + 0]);
      dst[i + 1] = clip16(dst[i + 1] + work[j + 0]);
      dst[i + 2] = clip16(dst[i + 2] + work[j + 1]);
      dst[i + 3] = clip16(dst[i + 3] + work[j + 1]);
      dst[i + 4] = clip16(dst[i + 4] + work[j + 2]);
      dst[i + 5] = clip16(dst[i + 5] + work[j + 2]);
      dst[i + 6] = clip16(dst[i + 6] + work[j + 3]);
      dst[i + 7] = clip16(dst[i + 7] + work[j + 3]);

    }
  sample->cur += framecount;
  return ret;
}

// return 1 : remove from current played samples
int stereo_to_stereo(short *dst, samplesnapshot_t *sample, unsigned int framecount)
{
  register int i;
  int ret = 0;
  int loop = framecount * 2;
  short *work;

  /*
  printf("cur=%p cur+framecount=%p end=%p\n",
	 sample->cur, 
	 sample->cur + framecount * 2,
	 sample->end);
  */
	 
  if ((sample->cur + framecount * 2) >= sample->end)
    {
      framecount = ((long) sample->end - (long) sample->cur) / 2;
      if (IS_SAMPLE_ONE_SHOT(sample->sample_type))
	ret = 1;
      else
	{
	  ret = 0;
	  sample->cur = sample->buffer;
	}
      loop = framecount * 2;
    }
  work = sample->cur;
  for (i = 0; i < loop; i += 8)
    {
      dst[i + 0] = clip16(dst[i + 0] + work[i + 0]);
      dst[i + 1] = clip16(dst[i + 1] + work[i + 1]);
      dst[i + 2] = clip16(dst[i + 2] + work[i + 2]);
      dst[i + 3] = clip16(dst[i + 3] + work[i + 3]);
      dst[i + 4] = clip16(dst[i + 4] + work[i + 4]);
      dst[i + 5] = clip16(dst[i + 5] + work[i + 5]);
      dst[i + 6] = clip16(dst[i + 6] + work[i + 6]);
      dst[i + 7] = clip16(dst[i + 7] + work[i + 7]);

      /*
      dst[i + 0] = (dst[i + 0] + work[i + 0]) >> 1;
      dst[i + 1] = (dst[i + 1] + work[i + 1]) >> 1;
      dst[i + 2] = (dst[i + 2] + work[i + 2]) >> 1;
      dst[i + 3] = (dst[i + 3] + work[i + 3]) >> 1;
      dst[i + 4] = (dst[i + 4] + work[i + 4]) >> 1;
      dst[i + 5] = (dst[i + 5] + work[i + 5]) >> 1;
      dst[i + 6] = (dst[i + 6] + work[i + 6]) >> 1;
      dst[i + 7] = (dst[i + 7] + work[i + 7]) >> 1;
      */
      }
  sample->cur += framecount * 2;
  return ret;
}


void gen_buffer(audio_cb_t *cb)
{
  int id;
  int i, loop, wipe_cur = 0;
  samplesnapshot_t *wipe[256];

  memset(wipe, 0, 16 * sizeof (void *));
  memset(workBuffer, 0, sizeof (short) * cb->frameCount * 2);

  id = event_pop();

  /* New sample in stack, retrive from sample DB and create a new sample snapshot */
  if (id != -1)
    {
      if (IS_SAMPLE_STOP(id)) /* Stop playback event ? */
	{
	  int i;
	stop_event:
	  loop = g_slist_length(curSamples);
	  for (i = 0; i < loop; i++)
	    {
	      samplesnapshot_t *cur = g_slist_nth_data(curSamples, i);
	      if ((cur->sample_type & 0xffff) == (id & 0xffff))
		{
		  curSamples = g_slist_remove(curSamples, cur);		
		  free(cur);
		  goto stop_event; /* Ugly, but we don't want to deal with a malformed slist */
		}
	    }
	}
      else
	{
	  samplesnapshot_t *new;
	  audiosample_t *smp;
	  
	  int c_id = id & 0xffff;
	  smp = g_hash_table_lookup(cb->samples, &sampleDB[c_id].num);
	  new = malloc(sizeof (samplesnapshot_t));
	  new->buffer = new->cur = smp->buffer;
	  new->channels = smp->sndinfo->channels;
	  new->end = new->buffer + smp->size;
	  new->sample_type = sampleDB[c_id].num;
	  curSamples = g_slist_append(curSamples, new);
	}
    }

  /* Fill work buffer with every playing samples */
  loop = g_slist_length(curSamples);
  for (i = 0; i < loop; i++)
    {
      samplesnapshot_t *cur;
      int ret;

      cur = g_slist_nth_data(curSamples, i);
      switch (cur->channels)
	{
	case 1:
	  ret = mono_to_stereo(workBuffer, cur, cb->frameCount);
	  break;

	case 2:
	  ret = stereo_to_stereo(workBuffer, cur, cb->frameCount);
	  break;
	}

      if (ret)
	  wipe[wipe_cur++] = cur;
    }
  

  /* Wipe finished samples */
  for (i = 0; i < wipe_cur; i++)
    {
      curSamples = g_slist_remove(curSamples, wipe[i]);
      free(wipe[i]);
    }
}

void *audiocore_thread(void *p)
{
  int err, i;
  audio_cb_t *cb;

  cb = calloc(1, sizeof (audio_cb_t));
  assert(cb != NULL);

  cb->dataFormat.mSampleRate = 44100.0;
  //    cb->dataFormat.mSampleRate = 32000.0;
  //  cb->dataFormat.mSampleRate = 48000.0;
  cb->dataFormat.mFormatID = kAudioFormatLinearPCM;
  cb->dataFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger  | kAudioFormatFlagIsPacked;
  cb->dataFormat.mBytesPerPacket = 4;
  cb->dataFormat.mFramesPerPacket = 1;
  cb->dataFormat.mBytesPerFrame = 4;
  cb->dataFormat.mChannelsPerFrame = 2;
  cb->dataFormat.mBitsPerChannel = 16;

  assert(audiocore_load_samples(cb));

  err = AudioQueueNewOutput(&(cb->dataFormat), audiocore_cb, cb, CFRunLoopGetCurrent(), kCFRunLoopCommonModes, 0, &(cb->queue));
  assert(!err);
  
  cb->frameCount = 1024;
  UInt32 bufferBytes  = cb->frameCount * cb->dataFormat.mBytesPerFrame;
  workBuffer = calloc(sizeof (short), bufferBytes);
  //  monoWorkBuffer = calloc(sizeof (short), cb->frameCount);
  //  stereoWorkBuffer = calloc(sizeof (short), cb->frameCount * 2);

  for (i = 0; i < BUFFERS; i++)
    {
      err = AudioQueueAllocateBuffer(cb->queue, bufferBytes, &cb->buffers[i]);
      assert(!err);
      audiocore_cb(cb, cb->queue, cb->buffers[i]);
    }       
        
  err = AudioQueueSetParameter(cb->queue, kAudioQueueParam_Volume, 2.0);
  assert(!err);

  err = AudioQueueStart(cb->queue, NULL);
  assert(!err);

  while (1)
    {
      CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0, false);
    }
}

int audiocore_load_samples(audio_cb_t *cb)
{
  int i;
  cb->samples = g_hash_table_new(g_int_hash, g_int_equal);

  for (i = 0; sampleDB[i].path != NULL; i++)
    {
      audiosample_t *cur;

      cur = calloc(1, sizeof (audiosample_t));
      assert(cur != NULL);
      cur->sndinfo = calloc(1, sizeof (SF_INFO));
      assert(cur->sndinfo);
      cur->sndfile = sf_open(sampleDB[i].path, SFM_READ, cur->sndinfo);
      assert(cur->sndfile);
      cur->size = cur->sndinfo->frames * cur->sndinfo->channels;
      cur->buffer = calloc(sizeof (short), cur->size);
      sf_readf_short(cur->sndfile, cur->buffer, cur->sndinfo->frames);
      printf("Opened %s (%lu frames, %d channels, %d Hz)\n", sampleDB[i].path, cur->size,
	     cur->sndinfo->channels, cur->sndinfo->samplerate);
      g_hash_table_insert(cb->samples, &sampleDB[i].num, cur);
    }
  printf("\n");
  return 1;
}

void audiocore_cb(void *in, AudioQueueRef inQ, AudioQueueBufferRef outQB)
{
  audio_cb_t *cb = (audio_cb_t *) in;
  short *buffer = (short *) outQB->mAudioData;
  int i, loop;

  gen_buffer(cb);
  outQB->mAudioDataByteSize = sizeof (short) * cb->frameCount * 2;
  /*
  loop = cb->frameCount * 2;
  for (i = 0; i < loop; i += 8)
    {
      buffer[i + 0] = (short) (workBuffer[i + 0] * 32767.0);
      buffer[i + 1] = (short) (workBuffer[i + 1] * 32767.0);
      buffer[i + 2] = (short) (workBuffer[i + 2] * 32767.0);
      buffer[i + 3] = (short) (workBuffer[i + 3] * 32767.0);
      buffer[i + 4] = (short) (workBuffer[i + 4] * 32767.0);
      buffer[i + 5] = (short) (workBuffer[i + 5] * 32767.0);
      buffer[i + 6] = (short) (workBuffer[i + 6] * 32767.0);
      buffer[i + 7] = (short) (workBuffer[i + 7] * 32767.0);
    }
  */
  memcpy(buffer, workBuffer, cb->frameCount * 2 * sizeof (short));
  AudioQueueEnqueueBuffer(inQ, outQB, 0, NULL);
}
