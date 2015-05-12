/* IEEE floating point support routines, for GDB, the GNU Debugger.
   Copyright 1991, 1994, 1999, 2000, 2003, 2005, 2006
   Free Software Foundation, Inc.

This file is part of GDB.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street - Fifth Floor, Boston, MA 02110-1301, USA.  */

/* This is needed to pick up the NAN macro on some systems.  */
#define _GNU_SOURCE

#include <stdlib.h>
#include <math.h>
#include <string.h>

/* On some platforms, <float.h> provides DBL_QNAN.  */
#ifdef STDC_HEADERS
#include <float.h>
#endif

#include "floatformat.h"

#ifndef INFINITY
#ifdef HUGE_VAL
#define INFINITY HUGE_VAL
#else
#define INFINITY (1.0 / 0.0)
#endif
#endif

#ifndef NAN
#ifdef DBL_QNAN
#define NAN DBL_QNAN
#else
#define NAN (0.0 / 0.0)
#endif
#endif

unsigned long get_field (const unsigned char *,
			 enum floatformat_byteorders,
			 unsigned int,
			 unsigned int,
			 unsigned int);

static int floatformat_always_valid (const struct floatformat *fmt,
                                     const void *from);

static int
floatformat_always_valid (const struct floatformat *fmt,
                          const void *from)
{
  return 1;
}

/* The odds that CHAR_BIT will be anything but 8 are low enough that I'm not
   going to bother with trying to muck around with whether it is defined in
   a system header, what we do if not, etc.  */
#define FLOATFORMAT_CHAR_BIT 8

/* floatformats for IEEE single and double, big and little endian.  */
const struct floatformat floatformat_ieee_single_big =
{
  floatformat_big, 32, 0, 1, 8, 127, 255, 9, 23,
  floatformat_intbit_no,
  "floatformat_ieee_single_big",
  floatformat_always_valid
};
const struct floatformat floatformat_ieee_single_little =
{
  floatformat_little, 32, 0, 1, 8, 127, 255, 9, 23,
  floatformat_intbit_no,
  "floatformat_ieee_single_little",
  floatformat_always_valid
};
const struct floatformat floatformat_ieee_double_big =
{
  floatformat_big, 64, 0, 1, 11, 1023, 2047, 12, 52,
  floatformat_intbit_no,
  "floatformat_ieee_double_big",
  floatformat_always_valid
};
const struct floatformat floatformat_ieee_double_little =
{
  floatformat_little, 64, 0, 1, 11, 1023, 2047, 12, 52,
  floatformat_intbit_no,
  "floatformat_ieee_double_little",
  floatformat_always_valid
};

/* floatformat for IEEE double, little endian byte order, with big endian word
   ordering, as on the ARM.  */

const struct floatformat floatformat_ieee_double_littlebyte_bigword =
{
  floatformat_littlebyte_bigword, 64, 0, 1, 11, 1023, 2047, 12, 52,
  floatformat_intbit_no,
  "floatformat_ieee_double_littlebyte_bigword",
  floatformat_always_valid
};

/* floatformat for VAX.  Not quite IEEE, but close enough.  */

const struct floatformat floatformat_vax_f =
{
  floatformat_vax, 32, 0, 1, 8, 129, 0, 9, 23,
  floatformat_intbit_no,
  "floatformat_vax_f",
  floatformat_always_valid
};
const struct floatformat floatformat_vax_d =
{
  floatformat_vax, 64, 0, 1, 8, 129, 0, 9, 55,
  floatformat_intbit_no,
  "floatformat_vax_d",
  floatformat_always_valid
};
const struct floatformat floatformat_vax_g =
{
  floatformat_vax, 64, 0, 1, 11, 1025, 0, 12, 52,
  floatformat_intbit_no,
  "floatformat_vax_g",
  floatformat_always_valid
};

static int floatformat_i387_ext_is_valid (const struct floatformat *fmt,
					  const void *from);

static int
floatformat_i387_ext_is_valid (const struct floatformat *fmt, const void *from)
{
  /* In the i387 double-extended format, if the exponent is all ones,
     then the integer bit must be set.  If the exponent is neither 0
     nor ~0, the intbit must also be set.  Only if the exponent is
     zero can it be zero, and then it must be zero.  */
  unsigned long exponent, int_bit;
  const unsigned char *ufrom = from;

  exponent = get_field (ufrom, fmt->byteorder, fmt->totalsize,
			fmt->exp_start, fmt->exp_len);
  int_bit = get_field (ufrom, fmt->byteorder, fmt->totalsize,
		       fmt->man_start, 1);

  if ((exponent == 0) != (int_bit == 0))
    return 0;
  else
    return 1;
}

const struct floatformat floatformat_i387_ext =
{
  floatformat_little, 80, 0, 1, 15, 0x3fff, 0x7fff, 16, 64,
  floatformat_intbit_yes,
  "floatformat_i387_ext",
  floatformat_i387_ext_is_valid
};
const struct floatformat floatformat_m68881_ext =
{
  /* Note that the bits from 16 to 31 are unused.  */
  floatformat_big, 96, 0, 1, 15, 0x3fff, 0x7fff, 32, 64,
  floatformat_intbit_yes,
  "floatformat_m68881_ext",
  floatformat_always_valid
};
const struct floatformat floatformat_i960_ext =
{
  /* Note that the bits from 0 to 15 are unused.  */
  floatformat_little, 96, 16, 17, 15, 0x3fff, 0x7fff, 32, 64,
  floatformat_intbit_yes,
  "floatformat_i960_ext",
  floatformat_always_valid
};
const struct floatformat floatformat_m88110_ext =
{
  floatformat_big, 80, 0, 1, 15, 0x3fff, 0x7fff, 16, 64,
  floatformat_intbit_yes,
  "floatformat_m88110_ext",
  floatformat_always_valid
};
const struct floatformat floatformat_m88110_harris_ext =
{
  /* Harris uses raw format 128 bytes long, but the number is just an ieee
     double, and the last 64 bits are wasted. */
  floatformat_big,128, 0, 1, 11,  0x3ff,  0x7ff, 12, 52,
  floatformat_intbit_no,
  "floatformat_m88110_ext_harris",
  floatformat_always_valid
};
const struct floatformat floatformat_arm_ext_big =
{
  /* Bits 1 to 16 are unused.  */
  floatformat_big, 96, 0, 17, 15, 0x3fff, 0x7fff, 32, 64,
  floatformat_intbit_yes,
  "floatformat_arm_ext_big",
  floatformat_always_valid
};
const struct floatformat floatformat_arm_ext_littlebyte_bigword =
{
  /* Bits 1 to 16 are unused.  */
  floatformat_littlebyte_bigword, 96, 0, 17, 15, 0x3fff, 0x7fff, 32, 64,
  floatformat_intbit_yes,
  "floatformat_arm_ext_littlebyte_bigword",
  floatformat_always_valid
};
const struct floatformat floatformat_ia64_spill_big =
{
  floatformat_big, 128, 0, 1, 17, 65535, 0x1ffff, 18, 64,
  floatformat_intbit_yes,
  "floatformat_ia64_spill_big",
  floatformat_always_valid
};
const struct floatformat floatformat_ia64_spill_little =
{
  floatformat_little, 128, 0, 1, 17, 65535, 0x1ffff, 18, 64,
  floatformat_intbit_yes,
  "floatformat_ia64_spill_little",
  floatformat_always_valid
};
const struct floatformat floatformat_ia64_quad_big =
{
  floatformat_big, 128, 0, 1, 15, 16383, 0x7fff, 16, 112,
  floatformat_intbit_no,
  "floatformat_ia64_quad_big",
  floatformat_always_valid
};
const struct floatformat floatformat_ia64_quad_little =
{
  floatformat_little, 128, 0, 1, 15, 16383, 0x7fff, 16, 112,
  floatformat_intbit_no,
  "floatformat_ia64_quad_little",
  floatformat_always_valid
};

/* Extract a field which starts at START and is LEN bytes long.  DATA and
   TOTAL_LEN are the thing we are extracting it from, in byteorder ORDER.  */
unsigned long
get_field (const unsigned char *data, enum floatformat_byteorders order,
	   unsigned int total_len, unsigned int start, unsigned int len)
{
  unsigned long result;
  unsigned int cur_byte;
  int cur_bitshift;

  /* Start at the least significant part of the field.  */
  if (order == floatformat_little || order == floatformat_littlebyte_bigword)
    {
      /* We start counting from the other end (i.e, from the high bytes
	 rather than the low bytes).  As such, we need to be concerned
	 with what happens if bit 0 doesn't start on a byte boundary. 
	 I.e, we need to properly handle the case where total_len is
	 not evenly divisible by 8.  So we compute ``excess'' which
	 represents the number of bits from the end of our starting
	 byte needed to get to bit 0. */
      int excess = FLOATFORMAT_CHAR_BIT - (total_len % FLOATFORMAT_CHAR_BIT);
      cur_byte = (total_len / FLOATFORMAT_CHAR_BIT) 
                 - ((start + len + excess) / FLOATFORMAT_CHAR_BIT);
      cur_bitshift = ((start + len + excess) % FLOATFORMAT_CHAR_BIT) 
                     - FLOATFORMAT_CHAR_BIT;
    }
  else
    {
      cur_byte = (start + len) / FLOATFORMAT_CHAR_BIT;
      cur_bitshift =
	((start + len) % FLOATFORMAT_CHAR_BIT) - FLOATFORMAT_CHAR_BIT;
    }
  if (cur_bitshift > -FLOATFORMAT_CHAR_BIT)
    result = *(data + cur_byte) >> (-cur_bitshift);
  else
    result = 0;
  cur_bitshift += FLOATFORMAT_CHAR_BIT;
  if (order == floatformat_little || order == floatformat_littlebyte_bigword)
    ++cur_byte;
  else
    --cur_byte;

  /* Move towards the most significant part of the field.  */
  while (cur_bitshift < len)
    {
      result |= (unsigned long)*(data + cur_byte) << cur_bitshift;
      cur_bitshift += FLOATFORMAT_CHAR_BIT;
      if (order == floatformat_little || order == floatformat_littlebyte_bigword)
	++cur_byte;
      else
	--cur_byte;
    }
  if (len < sizeof(result) * FLOATFORMAT_CHAR_BIT)
    /* Mask out bits which are not part of the field */
    result &= ((1UL << len) - 1);
  return result;
}

  
#ifndef min
#define min(a, b) ((a) < (b) ? (a) : (b))
#endif

/* Convert from FMT to a double
   FROM is the address of the extended float.
   Store the double in *TO.  */

void 
floatformat_to_double (const struct floatformat *fmt,
		       const void *from,
		       double *to)
{
  unsigned char *ufrom = (unsigned char *) from;
  double dto;
  long exponent;
  unsigned long mant;
  unsigned int mant_bits, mant_off;
  int mant_bits_left;
  int special_exponent;		/* It's a NaN, denorm or zero */

  /* If the mantissa bits are not contiguous from one end of the
     mantissa to the other, we need to make a private copy of the
     source bytes that is in the right order since the unpacking
     algorithm assumes that the bits are contiguous.

     Swap the bytes individually rather than accessing them through
     "long *" since we have no guarantee that they start on a long
     alignment, and also sizeof(long) for the host could be different
     than sizeof(long) for the target.  FIXME: Assumes sizeof(long)
     for the target is 4. */

  if (fmt->byteorder == floatformat_littlebyte_bigword)
    {
      static unsigned char *newfrom;
      unsigned char *swapin, *swapout;
      int longswaps;

      longswaps = fmt->totalsize / FLOATFORMAT_CHAR_BIT;
      longswaps >>= 3;

      if (newfrom == NULL)
	{
	  newfrom = (unsigned char *) malloc (fmt->totalsize);
	}
      swapout = newfrom;
      swapin = ufrom;
      ufrom = newfrom;
      while (longswaps-- > 0)
	{
	  /* This is ugly, but efficient */
	  *swapout++ = swapin[4];
	  *swapout++ = swapin[5];
	  *swapout++ = swapin[6];
	  *swapout++ = swapin[7];
	  *swapout++ = swapin[0];
	  *swapout++ = swapin[1];
	  *swapout++ = swapin[2];
	  *swapout++ = swapin[3];
	  swapin += 8;
	}
    }

  exponent = get_field (ufrom, fmt->byteorder, fmt->totalsize,
			fmt->exp_start, fmt->exp_len);
  /* Note that if exponent indicates a NaN, we can't really do anything useful
     (not knowing if the host has NaN's, or how to build one).  So it will
     end up as an infinity or something close; that is OK.  */

  mant_bits_left = fmt->man_len;
  mant_off = fmt->man_start;
  dto = 0.0;

  special_exponent = exponent == 0 || exponent == fmt->exp_nan;

  /* Don't bias NaNs. Use minimum exponent for denorms. For simplicity,
     we don't check for zero as the exponent doesn't matter.  Note the cast
     to int; exp_bias is unsigned, so it's important to make sure the
     operation is done in signed arithmetic.  */
  if (!special_exponent)
    exponent -= fmt->exp_bias;
  else if (exponent == 0)
    exponent = 1 - fmt->exp_bias;

  /* Build the result algebraically.  Might go infinite, underflow, etc;
     who cares. */

/* If this format uses a hidden bit, explicitly add it in now.  Otherwise,
   increment the exponent by one to account for the integer bit.  */

  if (!special_exponent)
    {
      if (fmt->intbit == floatformat_intbit_no)
	dto = ldexp (1.0, exponent);
      else
	exponent++;
    }

  while (mant_bits_left > 0)
    {
      mant_bits = min (mant_bits_left, 32);

      mant = get_field (ufrom, fmt->byteorder, fmt->totalsize,
			mant_off, mant_bits);

      dto += ldexp ((double) mant, exponent - mant_bits);
      exponent -= mant_bits;
      mant_off += mant_bits;
      mant_bits_left -= mant_bits;
    }

  /* Negate it if negative.  */
  if (get_field (ufrom, fmt->byteorder, fmt->totalsize, fmt->sign_start, 1))
    dto = -dto;
  *to = dto;
}

/* Set a field which starts at START and is LEN bytes long.  DATA and
   TOTAL_LEN are the thing we are extracting it from, in byteorder ORDER.  */
static void
put_field (unsigned char *data, enum floatformat_byteorders order,
	   unsigned int total_len, unsigned int start, unsigned int len,
	   unsigned long stuff_to_put)
{
  unsigned int cur_byte;
  int cur_bitshift;

  /* Start at the least significant part of the field.  */
  if (order == floatformat_little || order == floatformat_littlebyte_bigword)
    {
      int excess = FLOATFORMAT_CHAR_BIT - (total_len % FLOATFORMAT_CHAR_BIT);
      cur_byte = (total_len / FLOATFORMAT_CHAR_BIT) 
                 - ((start + len + excess) / FLOATFORMAT_CHAR_BIT);
      cur_bitshift = ((start + len + excess) % FLOATFORMAT_CHAR_BIT) 
                     - FLOATFORMAT_CHAR_BIT;
    }
  else
    {
      cur_byte = (start + len) / FLOATFORMAT_CHAR_BIT;
      cur_bitshift =
	((start + len) % FLOATFORMAT_CHAR_BIT) - FLOATFORMAT_CHAR_BIT;
    }
  if (cur_bitshift > -FLOATFORMAT_CHAR_BIT)
    {
      *(data + cur_byte) &=
	~(((1 << ((start + len) % FLOATFORMAT_CHAR_BIT)) - 1)
	  << (-cur_bitshift));
      *(data + cur_byte) |=
	(stuff_to_put & ((1 << FLOATFORMAT_CHAR_BIT) - 1)) << (-cur_bitshift);
    }
  cur_bitshift += FLOATFORMAT_CHAR_BIT;
  if (order == floatformat_little || order == floatformat_littlebyte_bigword)
    ++cur_byte;
  else
    --cur_byte;

  /* Move towards the most significant part of the field.  */
  while (cur_bitshift < len)
    {
      if (len - cur_bitshift < FLOATFORMAT_CHAR_BIT)
	{
	  /* This is the last byte.  */
	  *(data + cur_byte) &=
	    ~((1 << (len - cur_bitshift)) - 1);
	  *(data + cur_byte) |= (stuff_to_put >> cur_bitshift);
	}
      else
	*(data + cur_byte) = ((stuff_to_put >> cur_bitshift)
			      & ((1 << FLOATFORMAT_CHAR_BIT) - 1));
      cur_bitshift += FLOATFORMAT_CHAR_BIT;
      if (order == floatformat_little || order == floatformat_littlebyte_bigword)
	++cur_byte;
      else
	--cur_byte;
    }
}




/* The converse: convert the double *FROM to an extended float
   and store where TO points.  Neither FROM nor TO have any alignment
   restrictions.  */

void
double_to_floatformat (const struct floatformat *fmt,
		       const double *from,
		       void *to)
{
  double dfrom;
  int exponent;
  double mant;
  unsigned int mant_bits, mant_off;
  int mant_bits_left;
  unsigned char *uto = (unsigned char *) to;

  memcpy (&dfrom, from, sizeof (dfrom));
  memset (uto, 0, (fmt->totalsize + FLOATFORMAT_CHAR_BIT - 1) 
                    / FLOATFORMAT_CHAR_BIT);
  if (dfrom == 0)
    return;			/* Result is zero */
  if (dfrom != dfrom)		/* Result is NaN */
    {
      /* From is NaN */
      put_field (uto, fmt->byteorder, fmt->totalsize, fmt->exp_start,
		 fmt->exp_len, fmt->exp_nan);
      /* Be sure it's not infinity, but NaN value is irrel */
      put_field (uto, fmt->byteorder, fmt->totalsize, fmt->man_start,
		 32, 1);
      return;
    }

  /* If negative, set the sign bit.  */
  if (dfrom < 0)
    {
      put_field (uto, fmt->byteorder, fmt->totalsize, fmt->sign_start, 1, 1);
      dfrom = -dfrom;
    }

  if (dfrom + dfrom == dfrom && dfrom != 0.0)	/* Result is Infinity */
    {
      /* Infinity exponent is same as NaN's.  */
      put_field (uto, fmt->byteorder, fmt->totalsize, fmt->exp_start,
		 fmt->exp_len, fmt->exp_nan);
      /* Infinity mantissa is all zeroes.  */
      put_field (uto, fmt->byteorder, fmt->totalsize, fmt->man_start,
		 fmt->man_len, 0);
      return;
    }

  mant = frexp (dfrom, &exponent);

  if (exponent + fmt->exp_bias - 1 > 0)
       put_field (uto, fmt->byteorder, fmt->totalsize, fmt->exp_start,
		  fmt->exp_len, exponent + fmt->exp_bias - 1);
  else
  {
       /* Handle a denormalized number.  FIXME: What should we do for
	  non-IEEE formats?  */
       put_field (uto, fmt->byteorder, fmt->totalsize, fmt->exp_start,
		  fmt->exp_len, 0);
       mant = ldexp (mant, exponent + fmt->exp_bias - 1);
  }

  mant_bits_left = fmt->man_len;
  mant_off = fmt->man_start;
  while (mant_bits_left > 0)
    {
	 unsigned long mant_long;

	 mant_bits = mant_bits_left < 32 ? mant_bits_left : 32;
	 
	 mant *= 4294967296.0;
	 mant_long = ((unsigned long) mant) & 0xffffffffL;
	 mant -= mant_long;
	 
         /* If the integer bit is implicit, and we are not creating a
	    denormalized number, then we need to discard it.  */
	 if (mant_bits_left == fmt->man_len
	     && fmt->intbit == floatformat_intbit_no
	     && exponent + fmt->exp_bias - 1 > 0)
	 {
	      mant_long <<= 1;
	      mant_long &= 0xffffffffL;

	      if (mant_bits == 32)
		   mant_bits -= 1;
	 }
	 
	 if (mant_bits < 32)
	 {
	      /* The bits we want are in the most significant MANT_BITS bits of
		 mant_long.  Move them to the least significant.  */
	      mant_long >>= 32 - mant_bits;
	 }
	 
	 
	 put_field (uto, fmt->byteorder, fmt->totalsize,
		    mant_off, mant_bits, mant_long);
	 mant_off += mant_bits;
	 mant_bits_left -= mant_bits;
    }
  
     if (fmt->byteorder == floatformat_littlebyte_bigword)
     {
	  int count;
	  unsigned char *swaplow = uto;
	  unsigned char *swaphigh = uto + 4;
	  unsigned char tmp;
	  
	  for (count = 0; count < 4; count++)
	  {
	       tmp = *swaplow;
	       *swaplow++ = *swaphigh;
	       *swaphigh++ = tmp;
	  }
     }
}



/* Return non-zero iff the data at FROM is a valid number in format FMT.  */

int
floatformat_is_valid (const struct floatformat *fmt, const void *from)
{
  return fmt->is_valid (fmt, from);
}


#ifdef IEEE_DEBUG

#include <stdio.h>

/* This is to be run on a host which uses IEEE floating point.  */

void
ieee_test (double n)
{
  double result;
  float s;

  floatformat_to_double (&floatformat_ieee_single_big, &n, &s);
  if ((n != s && (! isnan (n) || ! isnan (s)))
      || (n < 0 && s >= 0)
      || (n >= 0 && s < 0))
    printf ("IEEE single: differ(to): %.20g -> %.20g\n", n, s);

  double_to_floatformat (&floatformat_ieee_single_big, &n, &result, 1);
  if ((n != result && (! isnan (n) || ! isnan (result)))
      || (n < 0 && result >= 0)
      || (n >= 0 && result < 0))
    printf ("IEEE single: differ(from): %.20g -> %.20g\n", n, result);

  floatformat_to_double (&floatformat_ieee_double_little, &n, &result);
  if ((n != result && (! isnan (n) || ! isnan (result)))
      || (n < 0 && result >= 0)
      || (n >= 0 && result < 0))
    printf ("IEEE double: differ(to): %.20g -> %.20g\n", n, result);

  double_to_floatformat (&floatformat_ieee_double_little, &n, &result, 1);
  if ((n != result && (! isnan (n) || ! isnan (result)))
      || (n < 0 && result >= 0)
      || (n >= 0 && result < 0))
    printf ("IEEE double: differ(from): %.20g -> %.20g\n", n, result);

#if 0
  {
    char exten[16];

    floatformat_from_double (&floatformat_m68881_ext, &n, exten);
    floatformat_to_double (&floatformat_m68881_ext, exten, &result);
    if (n != result)
      printf ("Differ(to+from): %.20g -> %.20g\n", n, result);
  }
#endif

#if IEEE_DEBUG > 1
  /* This is to be run on a host which uses 68881 format.  */
  {
    long double ex = *(long double *)exten;
    if (ex != n)
      printf ("Differ(from vs. extended): %.20g\n", n);
  }
#endif
}

int
main (void)
{
  ieee_test (0.0);
  ieee_test (0.5);
  ieee_test (3.0);
  ieee_test (256.0);
  ieee_test (0.12345);
  ieee_test (234235.78907234);
  ieee_test (-512.0);
  ieee_test (-0.004321);
  ieee_test (1.2E-70);
  ieee_test (1.2E-316);
  ieee_test (4.9406564584124654E-324);
  ieee_test (- 4.9406564584124654E-324);
  ieee_test (- 0.0);
  ieee_test (- INFINITY);
  ieee_test (- NAN);
  ieee_test (INFINITY);
  ieee_test (NAN);
  return 0;
}
#endif
