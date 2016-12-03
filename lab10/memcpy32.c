// C equivalent of memcpy32
#include <stdint.h>
typedef struct BLOCK { uint32_t data[8]; } BLOCK;
void memcpy32(void *dst, const void *src, uint32_t wdcount)
{
uint32_t blkN= wdcount/8, wdN= wdcount&7;
uint32_t *dstw= (uint32_t*)dst, *srcw= (uint32_t*)src;
if(blkN)
{
// 8-word copies
BLOCK *dst2= (BLOCK*)dst, *src2= (BLOCK*)src;
while(blkN--)
	*dst2++ = *src2++;
dstw= (uint32_t*)dst2;  srcw= (uint32_t*)src2;
}
// Residual words
while(wdN--)
	*dstw++ = *srcw++;
}