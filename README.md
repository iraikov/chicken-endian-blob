[[tags: eggs]]
[[toc:]]

== endian-blob

=== Description

{{endian-blob}} is a library of endian-specific procedures for
converting blobs to numeric values and vectors. 

=== Library Procedures

==== Predicates and constants

<procedure>(endian-blob? X) => BOOL</procedure>

Returns {{#t}} if the given object is an endian blob, {{#f}}
otherwise.

* {{MSB}}
* {{LSB}}

These constants specify most-significant or least-significant byte
order, respectively.

==== Converting to and from byte blobs

<procedure>(byte-blob->endian-blob BYTE-BLOB BYTE-ORDER)</procedure>

Returns an endian blob containing the given byte-blob. Argument
{{BYTE-ORDER}} is one of {{MSB}} or {{LSB}}.

==== Converting to and from numbers and numeric vectors 

<procedure>(endian-blob->sint1 ENDIAN-BLOB) => NUMBER</procedure><br>
<procedure>(endian-blob->sint2 ENDIAN-BLOB) => NUMBER</procedure><br>
<procedure>(endian-blob->sint4 ENDIAN-BLOB) => NUMBER</procedure><br>
<procedure>(sint1->endian-blob NUMBER [* MODE]) => ENDIAN-BLOB</procedure><br>
<procedure>(sint2->endian-blob NUMBER [* MODE]) => ENDIAN-BLOB</procedure><br>
<procedure>(sint4->endian-blob NUMBER [* MODE]) => ENDIAN-BLOB</procedure><br>

These procedures convert between endian blobs and signed integers of
size 1, 2, or 4 bytes, respectively. Exceptions are thrown if the
given endian blobs are of incorrect size, or if the given numbers are
too big to fit in the specified size. Optional argument {{MODE}}
indicates the endianness of the resulting endian blob and can be one
of {{MSBB}} or {{LSB}}.  Default is {{MSB}}.

<procedure>(endian-blob->uint1 ENDIAN-BLOB) => NUMBER</procedure><br>
<procedure>(endian-blob->uint2 ENDIAN-BLOB) => NUMBER</procedure><br>
<procedure>(endian-blob->uint4 ENDIAN-BLOB) => NUMBER</procedure><br>
<procedure>(uint1->endian-blob NUMBER [* MODE]) => ENDIAN-BLOB</procedure><br>
<procedure>(uint2->endian-blob NUMBER [* MODE]) => ENDIAN-BLOB</procedure><br>
<procedure>(uint4->endian-blob NUMBER [* MODE]) => ENDIAN-BLOB</procedure><br>

These procedures convert between endian blobs and unsigned integers of
size 1, 2, or 4 bytes, respectively. Exceptions are thrown if the
given endian blobs are of incorrect size, or if the given numbers are
too big to fit in the specified size. Optional argument {{MODE}}
indicates the endianness of the resulting endian blob and can be one
of {{MSBB}} or {{LSB}}.  Default is {{MSB}}.

<procedure>(endian-blob->ieee_float32 ENDIAN-BLOB) => NUMBER</procedure><br>
<procedure>(endian-blob->ieee_float64 ENDIAN-BLOB) => NUMBER</procedure><br>
<procedure>(ieee_float32->endian-blob NUMBER [* MODE]) => ENDIAN-BLOB</procedure><br>
<procedure>(ieee_float64->endian-blob NUMBER [* MODE]) => ENDIAN-BLOB</procedure><br>

These procedures convert between endian blobs and IEEE floating point
numbers of single or double precision, respectively. Exceptions are
thrown if the given endian blobs are of incorrect size, or if the
given numbers are too big to fit in the specified size. Optional
argument {{MODE}} indicates the endianness of the resulting endian
blob and can be one of {{MSBB}} or {{LSB}}.  Default is {{MSB}}.

<procedure>(endian-blob->s8vector  ENDIAN-BLOB) => S8VECTOR</procedure><br>
<procedure>(endian-blob->s16vector ENDIAN-BLOB) => S16VECTOR</procedure><br>
<procedure>(endian-blob->s32vector ENDIAN-BLOB) => S32VECTOR</procedure><br>
<procedure>(endian-blob->u8vector  ENDIAN-BLOB) => U8VECTOR</procedure><br>
<procedure>(endian-blob->u16vector ENDIAN-BLOB) => U16VECTOR</procedure><br>
<procedure>(endian-blob->u32vector ENDIAN-BLOB) => U32VECTOR</procedure><br>
<procedure>(endian-blob->f32vector ENDIAN-BLOB) => F32VECTOR</procedure><br>
<procedure>(endian-blob->f64vector ENDIAN-BLOB) => F64VECTOR</procedure><br>
<procedure>(s8vector->endian-blob  S8VECTOR [* MODE])  => ENDIAN-BLOB</procedure><br>
<procedure>(s16vector->endian-blob S16VECTOR [* MODE]) => ENDIAN-BLOB</procedure><br>
<procedure>(s32vector->endian-blob S32VECTOR [* MODE]) => ENDIAN-BLOB</procedure><br>
<procedure>(u8vector->endian-blob  U8VECTOR  [* MODE])  => ENDIAN-BLOB</procedure><br>
<procedure>(u16vector->endian-blob U16VECTOR [* MODE]) => ENDIAN-BLOB</procedure><br>
<procedure>(u32vector->endian-blob U32VECTOR [* MODE]) => ENDIAN-BLOB</procedure><br>
<procedure>(f32vector->endian-blob F32VECTOR [* MODE]) => ENDIAN-BLOB</procedure><br>
<procedure>(f64vector->endian-blob F64VECTOR [* MODE]) => ENDIAN-BLOB</procedure><br>

These procedures convert between endian blobs and the corresponding
SRFI-4 vector type. Optional argument {{MODE}} indicates the
endianness of the resulting endian blob and can be one of {{MSBB}} or
{{LSB}}.  Default is {{MSB}}.

=== Version History

* 1.4 Removed dependency on ansidecl.h (thanks to Peter Bex)
* 1.3 Added procedure endian-blob-length
* 1.2 Fixed a bug in uint2->endian-blob (thanks to Shawn Rutledge)
* 1.1 Some small optimizations
* 1.0 Initial release

=== License

Copyright 2009-2012 Ivan Raikov.

endian-port is based on routines from the C++ advanced I/O library and
TIFF reader written by Oleg Kiselyov, as well as the floating-point
I/O routines from GDB.

endian-port is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at
your option) any later version.

endian-port is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

A full copy of the GPL license can be found at
<http://www.gnu.org/licenses/>.
