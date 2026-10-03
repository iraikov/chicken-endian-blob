# endian-sequence

`endian-sequence` is a library of endian-specific procedures for
converting byte sequences to numeric values and vectors.

## Installation

```sh
chicken-install endian-sequence
```

## Usage

```scheme
(import srfi-4 byte-sequence endian-sequence)

(define s (uint2->endian-sequence #x0102 MSB))

(byte-sequence->list (endian-sequence->byte-sequence s))  ; => (1 2)
(endian-sequence->uint2 s)                                 ; => 258

(endian-sequence->u16vector
 (u16vector->endian-sequence (u16vector 100 200) LSB))     ; => #u16(100 200)
```

## Predicates and constants

```scheme
(endian-sequence? X) => BOOL
```

Returns `#t` if the given object is an endian sequence, `#f`
otherwise.

- `MSB`
- `LSB`

These constants specify most-significant or least-significant byte
order, respectively.

## Converting to and from byte sequences

```scheme
(byte-sequence->endian-sequence BYTE-SEQUENCE [BYTE-ORDER]) => ENDIAN-SEQUENCE
```

Returns an endian sequence containing the given byte sequence (see the
`byte-sequence` egg). Optional argument `BYTE-ORDER` is one of
`MSB` or `LSB`. Default is `MSB`.

```scheme
(endian-sequence->byte-sequence ENDIAN-SEQUENCE) => BYTE-SEQUENCE
```

Returns the byte sequence contained in the given endian sequence.

```scheme
(endian-sequence-length ENDIAN-SEQUENCE) => INTEGER
```

Returns the length of the given endian sequence in bytes.

```scheme
(endian-sequence-mode ENDIAN-SEQUENCE) => BYTE-ORDER
```

Returns the byte order (`MSB` or `LSB`) of the given endian sequence.

## Converting to and from numbers and numeric vectors

### Signed integers

```scheme
(endian-sequence->sint1 ENDIAN-SEQUENCE) => NUMBER
(endian-sequence->sint2 ENDIAN-SEQUENCE) => NUMBER
(endian-sequence->sint4 ENDIAN-SEQUENCE) => NUMBER
(sint1->endian-sequence NUMBER [MODE]) => ENDIAN-SEQUENCE
(sint2->endian-sequence NUMBER [MODE]) => ENDIAN-SEQUENCE
(sint4->endian-sequence NUMBER [MODE]) => ENDIAN-SEQUENCE
```

These procedures convert between endian sequences and signed integers of
size 1, 2, or 4 bytes, respectively. Exceptions are thrown if the
given endian sequences are of incorrect size, or if the given numbers are
too big to fit in the specified size. Optional argument `MODE`
indicates the endianness of the resulting endian sequence and can be one
of `MSB` or `LSB`. Default is `MSB`.

### Unsigned integers

```scheme
(endian-sequence->uint1 ENDIAN-SEQUENCE) => NUMBER
(endian-sequence->uint2 ENDIAN-SEQUENCE) => NUMBER
(endian-sequence->uint4 ENDIAN-SEQUENCE) => NUMBER
(uint1->endian-sequence NUMBER [MODE]) => ENDIAN-SEQUENCE
(uint2->endian-sequence NUMBER [MODE]) => ENDIAN-SEQUENCE
(uint4->endian-sequence NUMBER [MODE]) => ENDIAN-SEQUENCE
```

These procedures convert between endian sequences and unsigned integers of
size 1, 2, or 4 bytes, respectively. Exceptions are thrown if the
given endian sequences are of incorrect size, or if the given numbers are
too big to fit in the specified size. Optional argument `MODE`
indicates the endianness of the resulting endian sequence and can be one
of `MSB` or `LSB`. Default is `MSB`.

### IEEE floating point numbers

```scheme
(endian-sequence->ieee_float32 ENDIAN-SEQUENCE) => NUMBER
(endian-sequence->ieee_float64 ENDIAN-SEQUENCE) => NUMBER
(ieee_float32->endian-sequence NUMBER [MODE]) => ENDIAN-SEQUENCE
(ieee_float64->endian-sequence NUMBER [MODE]) => ENDIAN-SEQUENCE
```

These procedures convert between endian sequences and IEEE floating point
numbers of single or double precision, respectively. Exceptions are
thrown if the given endian sequences are of incorrect size, or if the
given numbers are too big to fit in the specified size. Optional
argument `MODE` indicates the endianness of the resulting endian
sequence and can be one of `MSB` or `LSB`. Default is `MSB`.

### SRFI-4 vectors

```scheme
(endian-sequence->s8vector  ENDIAN-SEQUENCE) => S8VECTOR
(endian-sequence->s16vector ENDIAN-SEQUENCE) => S16VECTOR
(endian-sequence->s32vector ENDIAN-SEQUENCE) => S32VECTOR
(endian-sequence->u8vector  ENDIAN-SEQUENCE) => U8VECTOR
(endian-sequence->u16vector ENDIAN-SEQUENCE) => U16VECTOR
(endian-sequence->u32vector ENDIAN-SEQUENCE) => U32VECTOR
(endian-sequence->f32vector ENDIAN-SEQUENCE) => F32VECTOR
(endian-sequence->f64vector ENDIAN-SEQUENCE) => F64VECTOR
(s8vector->endian-sequence  S8VECTOR  [MODE]) => ENDIAN-SEQUENCE
(s16vector->endian-sequence S16VECTOR [MODE]) => ENDIAN-SEQUENCE
(s32vector->endian-sequence S32VECTOR [MODE]) => ENDIAN-SEQUENCE
(u8vector->endian-sequence  U8VECTOR  [MODE]) => ENDIAN-SEQUENCE
(u16vector->endian-sequence U16VECTOR [MODE]) => ENDIAN-SEQUENCE
(u32vector->endian-sequence U32VECTOR [MODE]) => ENDIAN-SEQUENCE
(f32vector->endian-sequence F32VECTOR [MODE]) => ENDIAN-SEQUENCE
(f64vector->endian-sequence F64VECTOR [MODE]) => ENDIAN-SEQUENCE
```

These procedures convert between endian sequences and the corresponding
SRFI-4 vector type. Optional argument `MODE` indicates the
endianness of the resulting endian sequence and can be one of `MSB` or
`LSB`. Default is `MSB`.

## Version History

- **3.0** Ported to CHICKEN 6; renamed from endian-blob to endian-sequence,
  now built on byte-sequence and bytevectors
- **2.0** Ported to CHICKEN 5
- **1.4** Removed dependency on `ansidecl.h` (thanks to Peter Bex)
- **1.3** Added procedure `endian-blob-length`
- **1.2** Fixed a bug in `uint2->endian-blob` (thanks to Shawn Rutledge)
- **1.1** Some small optimizations
- **1.0** Initial release

## License

Copyright 2009-2026 Ivan Raikov.

endian-sequence is based on routines from the C++ advanced I/O library and
TIFF reader written by Oleg Kiselyov, as well as the floating-point
I/O routines from GDB.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at
your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
General Public License for more details.

A full copy of the GPL license can be found at
<http://www.gnu.org/licenses/>.
