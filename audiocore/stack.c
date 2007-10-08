#include "stack.h"
#include <stdio.h>

pthread_mutex_t stack_mutex = PTHREAD_MUTEX_INITIALIZER;

unsigned int event_stack[SIZE];
unsigned int *top = event_stack;
unsigned int *cur = event_stack;

void event_push(unsigned int i)
{
  register unsigned int fail = 0;

  pthread_mutex_lock(&stack_mutex);
  cur++;
  if (cur == top + SIZE)
    {
      cur--;
      fail = 1;
    }
  else
    *cur = i;
  pthread_mutex_unlock(&stack_mutex);

  if (fail)
    printf("Stack overflow\n");
}

unsigned int event_pop(void)
{
  register unsigned int ret;

  pthread_mutex_lock(&stack_mutex);
  if (cur == top)
    {
      pthread_mutex_unlock(&stack_mutex);
      return -1;
    }
  cur--;
  ret = *(cur + 1);
  pthread_mutex_unlock(&stack_mutex);

  return ret;
}
