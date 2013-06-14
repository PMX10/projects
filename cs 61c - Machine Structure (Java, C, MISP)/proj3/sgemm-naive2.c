#include <emmintrin.h>  // intrinsic MMX instructions
#include <xmmintrin.h>  // intrinsic SSE instructions
#include <smmintrin.h>  // intrinsic SSE4 instructions

/* This routine performs a sgemm operation
 *  C := C + A * B
 * where A, B, and C are lda-by-lda matrices stored in column-major format.
 * On exit, A and B maintain their input values. */   
 /*
void square_sgemm (int n, float* A, float* B, float* C)
{
  //* For each row i of A *
  for (int i = 0; i < n; ++i)
    //* For each column j of B *
    for (int j = 0; j < n; ++j) 
    {
      //* Compute C(i,j) *
      float cij = C[i+j*n];
      for( int k = 0; k < n; k++ )
	       cij += A[i+k*n] * B[k+j*n];
      C[i+j*n] = cij;
    }
}
*/

void transpose(int n, float *dst, float *src) {
    for (int i = 0; i < n; i += 8) {
        for (int j = 0; j < n; j += 8) {
            for (int k = i; k < i + 8 && k < n; ++k) {
                for (int l = j; l < j + 8 && k < n; ++l) {
                    dst[k + l*n] = src[l + k*n];
                }
            }
        }
    }
}


void square_sgemm64(int n, float* A, float* B, float* C){
     
     __m128 b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15,b16,c1,c2;
     //float temp[4];

     for (int j = 0; j < 64; j++){
       
       b1 = _mm_loadu_ps(B+j*n);
       b2 = _mm_loadu_ps(B+j*n+4);
       b3 = _mm_loadu_ps(B+j*n+8);
       b4 = _mm_loadu_ps(B+j*n+12);
       b5 = _mm_loadu_ps(B+j*n+16);
       b6 = _mm_loadu_ps(B+j*n+20);
       b7 = _mm_loadu_ps(B+j*n+24);
       b8 = _mm_loadu_ps(B+j*n+28);
       b9 = _mm_loadu_ps(B+j*n+32);
       b10 = _mm_loadu_ps(B+j*n+36);
       b11 = _mm_loadu_ps(B+j*n+40);
       b12 = _mm_loadu_ps(B+j*n+44);
       b13 = _mm_loadu_ps(B+j*n+48);
       b14 = _mm_loadu_ps(B+j*n+52);
       b15 = _mm_loadu_ps(B+j*n+56);
       b16 = _mm_loadu_ps(B+j*n+60);
       
       for( int i = 0; i < 64; i++ ){
         /*
         c1 = _mm_mul_ps(_mm_loadu_ps(A+i*n), b1);
         c2 = _mm_mul_ps(_mm_loadu_ps(A+i*n+4), b2);
         c3 = _mm_mul_ps(_mm_loadu_ps(A+i*n+8), b3);
         c4 = _mm_mul_ps(_mm_loadu_ps(A+i*n+12), b4);
         c1 = _mm_add_ps(c1,_mm_mul_ps(_mm_loadu_ps(A+i*n+16), b5));
         c2 = _mm_add_ps(c2,_mm_mul_ps(_mm_loadu_ps(A+i*n+20), b6));
         c3 = _mm_add_ps(c3,_mm_mul_ps(_mm_loadu_ps(A+i*n+24), b7));
         c4 = _mm_add_ps(c4,_mm_mul_ps(_mm_loadu_ps(A+i*n+28), b8));
         c1 = _mm_add_ps(c1,_mm_mul_ps(_mm_loadu_ps(A+i*n+32), b9));
         c2 = _mm_add_ps(c2,_mm_mul_ps(_mm_loadu_ps(A+i*n+36), b10));
         c3 = _mm_add_ps(c3,_mm_mul_ps(_mm_loadu_ps(A+i*n+40), b11));
         c4 = _mm_add_ps(c4,_mm_mul_ps(_mm_loadu_ps(A+i*n+44), b12));
         c1 = _mm_add_ps(c1,_mm_mul_ps(_mm_loadu_ps(A+i*n+48), b13));
         c2 = _mm_add_ps(c2,_mm_mul_ps(_mm_loadu_ps(A+i*n+52), b14));
         c3 = _mm_add_ps(c3,_mm_mul_ps(_mm_loadu_ps(A+i*n+56), b15));
         c4 = _mm_add_ps(c4,_mm_mul_ps(_mm_loadu_ps(A+i*n+60), b16));
         
         _mm_storeu_ps(temp,_mm_add_ps(_mm_add_ps(c1,c2),_mm_add_ps(c3,c4)));
         */
         
         c1 = _mm_mul_ps(_mm_loadu_ps(A+i*n), b1);
         c2 = _mm_mul_ps(_mm_loadu_ps(A+i*n+4), b2);
         c1 = _mm_add_ps(c1,_mm_mul_ps(_mm_loadu_ps(A+i*n+8), b3));
         c2 = _mm_add_ps(c2,_mm_mul_ps(_mm_loadu_ps(A+i*n+12), b4));
         c1 = _mm_add_ps(c1,_mm_mul_ps(_mm_loadu_ps(A+i*n+16), b5));
         c2 = _mm_add_ps(c2,_mm_mul_ps(_mm_loadu_ps(A+i*n+20), b6));
         c1 = _mm_add_ps(c1,_mm_mul_ps(_mm_loadu_ps(A+i*n+24), b7));
         c2 = _mm_add_ps(c2,_mm_mul_ps(_mm_loadu_ps(A+i*n+28), b8));
         c1 = _mm_add_ps(c1,_mm_mul_ps(_mm_loadu_ps(A+i*n+32), b9));
         c2 = _mm_add_ps(c2,_mm_mul_ps(_mm_loadu_ps(A+i*n+36), b10));
         c1 = _mm_add_ps(c1,_mm_mul_ps(_mm_loadu_ps(A+i*n+40), b11));
         c2 = _mm_add_ps(c2,_mm_mul_ps(_mm_loadu_ps(A+i*n+44), b12));
         c1 = _mm_add_ps(c1,_mm_mul_ps(_mm_loadu_ps(A+i*n+48), b13));
         c2 = _mm_add_ps(c2,_mm_mul_ps(_mm_loadu_ps(A+i*n+52), b14));
         c1 = _mm_add_ps(c1,_mm_mul_ps(_mm_loadu_ps(A+i*n+56), b15));
         c2 = _mm_add_ps(c2,_mm_mul_ps(_mm_loadu_ps(A+i*n+60), b16));
         
         /*
         _mm_storeu_ps(temp,_mm_add_ps(c1,c2));
         C[j*64+i] = temp[0]+temp[1]+temp[2]+temp[3];
         */
         _mm_store_ss(C+j*64+i,(_mm_dp_ps(_mm_add_ps(c1,c2),_mm_set_ps(1.0,1.0,1.0,1.0),0xf1)));
       }
    }        
}


void square_sgemm(int n, float* A, float* B, float* C){
     float *D = (float*)malloc(n*n*sizeof(float));
     if (n==64){
        transpose(n, D, A);
        square_sgemm64(n, D, B, C);
     }
}
