(set-logic LIA)

( declare-primed-var c Int )
( declare-primed-var conf_0 Int )
( declare-primed-var conf_1 Int )
( declare-primed-var conf_2 Int )
( declare-primed-var conf_3 Int )
( declare-primed-var conf_4 Int )
( declare-primed-var y Int )
( declare-primed-var z Int )
( declare-primed-var tmp Int )

( declare-primed-var c_0 Int )
( declare-primed-var c_1 Int )
( declare-primed-var c_2 Int )
( declare-primed-var c_3 Int )
( declare-primed-var c_4 Int )
( declare-primed-var conf_0_0 Int )
( declare-primed-var conf_1_0 Int )
( declare-primed-var conf_1_1 Int )
( declare-primed-var conf_1_2 Int )
( declare-primed-var conf_1_3 Int )
( declare-primed-var conf_2_0 Int )
( declare-primed-var conf_3_0 Int )
( declare-primed-var conf_3_1 Int )
( declare-primed-var conf_3_2 Int )
( declare-primed-var conf_3_3 Int )
( declare-primed-var conf_4_0 Int )
( declare-primed-var y_0 Int )
( declare-primed-var z_0 Int )
( declare-primed-var z_1 Int )
( declare-primed-var z_2 Int )
( declare-primed-var z_3 Int )
( declare-primed-var z_4 Int )

( synth-inv inv-f( ( c Int )( conf_0 Int )( conf_1 Int )( conf_2 Int )( conf_3 Int )( conf_4 Int )( y Int )( z Int )( tmp Int )( c_0 Int )( c_1 Int )( c_2 Int )( c_3 Int )( c_4 Int )( conf_0_0 Int )( conf_1_0 Int )( conf_1_1 Int )( conf_1_2 Int )( conf_1_3 Int )( conf_2_0 Int )( conf_3_0 Int )( conf_3_1 Int )( conf_3_2 Int )( conf_3_3 Int )( conf_4_0 Int )( y_0 Int )( z_0 Int )( z_1 Int )( z_2 Int )( z_3 Int )( z_4 Int ) ) )

( define-fun pre-f ( ( c Int )( conf_0 Int )( conf_1 Int )( conf_2 Int )( conf_3 Int )( conf_4 Int )( y Int )( z Int )( tmp Int )( c_0 Int )( c_1 Int )( c_2 Int )( c_3 Int )( c_4 Int )( conf_0_0 Int )( conf_1_0 Int )( conf_1_1 Int )( conf_1_2 Int )( conf_1_3 Int )( conf_2_0 Int )( conf_3_0 Int )( conf_3_1 Int )( conf_3_2 Int )( conf_3_3 Int )( conf_4_0 Int )( y_0 Int )( z_0 Int )( z_1 Int )( z_2 Int )( z_3 Int )( z_4 Int ) ) Bool
	( and
		( = c c_1 )
		( = conf_0 conf_0_0 )
		( = conf_1 conf_1_0 )
		( = conf_2 conf_2_0 )
		( = conf_3 conf_3_0 )
		( = conf_4 conf_4_0 )
		( = y y_0 )
		( = z z_1 )
		( = conf_0_0 4 )
		( = conf_1_0 7 )
		( = conf_2_0 6 )
		( = conf_3_0 5 )
		( = conf_4_0 3 )
		( = c_1 0 )
		( >= y_0 0 )
		( >= y_0 127 )
		( = z_1 ( * 36 y_0 ) )
	)
)

( define-fun trans-f ( ( c Int )( conf_0 Int )( conf_1 Int )( conf_2 Int )( conf_3 Int )( conf_4 Int )( y Int )( z Int )( tmp Int )( c_0 Int )( c_1 Int )( c_2 Int )( c_3 Int )( c_4 Int )( conf_0_0 Int )( conf_1_0 Int )( conf_1_1 Int )( conf_1_2 Int )( conf_1_3 Int )( conf_2_0 Int )( conf_3_0 Int )( conf_3_1 Int )( conf_3_2 Int )( conf_3_3 Int )( conf_4_0 Int )( y_0 Int )( z_0 Int )( z_1 Int )( z_2 Int )( z_3 Int )( z_4 Int )( c! Int )( conf_0! Int )( conf_1! Int )( conf_2! Int )( conf_3! Int )( conf_4! Int )( y! Int )( z! Int )( tmp! Int )( c_0! Int )( c_1! Int )( c_2! Int )( c_3! Int )( c_4! Int )( conf_0_0! Int )( conf_1_0! Int )( conf_1_1! Int )( conf_1_2! Int )( conf_1_3! Int )( conf_2_0! Int )( conf_3_0! Int )( conf_3_1! Int )( conf_3_2! Int )( conf_3_3! Int )( conf_4_0! Int )( y_0! Int )( z_0! Int )( z_1! Int )( z_2! Int )( z_3! Int )( z_4! Int ) ) Bool
	( or
		( and
			( = c_2 c )
			( = conf_1_1 conf_1 )
			( = conf_3_1 conf_3 )
			( = z_2 z )
			( = c_2 c! )
			( = conf_1_1 conf_1! )
			( = conf_3_1 conf_3! )
			( = z_2 z! )
			( = c c! )
			( = conf_0 conf_0! )
			( = conf_1 conf_1! )
			( = conf_2 conf_2! )
			( = conf_3 conf_3! )
			( = conf_4 conf_4! )
			( = y y! )
			( = z z! )
			(= tmp tmp! )
		)
		( and
			( = c_2 c )
			( = conf_1_1 conf_1 )
			( = conf_3_1 conf_3 )
			( = z_2 z )
			( < c_2 36 )
			( = z_3 ( + z_2 1 ) )
			( = conf_1_2 ( + conf_0_0 512 ) )
			( = c_3 ( + c_2 1 ) )
			( = conf_3_2 ( - conf_3_1 conf_2_0 ) )
			( = c_4 c_3 )
			( = conf_1_3 conf_1_2 )
			( = conf_3_3 conf_3_2 )
			( = z_4 z_3 )
			( = c_4 c! )
			( = conf_1_3 conf_1! )
			( = conf_3_3 conf_3! )
			( = z_4 z! )
			(= conf_0 conf_0_0 )
			(= conf_0! conf_0_0 )
			(= conf_2 conf_2_0 )
			(= conf_2! conf_2_0 )
			(= conf_4 conf_4_0 )
			(= conf_4! conf_4_0 )
			(= y y_0 )
			(= y! y_0 )
			(= tmp tmp! )
		)
		( and
			( = c_2 c )
			( = conf_1_1 conf_1 )
			( = conf_3_1 conf_3 )
			( = z_2 z )
			( not ( < c_2 36 ) )
			( = c_4 c_2 )
			( = conf_1_3 conf_1_1 )
			( = conf_3_3 conf_3_1 )
			( = z_4 z_2 )
			( = c_4 c! )
			( = conf_1_3 conf_1! )
			( = conf_3_3 conf_3! )
			( = z_4 z! )
			(= conf_0 conf_0_0 )
			(= conf_0! conf_0_0 )
			(= conf_2 conf_2_0 )
			(= conf_2! conf_2_0 )
			(= conf_4 conf_4_0 )
			(= conf_4! conf_4_0 )
			(= y y_0 )
			(= y! y_0 )
			(= tmp tmp! )
		)
	)
)

( define-fun post-f ( ( c Int )( conf_0 Int )( conf_1 Int )( conf_2 Int )( conf_3 Int )( conf_4 Int )( y Int )( z Int )( tmp Int )( c_0 Int )( c_1 Int )( c_2 Int )( c_3 Int )( c_4 Int )( conf_0_0 Int )( conf_1_0 Int )( conf_1_1 Int )( conf_1_2 Int )( conf_1_3 Int )( conf_2_0 Int )( conf_3_0 Int )( conf_3_1 Int )( conf_3_2 Int )( conf_3_3 Int )( conf_4_0 Int )( y_0 Int )( z_0 Int )( z_1 Int )( z_2 Int )( z_3 Int )( z_4 Int ) ) Bool
	( or
		( not
			( and
				( = c c_2)
				( = conf_0 conf_0_0)
				( = conf_1 conf_1_1)
				( = conf_2 conf_2_0)
				( = conf_3 conf_3_1)
				( = conf_4 conf_4_0)
				( = y y_0)
				( = z z_2)
			)
		)
		( not
			( and
				( < z_2 0 )
				( >= z_2 4608 )
				( not ( >= c_2 36 ) )
			)
		)
	)
)

( inv-constraint inv-f pre-f trans-f post-f )
( check-synth )
