
(import scheme (chicken base) (chicken format) srfi-4 endian-blob test)


(test-group "endian-blob test"

            (test (sprintf "sint1 <-> endian-blob (MSB)")
		  -40
		  (endian-blob->sint1 (sint1->endian-blob -40 MSB)))

            (test (sprintf "sint2 <-> endian-blob (MSB)")
		  -4000
		  (endian-blob->sint2 (sint2->endian-blob -4000 MSB)))

            (test (sprintf "sint4 <-> endian-blob (MSB)")
		  -40000
		  (endian-blob->sint4 (sint4->endian-blob -40000 MSB)))

            (test (sprintf "uint4 <-> endian-blob (MSB)")
		  40000
		  (endian-blob->uint4 (uint4->endian-blob 40000 MSB)))

            (test (sprintf "ieee_float32 <-> endian-blob (MSB)")
		  30.0
		  (endian-blob->ieee_float32 (ieee_float32->endian-blob 30.0 MSB)))

            (test (sprintf "ieee_float64 <-> endian-blob (MSB)")
		  13.31
		  (endian-blob->ieee_float64 (ieee_float64->endian-blob 13.31 MSB)))

            (test (sprintf "s8vector <-> endian-blob (MSB)")
                  (s8vector 1 -2 3 -4)
		  (endian-blob->s8vector (s8vector->endian-blob (s8vector 1 -2 3 -4) MSB)))

            (test (sprintf "s16vector <-> endian-blob (MSB)")
                  (s16vector 100 -200 300 -400)
		  (endian-blob->s16vector (s16vector->endian-blob (s16vector 100 -200 300 -400) MSB)))

            (test (sprintf "s32vector <-> endian-blob (MSB)")
                  (s32vector 100000 -200000 300000 -400000)
		  (endian-blob->s32vector (s32vector->endian-blob (s32vector 100000 -200000 300000 -400000) MSB)))

            (test (sprintf "u8vector <-> endian-blob (MSB)")
                  (u8vector 1 2 3 4)
		  (endian-blob->u8vector (u8vector->endian-blob (u8vector 1 2 3 4) MSB)))

            (test (sprintf "u16vector <-> endian-blob (MSB)")
                  (u16vector 100 200 300 400)
		  (endian-blob->u16vector (u16vector->endian-blob (u16vector 100 200 300 400) MSB)))

            (test (sprintf "s32vector <-> endian-blob (MSB)")
                  (u32vector 100000 200000 300000 400000)
		  (endian-blob->u32vector (u32vector->endian-blob (u32vector 100000 200000 300000 400000) MSB)))

            (test (sprintf "f32vector <-> endian-blob (MSB)")
                  (f32vector 100.0 200.1 300.2 400.3)
		  (endian-blob->f32vector (f32vector->endian-blob (f32vector  100.0 200.1 300.2 400.3) MSB)))

            (test (sprintf "f64vector <-> endian-blob (MSB)")
                  (f64vector 10.01 21.12 32.23 43.34)
		  (endian-blob->f64vector (f64vector->endian-blob (f64vector 10.01 21.12 32.23 43.34) MSB)))


            (test (sprintf "sint1 <-> endian-blob (LSB)")
		  -40
		  (endian-blob->sint1 (sint1->endian-blob -40 LSB)))

            (test (sprintf "sint2 <-> endian-blob (LSB)")
		  -4000
		  (endian-blob->sint2 (sint2->endian-blob -4000 LSB)))

            (test (sprintf "sint4 <-> endian-blob (LSB)")
		  -40000
		  (endian-blob->sint4 (sint4->endian-blob -40000 LSB)))

            (test (sprintf "uint4 <-> endian-blob (LSB)")
		  40000
		  (endian-blob->uint4 (uint4->endian-blob 40000 LSB)))

            (test (sprintf "ieee_float32 <-> endian-blob (LSB)")
		  30.0
		  (endian-blob->ieee_float32 (ieee_float32->endian-blob 30.0 LSB)))

            (test (sprintf "ieee_float64 <-> endian-blob (LSB)")
		  13.31
		  (endian-blob->ieee_float64 (ieee_float64->endian-blob 13.31 LSB)))

            (test (sprintf "s8vector <-> endian-blob (LSB)")
                  (s8vector 1 -2 3 -4)
		  (endian-blob->s8vector (s8vector->endian-blob (s8vector 1 -2 3 -4) LSB)))

            (test (sprintf "s16vector <-> endian-blob (LSB)")
                  (s16vector 100 -200 300 -400)
		  (endian-blob->s16vector (s16vector->endian-blob (s16vector 100 -200 300 -400) LSB)))

            (test (sprintf "s32vector <-> endian-blob (LSB)")
                  (s32vector 100000 -200000 300000 -400000)
		  (endian-blob->s32vector (s32vector->endian-blob (s32vector 100000 -200000 300000 -400000) LSB)))

            (test (sprintf "u8vector <-> endian-blob (LSB)")
                  (u8vector 1 2 3 4)
		  (endian-blob->u8vector (u8vector->endian-blob (u8vector 1 2 3 4) LSB)))

            (test (sprintf "u16vector <-> endian-blob (LSB)")
                  (u16vector 100 200 300 400)
		  (endian-blob->u16vector (u16vector->endian-blob (u16vector 100 200 300 400) LSB)))

            (test (sprintf "s32vector <-> endian-blob (LSB)")
                  (u32vector 100000 200000 300000 400000)
		  (endian-blob->u32vector (u32vector->endian-blob (u32vector 100000 200000 300000 400000) LSB)))

            (test (sprintf "f32vector <-> endian-blob (LSB)")
                  (f32vector 100.0 200.1 300.2 400.3)
		  (endian-blob->f32vector (f32vector->endian-blob (f32vector  100.0 200.1 300.2 400.3) LSB)))

            (test (sprintf "f64vector <-> endian-blob (LSB)")
                  (f64vector 10.01 21.12 32.23 43.34)
		  (endian-blob->f64vector (f64vector->endian-blob (f64vector 10.01 21.12 32.23 43.34) LSB)))

	    
)
