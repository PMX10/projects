/*****************************
Zhaohua Gao  cs61c-iz
Pei Jun Chen cs61c-ja
*****************************/


#if !defined(BLOCK_SIZE)
#define BLOCK_SIZE 32
#endif

#include <emmintrin.h>  // intrinsic MMX instructions
#include <xmmintrin.h>  // intrinsic SSE instructions
#include <smmintrin.h>  // intrinsic SSE4 instructions
#include <omp.h>

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
    for (int i = 0; i < n; i += 16) {
        for (int j = 0; j < n; j += 16) {
            for (int k = i; k < i + 16 && k < n; ++k)
                for (int l=j; l < j + 16 && l < n;++l) {
                    dst[k + l*n] = src[l + k*n];
                }
            }
        }
    }

void square_sgemm32(int lda, float* A, float* B, float* C){
     
     __m128 b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15,b16,c1,c2;
     //float temp[4];

     for (int j = 0; j < 32; j++){
       float* tempB = B+ j*lda;
       b1 = _mm_loadu_ps(tempB);
       b2 = _mm_loadu_ps(tempB+4);
       b3 = _mm_loadu_ps(tempB+8);
       b4 = _mm_loadu_ps(tempB+12);
       b5 = _mm_loadu_ps(tempB+16);
       b6 = _mm_loadu_ps(tempB+20);
       b7 = _mm_loadu_ps(tempB+24);
       b8 = _mm_loadu_ps(tempB+28);
       //b9 = _mm_loadu_ps(tempB+32);
       //b10 = _mm_loadu_ps(tempB+36);
       //b11 = _mm_loadu_ps(tempB+40);
       //b12 = _mm_loadu_ps(tempB+44);
       //b13 = _mm_loadu_ps(tempB+48);
       //b14 = _mm_loadu_ps(tempB+52);
       //b15 = _mm_loadu_ps(tempB+56);
       //b16 = _mm_loadu_ps(tempB+60);
       
       for( int i = 0; i < 32; i++ ){
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
		 float* tempA = A + i*lda;
         float cij = *(C + j*lda + i);
         c1 = _mm_mul_ps(_mm_loadu_ps(tempA), b1);
         c2 = _mm_mul_ps(_mm_loadu_ps(tempA+4), b2);
         c1 = _mm_add_ps(c1,_mm_mul_ps(_mm_loadu_ps(tempA+8), b3));
         c2 = _mm_add_ps(c2,_mm_mul_ps(_mm_loadu_ps(tempA+12), b4));
         c1 = _mm_add_ps(c1,_mm_mul_ps(_mm_loadu_ps(tempA+16), b5));
         c2 = _mm_add_ps(c2,_mm_mul_ps(_mm_loadu_ps(tempA+20), b6));
         c1 = _mm_add_ps(c1,_mm_mul_ps(_mm_loadu_ps(tempA+24), b7));
         c2 = _mm_add_ps(c2,_mm_mul_ps(_mm_loadu_ps(tempA+28), b8));
         //c1 = _mm_add_ps(c1,_mm_mul_ps(_mm_loadu_ps(tempA+32), b9));
         //c2 = _mm_add_ps(c2,_mm_mul_ps(_mm_loadu_ps(tempA+36), b10));
         //c1 = _mm_add_ps(c1,_mm_mul_ps(_mm_loadu_ps(tempA+40), b11));
         //c2 = _mm_add_ps(c2,_mm_mul_ps(_mm_loadu_ps(tempA+44), b12));
         //c1 = _mm_add_ps(c1,_mm_mul_ps(_mm_loadu_ps(tempA+48), b13));
         //c2 = _mm_add_ps(c2,_mm_mul_ps(_mm_loadu_ps(tempA+52), b14));
         //c1 = _mm_add_ps(c1,_mm_mul_ps(_mm_loadu_ps(tempA+56), b15));
         //c2 = _mm_add_ps(c2,_mm_mul_ps(_mm_loadu_ps(tempA+60), b16));
         
         /*
         _mm_storeu_ps(temp,_mm_add_ps(c1,c2));
         C[j*64+i] = temp[0]+temp[1]+temp[2]+temp[3];
         */
         _mm_store_ss(C+j*lda+i,_mm_dp_ps(_mm_add_ps(c1,c2),_mm_set_ps(1.0,1.0,1.0,1.0),0xf1));
		 *(C + j*lda + i) += cij;
       }
    }        
}

void basic_sgemm (int lda, int A_row, int B_col, int A_col, float *A, float *B, float *C)
{
	int i, j, k;
	float *total = (float*)malloc(sizeof(float));
	__m128 sum, sum2;
	for (i = 0; i < A_row; ++i) {
		float* tempA = A + lda*i;
		for (j = 0; j < B_col; ++j) {
			float* tempB = B + lda*j;
			float cij = *(C + j*lda + i);
			//__m128 temp;
			sum = _mm_setzero_ps();
			sum2 = _mm_setzero_ps();
			//float cij = 0;
            for (k = 0; k < A_col/4*4; k = k + 4) {
				//cij += *(A + i + k*lda) * *(B + j*lda + k);
				sum = _mm_add_ps(sum, _mm_mul_ps(_mm_loadu_ps(tempA+k), _mm_loadu_ps(tempB+k)));
				//sum2 = _mm_add_ps(sum2, _mm_mul_ps(_mm_loadu_ps(tempA+4+k), _mm_loadu_ps(tempB+4+k)));
				//sum = _mm_add_ps(sum, _mm_mul_ps(_mm_loadu_ps(tempA+8+k), _mm_loadu_ps(tempB+8+k)));
				//sum2 = _mm_add_ps(sum2, _mm_mul_ps(_mm_loadu_ps(tempA+12+k), _mm_loadu_ps(tempB+12+k)));
				//sum = _mm_add_ps(sum, _mm_mul_ps(_mm_loadu_ps(tempA+16+k), _mm_loadu_ps(tempB+16+k)));
				//sum2 = _mm_add_ps(sum2, _mm_mul_ps(_mm_loadu_ps(tempA+20+k), _mm_loadu_ps(tempB+20+k)));
				//sum = _mm_add_ps(sum, _mm_mul_ps(_mm_loadu_ps(tempA+24+k), _mm_loadu_ps(tempB+24+k)));
				//sum2 = _mm_add_ps(sum2, _mm_mul_ps(_mm_loadu_ps(tempA+28+k), _mm_loadu_ps(tempB+28+k)));
			}
			//float* total = (float*)malloc(sizeof(float));
			//_mm_store_ss(total,(_mm_dp_ps(sum,_mm_set_ps(1.0,1.0,1.0,1.0),0xf1)));
			
			_mm_store_ss(total,(_mm_dp_ps(_mm_add_ps(sum, sum2),_mm_set_ps(1.0,1.0,1.0,1.0),0xf1)));
			//float value[4];
			//_mm_storeu_ps(value,sum);
			//float total=value[0]+value[1]+value[2]+value[3];
			for (k=A_col/4*4; k<A_col;k++)
				cij += *(tempA + k) * *(tempB + k);
			*(C + j*lda + i) = *total+cij;
		}           
	}
}

void block(int lda, float *A, float *B, float *C, int i, int j, int k)
{
	int A_row = (i+BLOCK_SIZE > lda? lda-i : BLOCK_SIZE);
	int B_col = (j+BLOCK_SIZE > lda? lda-j : BLOCK_SIZE);
	int A_col = (k+BLOCK_SIZE > lda? lda-k : BLOCK_SIZE);
	basic_sgemm (lda, A_row, B_col, A_col, A + i*lda + k, B + k + j*lda, C + i + j*lda);
}

void square_sgemm(int n, float *A, float *B, float *C)
{
	float *D = (float*)malloc(n*n*sizeof(float));
	transpose(n, D, A);
	int r = n / BLOCK_SIZE;
	int q = n % BLOCK_SIZE;
    int n_blocks = n / BLOCK_SIZE + (q? 1 : 0);
    int bi, bj, bk, i, j, k;
	//omp_set_num_threads(8);
	#pragma omp parallel for private(i,j,bi,bj,bk)
    for (bi = 0; bi < n_blocks; ++bi) {
         i = bi * BLOCK_SIZE;  
         for (bj = 0; bj < n_blocks; ++bj) {
              j = bj * BLOCK_SIZE;
              /*for (bk = 0; bk < n_blocks/4*4; bk = bk+4) {
				   block (n, A, B, C, i, j, bk * BLOCK_SIZE);
				   block (n, A, B, C, i, j, (bk+1) * BLOCK_SIZE);
				   block (n, A, B, C, i, j, (bk+2) * BLOCK_SIZE);
				   block (n, A, B, C, i, j, (bk+3) * BLOCK_SIZE);
              }*/
			  for(bk = 0; bk < n_blocks; ++bk){
				  k = bk * BLOCK_SIZE;
				  if(bi <r && bj<r && bk <r)
					  square_sgemm32(n, D + i*n + k, B + k + j*n, C + i + j*n);
				  else
					  block(n, D, B, C, i, j, k);

			  }
         }
    }
}
/*
void square_sgemm(int n, float* A, float* B, float* C){
     float *D = (float*)malloc(n*n*sizeof(float));
     if (n==64){
        transpose(n, D, A);
        square_sgemm64(n, D, B, C);
     }
     else{
        transpose(n, D, A);
        square_sgemm_others(n, D, B, C);    
     }
}
*/
