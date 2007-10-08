/* Associate an ID with a sample */

/*
   31                15               0 bit
MSB [................][................]
       Sample Type        Sample ID
*/


#define SAMPLE_ONE_SHOT		(1 << 31)
#define SAMPLE_LOOP		(1 << 30)
#define SAMPLE_STOP		(1 << 29)  // Stop playback of current loop sample

#define IS_SAMPLE_ONE_SHOT(x)	(x & SAMPLE_ONE_SHOT)
#define IS_SAMPLE_LOOP(x)	(x & SAMPLE_LOOP)
#define IS_SAMPLE_STOP(x)	(x & SAMPLE_STOP)
#define GET_SAMPLE_ID(x)	(x & 0xffff)

typedef struct sampleid_s
{
  unsigned int 	num;
  char		*path;
} sampleid_t;

