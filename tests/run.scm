
(import scheme (chicken base) (chicken format) srfi-4 byte-sequence endian-sequence test)


(test-group "endian-sequence test"

            (test (sprintf "sint1 <-> endian-sequence (MSB)")
		  -40
		  (endian-sequence->sint1 (sint1->endian-sequence -40 MSB)))

            (test (sprintf "sint2 <-> endian-sequence (MSB)")
		  -4000
		  (endian-sequence->sint2 (sint2->endian-sequence -4000 MSB)))

            (test (sprintf "sint4 <-> endian-sequence (MSB)")
		  -40000
		  (endian-sequence->sint4 (sint4->endian-sequence -40000 MSB)))

            (test (sprintf "uint4 <-> endian-sequence (MSB)")
		  40000
		  (endian-sequence->uint4 (uint4->endian-sequence 40000 MSB)))

            (test (sprintf "ieee_float32 <-> endian-sequence (MSB)")
		  30.0
		  (endian-sequence->ieee_float32 (ieee_float32->endian-sequence 30.0 MSB)))

            (test (sprintf "ieee_float64 <-> endian-sequence (MSB)")
		  13.31
		  (endian-sequence->ieee_float64 (ieee_float64->endian-sequence 13.31 MSB)))

            (test (sprintf "s8vector <-> endian-sequence (MSB)")
                  (s8vector 1 -2 3 -4)
		  (endian-sequence->s8vector (s8vector->endian-sequence (s8vector 1 -2 3 -4) MSB)))

            (test (sprintf "s16vector <-> endian-sequence (MSB)")
                  (s16vector 100 -200 300 -400)
		  (endian-sequence->s16vector (s16vector->endian-sequence (s16vector 100 -200 300 -400) MSB)))

            (test (sprintf "s32vector <-> endian-sequence (MSB)")
                  (s32vector 100000 -200000 300000 -400000)
		  (endian-sequence->s32vector (s32vector->endian-sequence (s32vector 100000 -200000 300000 -400000) MSB)))

            (test (sprintf "u8vector <-> endian-sequence (MSB)")
                  (u8vector 1 2 3 4)
		  (endian-sequence->u8vector (u8vector->endian-sequence (u8vector 1 2 3 4) MSB)))

            (test (sprintf "u16vector <-> endian-sequence (MSB)")
                  (u16vector 100 200 300 400)
		  (endian-sequence->u16vector (u16vector->endian-sequence (u16vector 100 200 300 400) MSB)))

            (test (sprintf "s32vector <-> endian-sequence (MSB)")
                  (u32vector 100000 200000 300000 400000)
		  (endian-sequence->u32vector (u32vector->endian-sequence (u32vector 100000 200000 300000 400000) MSB)))

            (test (sprintf "f32vector <-> endian-sequence (MSB)")
                  (f32vector 100.0 200.1 300.2 400.3)
		  (endian-sequence->f32vector (f32vector->endian-sequence (f32vector  100.0 200.1 300.2 400.3) MSB)))

            (test (sprintf "f64vector <-> endian-sequence (MSB)")
                  (f64vector 10.01 21.12 32.23 43.34)
		  (endian-sequence->f64vector (f64vector->endian-sequence (f64vector 10.01 21.12 32.23 43.34) MSB)))


            (test (sprintf "sint1 <-> endian-sequence (LSB)")
		  -40
		  (endian-sequence->sint1 (sint1->endian-sequence -40 LSB)))

            (test (sprintf "sint2 <-> endian-sequence (LSB)")
		  -4000
		  (endian-sequence->sint2 (sint2->endian-sequence -4000 LSB)))

            (test (sprintf "sint4 <-> endian-sequence (LSB)")
		  -40000
		  (endian-sequence->sint4 (sint4->endian-sequence -40000 LSB)))

            (test (sprintf "uint4 <-> endian-sequence (LSB)")
		  40000
		  (endian-sequence->uint4 (uint4->endian-sequence 40000 LSB)))

            (test (sprintf "ieee_float32 <-> endian-sequence (LSB)")
		  30.0
		  (endian-sequence->ieee_float32 (ieee_float32->endian-sequence 30.0 LSB)))

            (test (sprintf "ieee_float64 <-> endian-sequence (LSB)")
		  13.31
		  (endian-sequence->ieee_float64 (ieee_float64->endian-sequence 13.31 LSB)))

            (test (sprintf "s8vector <-> endian-sequence (LSB)")
                  (s8vector 1 -2 3 -4)
		  (endian-sequence->s8vector (s8vector->endian-sequence (s8vector 1 -2 3 -4) LSB)))

            (test (sprintf "s16vector <-> endian-sequence (LSB)")
                  (s16vector 100 -200 300 -400)
		  (endian-sequence->s16vector (s16vector->endian-sequence (s16vector 100 -200 300 -400) LSB)))

            (test (sprintf "s32vector <-> endian-sequence (LSB)")
                  (s32vector 100000 -200000 300000 -400000)
		  (endian-sequence->s32vector (s32vector->endian-sequence (s32vector 100000 -200000 300000 -400000) LSB)))

            (test (sprintf "u8vector <-> endian-sequence (LSB)")
                  (u8vector 1 2 3 4)
		  (endian-sequence->u8vector (u8vector->endian-sequence (u8vector 1 2 3 4) LSB)))

            (test (sprintf "u16vector <-> endian-sequence (LSB)")
                  (u16vector 100 200 300 400)
		  (endian-sequence->u16vector (u16vector->endian-sequence (u16vector 100 200 300 400) LSB)))

            (test (sprintf "s32vector <-> endian-sequence (LSB)")
                  (u32vector 100000 200000 300000 400000)
		  (endian-sequence->u32vector (u32vector->endian-sequence (u32vector 100000 200000 300000 400000) LSB)))

            (test (sprintf "f32vector <-> endian-sequence (LSB)")
                  (f32vector 100.0 200.1 300.2 400.3)
		  (endian-sequence->f32vector (f32vector->endian-sequence (f32vector  100.0 200.1 300.2 400.3) LSB)))

            (test (sprintf "f64vector <-> endian-sequence (LSB)")
                  (f64vector 10.01 21.12 32.23 43.34)
		  (endian-sequence->f64vector (f64vector->endian-sequence (f64vector 10.01 21.12 32.23 43.34) LSB)))


            (test (sprintf "uint2 byte layout (MSB)")
                  (list 1 2)
		  (byte-sequence->list (endian-sequence->byte-sequence (uint2->endian-sequence #x0102 MSB))))

            (test (sprintf "uint2 byte layout (LSB)")
                  (list 2 1)
		  (byte-sequence->list (endian-sequence->byte-sequence (uint2->endian-sequence #x0102 LSB))))

            (test (sprintf "u32vector byte layout (MSB)")
                  (list 1 2 3 4 5 6 7 8)
		  (byte-sequence->list (endian-sequence->byte-sequence
					(u32vector->endian-sequence (u32vector #x01020304 #x05060708) MSB))))

            (test (sprintf "u32vector byte layout (LSB)")
                  (list 4 3 2 1 8 7 6 5)
		  (byte-sequence->list (endian-sequence->byte-sequence
					(u32vector->endian-sequence (u32vector #x01020304 #x05060708) LSB))))

            (test (sprintf "endian-sequence-length")
                  8
		  (endian-sequence-length (f64vector->endian-sequence (f64vector 1.0) LSB)))

            (test (sprintf "uint4 from byte sequence with offset (MSB)")
                  #x01020304
		  (endian-sequence->uint4
		   (byte-sequence->endian-sequence
		    (byte-sequence-drop (list->byte-sequence (list 9 9 1 2 3 4)) 2) MSB)))

            (test (sprintf "uint4 from byte sequence with offset (LSB)")
                  #x04030201
		  (endian-sequence->uint4
		   (byte-sequence->endian-sequence
		    (byte-sequence-drop (list->byte-sequence (list 9 9 1 2 3 4)) 2) LSB)))

            (test (sprintf "u16vector from byte sequence with offset (MSB)")
                  (u16vector #x0102 #x0304)
		  (endian-sequence->u16vector
		   (byte-sequence->endian-sequence
		    (byte-sequence-drop (list->byte-sequence (list 9 1 2 3 4)) 1) MSB)))

            (test (sprintf "u16vector from byte sequence with offset (LSB)")
                  (u16vector #x0201 #x0403)
		  (endian-sequence->u16vector
		   (byte-sequence->endian-sequence
		    (byte-sequence-drop (list->byte-sequence (list 9 1 2 3 4)) 1) LSB)))


)

(define (same-float? a b)
  (if (nan? a) (nan? b) (and (= a b) (eq? (negative? a) (negative? b)))))

(define (same-float-list? as bs)
  (and (= (length as) (length bs))
       (let loop ((as as) (bs bs))
         (or (null? as)
             (and (same-float? (car as) (car bs))
                  (loop (cdr as) (cdr bs)))))))

(test-group "IEEE special values"

            (for-each
             (lambda (mode name)
               (for-each
                (lambda (x)
                  (test-assert (sprintf "ieee_float32 ~A <-> endian-sequence (~A)" x name)
                               (same-float? x (endian-sequence->ieee_float32
                                               (ieee_float32->endian-sequence x mode))))
                  (test-assert (sprintf "ieee_float64 ~A <-> endian-sequence (~A)" x name)
                               (same-float? x (endian-sequence->ieee_float64
                                               (ieee_float64->endian-sequence x mode)))))
                (list +inf.0 -inf.0 +nan.0))

               (test-assert (sprintf "f32vector with specials <-> endian-sequence (~A)" name)
                            (same-float-list?
                             (list +inf.0 -inf.0 +nan.0 1.5)
                             (f32vector->list
                              (endian-sequence->f32vector
                               (f32vector->endian-sequence (f32vector +inf.0 -inf.0 +nan.0 1.5) mode)))))

               (test-assert (sprintf "f64vector with specials <-> endian-sequence (~A)" name)
                            (same-float-list?
                             (list +inf.0 -inf.0 +nan.0 1.5)
                             (f64vector->list
                              (endian-sequence->f64vector
                               (f64vector->endian-sequence (f64vector +inf.0 -inf.0 +nan.0 1.5) mode))))))
             (list MSB LSB)
             (list "MSB" "LSB"))

            (test-assert "ieee_float32 NaN from raw bytes (MSB)"
                         (nan? (endian-sequence->ieee_float32
                                (byte-sequence->endian-sequence
                                 (list->byte-sequence (list #x7f #xc0 0 0)) MSB))))

            (test-assert "ieee_float32 -inf from raw bytes (LSB)"
                         (same-float? -inf.0
                                      (endian-sequence->ieee_float32
                                       (byte-sequence->endian-sequence
                                        (list->byte-sequence (list 0 0 #x80 #xff)) LSB))))

            (test-assert "ieee_float64 NaN with low mantissa bit only (MSB)"
                         (nan? (endian-sequence->ieee_float64
                                (byte-sequence->endian-sequence
                                 (list->byte-sequence (list #x7f #xf0 0 0 0 0 0 1)) MSB))))

            (test-assert "ieee_float64 +inf from raw bytes (MSB)"
                         (same-float? +inf.0
                                      (endian-sequence->ieee_float64
                                       (byte-sequence->endian-sequence
                                        (list->byte-sequence (list #x7f #xf0 0 0 0 0 0 0)) MSB))))
)

(test-exit)
