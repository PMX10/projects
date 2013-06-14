/*****************************************************************************

	 IMPORTANT: You *must* use palloc0 and pfree, not malloc and free, in your
	 implementation.  This will allow your filter to integrate into PostgreSQL.

******************************************************************************/

#include "postgres.h"
#include "utils/cmsketch.h"

/* initialize the count-min sketch for the specified width and depth */
cmsketch* init_sketch(uint32 width, uint32 depth) {
  struct cmsketch* cm = palloc(sizeof(cmsketch));
  cm->width = width;
  cm->depth = depth;
  cm->table = palloc0(width*depth*sizeof(uint32));
      
  return cm;
}

/* increment 'bits' in each sketch by 1. 
 * 'bits' is an array of indices into each row of the sketch.
 *    Thus, each index is between 0 and 'width', and there are 'depth' of them.
 */
void increment_bits(cmsketch* sketch, uint32 *bits) {
     int i=0;
     for (i=0; i<sketch->depth; i++)
	 sketch->table[i*sketch->width + bits[i]] += 1;
}

/* decrement 'bits' in each sketch by 1.
 * 'bits' is an array of indices into each row of the sketch.
 *    Thus, each index is between 0 and 'width', and there are 'depth' of them.
 */
void decrement_bits(cmsketch* sketch, uint32 *bits) {
     int i=0;
     for (i=0; i<sketch->depth; i++){
	 if (sketch->table[i*sketch->width + bits[i]] > 0)
		sketch->table[i*sketch->width + bits[i]] -= 1;
     }
}

/* return the minimum among the indicies pointed to by 'bits'
 * 'bits' is an array of indices into each row of the sketch.
 *    Thus, each index is between 0 and 'width', and there are 'depth' of them.
 */
uint32 estimate(cmsketch* sketch, uint32 *bits) {
  int min = sketch->table[bits[0]];
  int temp=0, i=0;

  for(i=1; i<sketch->depth; i++){
	temp = sketch->table[i*sketch->width + bits[i]];
        if (temp < min)
		min = temp;
  }
  return min;
}

/* set all values in the sketch to zero */
void reset_sketch(cmsketch* sketch) {
     int i=0;
     for (i=0; i<sketch->width*sketch->depth; i++)
      sketch->table[i] = 0;
}

/* destroy the sketch, freeing any memory it might be using */
void destroy_sketch(cmsketch* sketch) {
     pfree(sketch->table);
     pfree(sketch);
}
