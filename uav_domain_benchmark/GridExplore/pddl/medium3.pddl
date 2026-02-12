; 4x4 grid with obstacles
(define (problem GridExploreDetourToGoal)
  (:domain GridExplore)

  (:objects 
    uav1 - uav
    p11 p12 p13 p14
    p21 p22 p23 p24
    p31 p32 p33 p34
    p41 p42 p43 p44 - position
  )

  (:init
    (= (cost) 0)
    (at uav1 p11)

    ;; connectivity
    (connect p11 p12) (connect p11 p21)
    (connect p12 p11) (connect p12 p13) (connect p12 p22)
    (connect p13 p12) (connect p13 p14) (connect p13 p23)
    (connect p14 p13) (connect p14 p24)

    (connect p21 p11) (connect p21 p22) (connect p21 p31)
    (connect p22 p12) (connect p22 p21) (connect p22 p23) (connect p22 p32)
    (connect p23 p13) (connect p23 p22) (connect p23 p24) (connect p23 p33)
    (connect p24 p14) (connect p24 p23) (connect p24 p34)

    (connect p31 p21) (connect p31 p32) (connect p31 p41)
    (connect p32 p22) (connect p32 p31) (connect p32 p33) (connect p32 p42)
    (connect p33 p23) (connect p33 p32) (connect p33 p34) (connect p33 p43)
    (connect p34 p24) (connect p34 p33) (connect p34 p44)

    (connect p41 p31) (connect p41 p42)
    (connect p42 p41) (connect p42 p32) (connect p42 p43)
    (connect p43 p42) (connect p43 p33) (connect p43 p44)
    (connect p44 p43) (connect p44 p34)

    ;; hard obstacles
    (obs p12)
    (obs p22)
    (obs p32)


  )

  (:goal
    (and
      (at uav1 p44)
    )
  )

  (:metric minimize (cost))
)
