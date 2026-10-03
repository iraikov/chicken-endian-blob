;;
;;  Utility procedures for manipulating byte sequences in different
;;  endian formats.
;;
;;  Copyright 2009-2026 Ivan Raikov.
;;
;;
;; This program is free software: you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; A full copy of the GPL license can be found at
;; <http://www.gnu.org/licenses/>.
;;


(module endian-sequence

	(endian-sequence?
	 byte-sequence->endian-sequence
	 endian-sequence->byte-sequence
	 endian-sequence-length
	 endian-sequence-mode

	 endian-sequence->sint1
	 endian-sequence->sint2
	 endian-sequence->sint4
	 endian-sequence->uint1
	 endian-sequence->uint2
	 endian-sequence->uint4
	 endian-sequence->ieee_float32
	 endian-sequence->ieee_float64
	 endian-sequence->s8vector
	 endian-sequence->s16vector
	 endian-sequence->s32vector
	 endian-sequence->u8vector
	 endian-sequence->u16vector
	 endian-sequence->u32vector
	 endian-sequence->f32vector
	 endian-sequence->f64vector

	 sint1->endian-sequence
	 sint2->endian-sequence
	 sint4->endian-sequence
	 uint1->endian-sequence
	 uint2->endian-sequence
	 uint4->endian-sequence
	 ieee_float32->endian-sequence
	 ieee_float64->endian-sequence
	 s8vector->endian-sequence
	 s16vector->endian-sequence
	 s32vector->endian-sequence
	 u8vector->endian-sequence
	 u16vector->endian-sequence
	 u32vector->endian-sequence
	 f32vector->endian-sequence
	 f64vector->endian-sequence

	 MSB LSB
	 )


	(import scheme (chicken base) (chicken foreign)
                (chicken bytevector) (chicken number-vector)
                byte-sequence)

(define-record-type endian-sequence
  (make-endian-sequence object mode )
  endian-sequence?
  (object   endian-sequence-object )
  (mode     endian-sequence-mode )
  )

(define MSB    0)
(define LSB    1)

(define (byte-sequence->endian-sequence b . rest)
  (let-optionals rest ((mode MSB))
   (assert (byte-sequence? b))
   (make-endian-sequence b mode)))

(define endian-sequence->byte-sequence endian-sequence-object)

(define (endian-sequence-length b)
  (byte-sequence-length (endian-sequence->byte-sequence b)))

;; Returns a bytevector whose first bytes are the bytes of the given
;; endian sequence. byte-sequence->bytevector shares storage when the
;; sequence starts at offset 0 and copies otherwise; either way, the
;; bytes begin at index 0 of the result, so the C routines below are
;; always called with offset 0.

(define (endian-sequence-bytevector b)
  (byte-sequence->bytevector (endian-sequence->byte-sequence b)))


#>
#include "floatformat.h"

typedef enum { MSB, LSB } byte_order_t;

// Is the present machine mode MSB first?
int machine_mode_is_MSB (void)
{
    union {
        int i;
        char c[sizeof(int)];
    } x;
    x.i = 1;

    return (!(x.c[0] == 1));
}

// Is the given byte order MSB first?
int endian_mode_is_MSB(byte_order_t b) 
{ 
     return (b == MSB); 
}


void cfrom_sint1 (char item, unsigned char *b, unsigned int offset, int mode)
{
    b[offset] = item;
}

void cfrom_sint2 (short item, unsigned char *b, unsigned int offset, int mode)
{
     if ( endian_mode_is_MSB(mode) )
     {
	  b[offset+0] = (item>>8) & 0xff;
	  b[offset+1] = item & 0xff;
     }
     else
     {
	  b[offset+0] = item & 0xff;
	  b[offset+1] = (item>>8) & 0xff;
     }
}

void cfrom_sint4 (int item, unsigned char *b, unsigned int offset, int mode)
{
     int i, k;

     if ( endian_mode_is_MSB(mode) )
     {
	  k = 24;
	  for(i=0; i < 4; i++)
	  {
	       b[offset+i] = (item >> k) & 0xff;
	       k -= 8;
	  }
     }
     else
     {
	  for(i=0; i < 4; i++)
	  {
	       b[offset+i] = item & 0xff;
	       item >>= 8;
	  }
     }
}

void cfrom_uint1 (unsigned char item, unsigned char *b, unsigned int offset, int mode)
{
    b[offset] = item;
}

void cfrom_uint2 (unsigned short item, unsigned char *b, unsigned int offset, int mode)
{
     if ( endian_mode_is_MSB(mode) )
     {
	  b[offset+0] = (item>>8) & 0xff;
	  b[offset+1] = item & 0xff;
     }
     else
     {
	  b[offset+0] = item & 0xff;
	  b[offset+1] = (item>>8) & 0xff;
     }
}

void cfrom_uint4 (unsigned int item, unsigned char *b, unsigned int offset, int mode)
{
     int i, k;
     
     if ( endian_mode_is_MSB(mode) )
     {
	  k = 24;
	  for(i=0; i < 4; i++)
	  {
	       b[offset+i] = (item >> k) & 0xff;
	       k -= 8;
	  }
     }
     else
     {
	  for(i=0; i < 4; i++)
	  {
	       b[offset+i] = item & 0xff;
	       item >>= 8;
	  }
     }
}

void cfrom_ieee_float32 (float item, unsigned char *b, unsigned int offset, int mode)
{
     double d;

     d = item;

     if ( endian_mode_is_MSB(mode) )
     {
	  double_to_floatformat (&floatformat_ieee_single_big, &d, b+offset);
     }
     else
     {
	  double_to_floatformat (&floatformat_ieee_single_little, &d, b+offset);
     }
}


void cfrom_ieee_float64 (double item, unsigned char *b, unsigned int offset, int mode)
{
     double d;

     d = item;

     if ( endian_mode_is_MSB(mode) )
     {
	  double_to_floatformat (&floatformat_ieee_double_big, &d, b+offset);
     }
     else
     {
	  double_to_floatformat (&floatformat_ieee_double_little, &d, b+offset);
     }
}

void cfrom_s8vector (unsigned int n, unsigned char *b, char *v, unsigned int offset, int mode)
{
   memcpy((void *)(b+offset),(const void *)v,n);
}


void cfrom_s16vector (unsigned int n, unsigned char *b, short *v, unsigned int offset, int mode)
{
  unsigned int i,p; 

  p = offset;
  for (i=0; i<n; i++,p += 2)
  {
       cfrom_sint2 (v[i], b, p, mode);
  }
}


void cfrom_s32vector (unsigned int n, unsigned char *b, int *v, unsigned int offset, int mode)
{
  unsigned int i,p; 

  p = offset;
  for (i=0; i<n; i++,p += 4)
  {
       cfrom_sint4 (v[i], b, p, mode);
  }
}


void cfrom_u8vector (unsigned int n, unsigned char *b, unsigned char *v, unsigned int offset, int mode)
{
   memcpy((void *)(b+offset),(const void *)v,n);
}


void cfrom_u16vector (unsigned int n, unsigned char *b, unsigned short *v, unsigned int offset, int mode)
{
  unsigned int i,p; 

  p = offset;
  for (i=0; i<n; i++,p += 2)
  {
       cfrom_uint2 (v[i], b, p, mode);
  }
}


void cfrom_u32vector (unsigned int n, unsigned char *b, unsigned int *v, unsigned int offset, int mode)
{
  unsigned int i,p; 

  p = offset;
  for (i=0; i<n; i++,p += 4)
  {
       cfrom_uint4 (v[i], b, p, mode);
  }
}


void cfrom_f32vector (unsigned int n, unsigned char *b, float *v, unsigned int offset, int mode)
{
  unsigned int i,p; 

  p = offset;
  for (i=0; i<n; i++,p += 4)
  {
       cfrom_ieee_float32 (v[i], b, p, mode);
  }
}


void cfrom_f64vector (unsigned int n, unsigned char *b, double *v, unsigned int offset, int mode)
{
  unsigned int i,p; 

  p = offset;
  for (i=0; i<n; i++,p += 8)
  {
       cfrom_ieee_float64 (v[i], b, p, mode);
  }
}

char cto_sint1 (unsigned char *b, unsigned int offset, int mode)
{
   return b[offset];
}

short cto_sint2 (unsigned char *b, unsigned int offset, int mode)
{
   short result;
   
   if( endian_mode_is_MSB(mode) )
     result = (b[offset+0] << 8) | b[offset+1];
   else
     result = (b[offset+1] << 8) | b[offset+0];

   return (result);
}

int cto_sint4 (unsigned char *b, unsigned int offset, int mode)
{
   int result;

   if ( endian_mode_is_MSB(mode) )
        result = (b[offset+0] << 24) | (b[offset+1] << 16) |
	         (b[offset+2] << 8)  | (b[offset+3]);
     else
	  result = (b[offset+3] << 24) | (b[offset+2] << 16) |
	           (b[offset+1] << 8) | (b[offset+0]);

   return(result);
}

unsigned char cto_uint1 (unsigned char *b, unsigned int offset, int mode)
{
   return b[offset];
}

unsigned short cto_uint2 (unsigned char *b, unsigned int offset, int mode)
{
   unsigned short result;
   
   if( endian_mode_is_MSB(mode) )
     result = (b[offset+0] << 8) | b[offset+1];
   else
     result = (b[offset+1] << 8) | b[offset+0];

   return (result);
}

unsigned int cto_uint4 (unsigned char *b, unsigned int offset, int mode)
{
   unsigned int result;

   if ( endian_mode_is_MSB(mode) )
        result = (b[offset+0] << 24) | (b[offset+1] << 16) |
	         (b[offset+2] << 8)  | (b[offset+3]);
     else
	  result = (b[offset+3] << 24) | (b[offset+2] << 16) |
	           (b[offset+1] << 8) | (b[offset+0]);

   return(result);
}


float cto_ieee_float32 (unsigned char *b, unsigned int offset, int mode)
{
   ssize_t s;
   double d;
   const struct floatformat *fmt;
   unsigned long exponent;

   d = 0.0;

   if ( endian_mode_is_MSB(mode) )
   {
     fmt = &floatformat_ieee_single_big;
   }
   else
   {
     fmt = &floatformat_ieee_single_little;
   }

   exponent = get_field ((unsigned char *)(b+offset), fmt->byteorder, fmt->totalsize,
		         fmt->exp_start, fmt->exp_len);

   floatformat_to_double(fmt, b+offset, &d);

   return((float)d);
}

double cto_ieee_float64 (unsigned char *b, unsigned int offset, int mode)
{
   ssize_t s;
   double d;
   const struct floatformat *fmt;
   unsigned long exponent;

   d = 0.0;

   if ( endian_mode_is_MSB(mode) )
   {
     fmt = &floatformat_ieee_double_big;
   }
   else
   {
     fmt = &floatformat_ieee_double_little;
   }

   exponent = get_field ((unsigned char *)(b+offset), fmt->byteorder, fmt->totalsize,
		         fmt->exp_start, fmt->exp_len);

   floatformat_to_double(fmt, b+offset, &d);

   return(d);
}

void cto_s8vector (unsigned int n, char *v, unsigned char *b, unsigned int offset, int mode)
{
   memcpy((void *)v,(const void *)(b+offset),n);
}


void cto_s16vector (unsigned int n, short *v, unsigned char *b, unsigned int offset, int mode)
{
  unsigned int i,p; short r;

  p = offset;
  for (i=0; i<n; i++,p += 2)
  {
       r = cto_sint2 (b, p, mode);
       v[i] = r;
  }
}


void cto_s32vector (unsigned int n, int *v, unsigned char *b, unsigned int offset, int mode)
{
  unsigned int i,p; int r;

  p = offset;
  for (i=0; i<n; i++,p += 4)
  {
       r = cto_sint4 (b, p, mode);
       v[i] = r;
  }
}

void cto_u8vector (unsigned int n, unsigned char *v, unsigned char *b, unsigned int offset, int mode)
{
   memcpy((void *)v,(const void *)(b+offset),n);
}


void cto_u16vector (unsigned int n, unsigned short *v, unsigned char *b, unsigned int offset, int mode)
{
  unsigned int i,p; unsigned short r;

  p = offset;
  for (i=0; i<n; i++,p += 2)
  {
       r = cto_uint2 (b, p, mode);
       v[i] = r;
  }
}


void cto_u32vector (unsigned int n, unsigned int *v, unsigned char *b, unsigned int offset, int mode)
{
  unsigned int i,p; unsigned int r;

  p = offset;
  for (i=0; i<n; i++,p += 4)
  {
       r = cto_uint4 (b, p, mode);
       v[i] = r;
  }
}


void cto_f32vector (unsigned int n, float *v, unsigned char *b, unsigned int offset, int mode)
{
  unsigned int i,p; float r;

  p = offset;
  for (i=0; i<n; i++,p += 4)
  {
       r = cto_ieee_float32 (b, p, mode);
       v[i] = r;
  }
}


void cto_f64vector (unsigned int n, double *v, unsigned char *b, unsigned int offset, int mode)
{
  unsigned int i,p; double r;

  p = offset;
  for (i=0; i<n; i++,p += 8)
  {
       r = cto_ieee_float64 (b, p, mode);
       v[i] = r;
  }
}


<#

(define machine_mode_is_MSB 
  (foreign-lambda bool  "machine_mode_is_MSB" ))

(define from_sint1 
  (foreign-lambda void  "cfrom_sint1" byte nonnull-bytevector unsigned-int integer))

(define from_sint2
  (foreign-lambda void "cfrom_sint2" short nonnull-bytevector unsigned-int integer))

(define from_sint4
  (foreign-lambda void "cfrom_sint4" int nonnull-bytevector unsigned-int integer))


(define from_uint1 
  (foreign-lambda void  "cfrom_uint1" unsigned-byte nonnull-bytevector unsigned-int integer))

(define from_uint2
  (foreign-lambda void "cfrom_uint2" unsigned-short nonnull-bytevector unsigned-int integer))

(define from_uint4
  (foreign-lambda void "cfrom_uint4" unsigned-int nonnull-bytevector unsigned-int integer))

(define from_ieee_float32 
  (foreign-lambda void "cfrom_ieee_float32" float nonnull-bytevector unsigned-int integer ))

(define from_ieee_float64
    (foreign-lambda void "cfrom_ieee_float64" double nonnull-bytevector unsigned-int integer ))



(define from_s8vector 
  (foreign-lambda void  "cfrom_s8vector"  unsigned-int nonnull-bytevector s8vector unsigned-int integer ))

(define from_s16vector
  (foreign-lambda void "cfrom_s16vector"  unsigned-int nonnull-bytevector s16vector unsigned-int integer))

(define from_s32vector
  (foreign-lambda void "cfrom_s32vector"  unsigned-int nonnull-bytevector s32vector unsigned-int integer))

(define from_u8vector 
  (foreign-lambda void  "cfrom_u8vector"  unsigned-int nonnull-bytevector u8vector unsigned-int integer ))

(define from_u16vector
  (foreign-lambda void "cfrom_u16vector"  unsigned-int nonnull-bytevector u16vector unsigned-int integer))

(define from_u32vector
  (foreign-lambda void "cfrom_u32vector"  unsigned-int nonnull-bytevector u32vector unsigned-int integer))

(define from_f32vector
  (foreign-lambda void "cfrom_f32vector"  unsigned-int nonnull-bytevector f32vector unsigned-int integer))

(define from_f64vector
  (foreign-lambda void "cfrom_f64vector"  unsigned-int nonnull-bytevector f64vector unsigned-int integer))


(define to_sint1 
  (foreign-lambda byte  "cto_sint1" nonnull-bytevector unsigned-int integer))

(define to_sint2
  (foreign-lambda short "cto_sint2" nonnull-bytevector unsigned-int integer))

(define to_sint4
  (foreign-lambda int "cto_sint4" nonnull-bytevector unsigned-int integer))


(define to_uint1 
  (foreign-lambda unsigned-byte  "cto_uint1" nonnull-bytevector unsigned-int integer))

(define to_uint2
  (foreign-lambda unsigned-short "cto_uint2" nonnull-bytevector unsigned-int integer))

(define to_uint4
  (foreign-lambda unsigned-int "cto_uint4" nonnull-bytevector unsigned-int integer))

(define to_ieee_float32 
  (foreign-lambda float "cto_ieee_float32"  nonnull-bytevector unsigned-int integer ))

(define to_ieee_float64
    (foreign-lambda double "cto_ieee_float64"  nonnull-bytevector unsigned-int integer ))



(define to_s8vector 
  (foreign-lambda void "cto_s8vector" unsigned-int s8vector nonnull-bytevector unsigned-int integer ))

(define to_s16vector
  (foreign-lambda void "cto_s16vector" unsigned-int s16vector nonnull-bytevector unsigned-int integer))

(define to_s32vector
  (foreign-lambda void "cto_s32vector" unsigned-int s32vector nonnull-bytevector unsigned-int integer))

(define to_u8vector 
  (foreign-lambda void "cto_u8vector" unsigned-int u8vector nonnull-bytevector unsigned-int integer ))

(define to_u16vector
  (foreign-lambda void "cto_u16vector" unsigned-int u16vector nonnull-bytevector unsigned-int integer))

(define to_u32vector
  (foreign-lambda void "cto_u32vector" unsigned-int u32vector nonnull-bytevector unsigned-int integer))

(define to_f32vector
  (foreign-lambda void "cto_f32vector" unsigned-int f32vector nonnull-bytevector unsigned-int integer))

(define to_f64vector
  (foreign-lambda void "cto_f64vector" unsigned-int f64vector nonnull-bytevector unsigned-int integer))


(define machine-mode (if (machine_mode_is_MSB) MSB LSB))


(define (sint1->endian-sequence n . rest)
  (let-optionals rest ((mode MSB))
    (let ((bv (s8vector->bytevector/shared (s8vector n))))
      (if (not (= machine-mode mode))
	  (from_sint1 n bv 0 mode))
      (make-endian-sequence (bytevector->byte-sequence bv) mode))))


(define (sint2->endian-sequence n . rest)
  (let-optionals rest ((mode MSB))
    (let ((bv (s16vector->bytevector/shared (s16vector n))))
      (if (not (= machine-mode mode))
	  (from_sint2 n bv 0 mode))
      (make-endian-sequence (bytevector->byte-sequence bv) mode))))


(define (sint4->endian-sequence n . rest)
  (let-optionals rest ((mode MSB))
    (let ((bv (s32vector->bytevector/shared (s32vector n))))
      (if (not (= machine-mode mode))
	  (from_sint4 n bv 0 mode))
      (make-endian-sequence (bytevector->byte-sequence bv) mode))))


(define (uint1->endian-sequence n . rest)
  (let-optionals rest ((mode MSB))
    (let ((bv (u8vector n)))
      (if (not (= machine-mode mode))
	  (from_uint1 n bv 0 mode))
      (make-endian-sequence (bytevector->byte-sequence bv) mode))))


(define (uint2->endian-sequence n . rest)
  (let-optionals rest ((mode MSB))
    (let ((bv (u16vector->bytevector/shared (u16vector n))))
      (if (not (= machine-mode mode))
	  (from_uint2 n bv 0 mode))
      (make-endian-sequence (bytevector->byte-sequence bv) mode))))


(define (uint4->endian-sequence n . rest)
  (let-optionals rest ((mode MSB))
    (let ((bv (u32vector->bytevector/shared (u32vector n))))
      (if (not (= machine-mode mode))
	  (from_uint4 n bv 0 mode))
      (make-endian-sequence (bytevector->byte-sequence bv) mode))))


(define (ieee_float32->endian-sequence n . rest)
  (let-optionals rest ((mode MSB))
    (let ((bv (f32vector->bytevector/shared (f32vector n))))
      (if (not (= machine-mode mode))
	  (from_ieee_float32 n bv 0 mode))
      (make-endian-sequence (bytevector->byte-sequence bv) mode))))


(define (ieee_float64->endian-sequence n . rest)
  (let-optionals rest ((mode MSB))
    (let ((bv (f64vector->bytevector/shared (f64vector n))))
      (if (not (= machine-mode mode))
	  (from_ieee_float64 n bv 0 mode))
      (make-endian-sequence (bytevector->byte-sequence bv) mode))))


(define (s8vector->endian-sequence v . rest)
  (let-optionals rest ((mode MSB))
   (if (= machine-mode mode)
       (make-endian-sequence (s8vector->byte-sequence v) mode)
       (let* ((n  (s8vector-length v))
	      (bv (make-bytevector n 0)))
	 (from_s8vector n bv v 0 mode)
	 (make-endian-sequence (bytevector->byte-sequence bv) mode)))))


(define (s16vector->endian-sequence v . rest)
  (let-optionals rest ((mode MSB))
   (if (= machine-mode mode)
       (make-endian-sequence (s16vector->byte-sequence v) mode)
       (let* ((n  (s16vector-length v))
	      (bv (make-bytevector (* 2 n) 0)))
	 (from_s16vector n bv v 0 mode)
	 (make-endian-sequence (bytevector->byte-sequence bv) mode)))))


(define (s32vector->endian-sequence v . rest)
  (let-optionals rest ((mode MSB))
   (if (= machine-mode mode)
       (make-endian-sequence (s32vector->byte-sequence v) mode)
       (let* ((n  (s32vector-length v))
	      (bv (make-bytevector (* 4 n) 0)))
	 (from_s32vector n bv v 0 mode)
	 (make-endian-sequence (bytevector->byte-sequence bv) mode)))))


(define (u8vector->endian-sequence v . rest)
  (let-optionals rest ((mode MSB))
   (if (= machine-mode mode)
       (make-endian-sequence (u8vector->byte-sequence v) mode)
       (let* ((n  (u8vector-length v))
	      (bv (make-bytevector n 0)))
	 (from_u8vector n bv v 0 mode)
	 (make-endian-sequence (bytevector->byte-sequence bv) mode)))))


(define (u16vector->endian-sequence v . rest)
  (let-optionals rest ((mode MSB))
   (if (= machine-mode mode)
       (make-endian-sequence (u16vector->byte-sequence v) mode)
       (let* ((n  (u16vector-length v))
	      (bv (make-bytevector (* 2 n) 0)))
	 (from_u16vector n bv v 0 mode)
	 (make-endian-sequence (bytevector->byte-sequence bv) mode)))))


(define (u32vector->endian-sequence v . rest)
  (let-optionals rest ((mode MSB))
   (if (= machine-mode mode)
       (make-endian-sequence (u32vector->byte-sequence v) mode)
       (let* ((n  (u32vector-length v))
	      (bv (make-bytevector (* 4 n) 0)))
	 (from_u32vector n bv v 0 mode)
	 (make-endian-sequence (bytevector->byte-sequence bv) mode)))))


(define (f32vector->endian-sequence v . rest)
  (let-optionals rest ((mode MSB))
   (if (= machine-mode mode)
       (make-endian-sequence (f32vector->byte-sequence v) mode)
       (let* ((n  (f32vector-length v))
	      (bv (make-bytevector (* 4 n) 0)))
	 (from_f32vector n bv v 0 mode)
	 (make-endian-sequence (bytevector->byte-sequence bv) mode)))))


(define (f64vector->endian-sequence v . rest)
  (let-optionals rest ((mode MSB))
   (if (= machine-mode mode)
       (make-endian-sequence (f64vector->byte-sequence v) mode)
       (let* ((n  (f64vector-length v))
	      (bv (make-bytevector (* 8 n) 0)))
	 (from_f64vector n bv v 0 mode)
	 (make-endian-sequence (bytevector->byte-sequence bv) mode)))))


(define (endian-sequence->sint1 b)
  (assert (= (endian-sequence-length b) 1))
  (to_sint1 (endian-sequence-bytevector b) 0 (endian-sequence-mode b)))


(define (endian-sequence->sint2 b)
  (assert (= (endian-sequence-length b) 2))
  (to_sint2 (endian-sequence-bytevector b) 0 (endian-sequence-mode b)))


(define (endian-sequence->sint4 b)
  (assert (= (endian-sequence-length b) 4))
  (to_sint4 (endian-sequence-bytevector b) 0 (endian-sequence-mode b)))


(define (endian-sequence->uint1 b)
  (assert (= (endian-sequence-length b) 1))
  (to_uint1 (endian-sequence-bytevector b) 0 (endian-sequence-mode b)))


(define (endian-sequence->uint2 b)
  (assert (= (endian-sequence-length b) 2))
  (to_uint2 (endian-sequence-bytevector b) 0 (endian-sequence-mode b)))


(define (endian-sequence->uint4 b)
  (assert (= (endian-sequence-length b) 4))
  (to_uint4 (endian-sequence-bytevector b) 0 (endian-sequence-mode b)))


(define (endian-sequence->ieee_float32 b)
  (assert (= (endian-sequence-length b) 4))
  (to_ieee_float32 (endian-sequence-bytevector b) 0 (endian-sequence-mode b)))


(define (endian-sequence->ieee_float64 b)
  (assert (= (endian-sequence-length b) 8))
  (to_ieee_float64 (endian-sequence-bytevector b) 0 (endian-sequence-mode b)))


(define (endian-sequence->s8vector b)
  (let ((mode (endian-sequence-mode b))
	(n    (endian-sequence-length b)))
    (assert (positive? n))
    (if (= machine-mode mode)
	(byte-sequence->s8vector (endian-sequence->byte-sequence b))
	(let ((v (make-s8vector n 0)))
	  (to_s8vector n v (endian-sequence-bytevector b) 0 mode)
	  v))))


(define (endian-sequence->s16vector b)
  (let ((mode (endian-sequence-mode b))
	(n    (endian-sequence-length b)))
    (assert (and (positive? n) (zero? (modulo n 2))))
    (if (= machine-mode mode)
	(byte-sequence->s16vector (endian-sequence->byte-sequence b))
	(let* ((s (quotient n 2))
	       (v (make-s16vector s 0)))
	  (to_s16vector s v (endian-sequence-bytevector b) 0 mode)
	  v))))


(define (endian-sequence->s32vector b)
  (let ((mode (endian-sequence-mode b))
	(n    (endian-sequence-length b)))
    (assert (and (positive? n) (zero? (modulo n 4))))
    (if (= machine-mode mode)
	(byte-sequence->s32vector (endian-sequence->byte-sequence b))
	(let* ((s (quotient n 4))
	       (v (make-s32vector s 0)))
	  (to_s32vector s v (endian-sequence-bytevector b) 0 mode)
	  v))))


(define (endian-sequence->u8vector b)
  (let ((mode (endian-sequence-mode b))
	(n    (endian-sequence-length b)))
    (assert (positive? n))
    (if (= machine-mode mode)
	(byte-sequence->u8vector (endian-sequence->byte-sequence b))
	(let ((v (make-u8vector n 0)))
	  (to_u8vector n v (endian-sequence-bytevector b) 0 mode)
	  v))))


(define (endian-sequence->u16vector b)
  (let ((mode (endian-sequence-mode b))
	(n    (endian-sequence-length b)))
    (assert (and (positive? n) (zero? (modulo n 2))))
    (if (= machine-mode mode)
	(byte-sequence->u16vector (endian-sequence->byte-sequence b))
	(let* ((s (quotient n 2))
	       (v (make-u16vector s 0)))
	  (to_u16vector s v (endian-sequence-bytevector b) 0 mode)
	  v))))


(define (endian-sequence->u32vector b)
  (let ((mode (endian-sequence-mode b))
	(n    (endian-sequence-length b)))
    (assert (and (positive? n) (zero? (modulo n 4))))
    (if (= machine-mode mode)
	(byte-sequence->u32vector (endian-sequence->byte-sequence b))
	(let* ((s (quotient n 4))
	       (v (make-u32vector s 0)))
	  (to_u32vector s v (endian-sequence-bytevector b) 0 mode)
	  v))))


(define (endian-sequence->f32vector b)
  (let ((mode (endian-sequence-mode b))
	(n    (endian-sequence-length b)))
    (assert (and (positive? n) (zero? (modulo n 4))))
    (if (= machine-mode mode)
	(byte-sequence->f32vector (endian-sequence->byte-sequence b))
	(let* ((s (quotient n 4))
	       (v (make-f32vector s 0)))
	  (to_f32vector s v (endian-sequence-bytevector b) 0 mode)
	  v))))


(define (endian-sequence->f64vector b)
  (let ((mode (endian-sequence-mode b))
	(n    (endian-sequence-length b)))
    (assert (and (positive? n) (zero? (modulo n 8))))
    (if (= machine-mode mode)
	(byte-sequence->f64vector (endian-sequence->byte-sequence b))
	(let* ((s (quotient n 8))
	       (v (make-f64vector s 0)))
	  (to_f64vector s v (endian-sequence-bytevector b) 0 mode)
	  v))))


)
