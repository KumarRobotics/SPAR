; 2 uavs 8x8 grid with obstacles
(define (problem GridExploreHard-1)
  (:domain GridExplore)

  (:objects 
    uav1 uav2 uav3 - uav
    p11 p12 p13 p14 p15 p16 p17 p18
    p21 p22 p23 p24 p25 p26 p27 p28
    p31 p32 p33 p34 p35 p36 p37 p38
    p41 p42 p43 p44 p45 p46 p47 p48
    p51 p52 p53 p54 p55 p56 p57 p58
    p61 p62 p63 p64 p65 p66 p67 p68
    p71 p72 p73 p74 p75 p76 p77 p78
    p81 p82 p83 p84 p85 p86 p87 p88 - position
  )

  (:init
    (= (cost) 0)
    (at uav1 p11)
    (at uav2 p18)
    (at uav3 p81)

    ;; 8x8 grid connectivity (4-neighbor, bidirectional)
;; Row-wise and column-wise connections

;; horizontal connections
(connect p11 p12) (connect p12 p11)
(connect p12 p13) (connect p13 p12)
(connect p13 p14) (connect p14 p13)
(connect p14 p15) (connect p15 p14)
(connect p15 p16) (connect p16 p15)
(connect p16 p17) (connect p17 p16)
(connect p17 p18) (connect p18 p17)

(connect p21 p22) (connect p22 p21)
(connect p22 p23) (connect p23 p22)
(connect p23 p24) (connect p24 p23)
(connect p24 p25) (connect p25 p24)
(connect p25 p26) (connect p26 p25)
(connect p26 p27) (connect p27 p26)
(connect p27 p28) (connect p28 p27)

(connect p31 p32) (connect p32 p31)
(connect p32 p33) (connect p33 p32)
(connect p33 p34) (connect p34 p33)
(connect p34 p35) (connect p35 p34)
(connect p35 p36) (connect p36 p35)
(connect p36 p37) (connect p37 p36)
(connect p37 p38) (connect p38 p37)

(connect p41 p42) (connect p42 p41)
(connect p42 p43) (connect p43 p42)
(connect p43 p44) (connect p44 p43)
(connect p44 p45) (connect p45 p44)
(connect p45 p46) (connect p46 p45)
(connect p46 p47) (connect p47 p46)
(connect p47 p48) (connect p48 p47)

(connect p51 p52) (connect p52 p51)
(connect p52 p53) (connect p53 p52)
(connect p53 p54) (connect p54 p53)
(connect p54 p55) (connect p55 p54)
(connect p55 p56) (connect p56 p55)
(connect p56 p57) (connect p57 p56)
(connect p57 p58) (connect p58 p57)

(connect p61 p62) (connect p62 p61)
(connect p62 p63) (connect p63 p62)
(connect p63 p64) (connect p64 p63)
(connect p64 p65) (connect p65 p64)
(connect p65 p66) (connect p66 p65)
(connect p66 p67) (connect p67 p66)
(connect p67 p68) (connect p68 p67)

(connect p71 p72) (connect p72 p71)
(connect p72 p73) (connect p73 p72)
(connect p73 p74) (connect p74 p73)
(connect p74 p75) (connect p75 p74)
(connect p75 p76) (connect p76 p75)
(connect p76 p77) (connect p77 p76)
(connect p77 p78) (connect p78 p77)

(connect p81 p82) (connect p82 p81)
(connect p82 p83) (connect p83 p82)
(connect p83 p84) (connect p84 p83)
(connect p84 p85) (connect p85 p84)
(connect p85 p86) (connect p86 p85)
(connect p86 p87) (connect p87 p86)
(connect p87 p88) (connect p88 p87)

;; vertical connections
(connect p11 p21) (connect p21 p11)
(connect p21 p31) (connect p31 p21)
(connect p31 p41) (connect p41 p31)
(connect p41 p51) (connect p51 p41)
(connect p51 p61) (connect p61 p51)
(connect p61 p71) (connect p71 p61)
(connect p71 p81) (connect p81 p71)

(connect p12 p22) (connect p22 p12)
(connect p22 p32) (connect p32 p22)
(connect p32 p42) (connect p42 p32)
(connect p42 p52) (connect p52 p42)
(connect p52 p62) (connect p62 p52)
(connect p62 p72) (connect p72 p62)
(connect p72 p82) (connect p82 p72)

(connect p13 p23) (connect p23 p13)
(connect p23 p33) (connect p33 p23)
(connect p33 p43) (connect p43 p33)
(connect p43 p53) (connect p53 p43)
(connect p53 p63) (connect p63 p53)
(connect p63 p73) (connect p73 p63)
(connect p73 p83) (connect p83 p73)

(connect p14 p24) (connect p24 p14)
(connect p24 p34) (connect p34 p24)
(connect p34 p44) (connect p44 p34)
(connect p44 p54) (connect p54 p44)
(connect p54 p64) (connect p64 p54)
(connect p64 p74) (connect p74 p64)
(connect p74 p84) (connect p84 p74)

(connect p15 p25) (connect p25 p15)
(connect p25 p35) (connect p35 p25)
(connect p35 p45) (connect p45 p35)
(connect p45 p55) (connect p55 p45)
(connect p55 p65) (connect p65 p55)
(connect p65 p75) (connect p75 p65)
(connect p75 p85) (connect p85 p75)

(connect p16 p26) (connect p26 p16)
(connect p26 p36) (connect p36 p26)
(connect p36 p46) (connect p46 p36)
(connect p46 p56) (connect p56 p46)
(connect p56 p66) (connect p66 p56)
(connect p66 p76) (connect p76 p66)
(connect p76 p86) (connect p86 p76)

(connect p17 p27) (connect p27 p17)
(connect p27 p37) (connect p37 p27)
(connect p37 p47) (connect p47 p37)
(connect p47 p57) (connect p57 p47)
(connect p57 p67) (connect p67 p57)
(connect p67 p77) (connect p77 p67)
(connect p77 p87) (connect p87 p77)

(connect p18 p28) (connect p28 p18)
(connect p28 p38) (connect p38 p28)
(connect p38 p48) (connect p48 p38)
(connect p48 p58) (connect p58 p48)
(connect p58 p68) (connect p68 p58)
(connect p68 p78) (connect p78 p68)
(connect p78 p88) (connect p88 p78)


    ;; hard obstacles
    (obs p15)
    (obs p16)
    (obs p25)
    (obs p26)
    (obs p35)
    (obs p73)
    (obs p74)
    (obs p75)
    (obs p84)
    (obs p87)
    (obs p36)

    (obs p44)
    (obs p46)
    (obs p47)
    (obs p53)
    (obs p55)


  )

  (:goal (and
    (at uav1 p88)
    (at uav2 p61)
    (at uav3 p14)
  ))

  (:metric minimize (cost))
)
