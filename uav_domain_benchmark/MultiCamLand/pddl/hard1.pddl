; on a big map

(define (problem MulticamProb) (:domain Multicam)
    (:objects 
        uav - uav
        p11 p12 p13 p14 p15 p16 
        p21 p22 p23 p24 p25 p26 
        p31 p32 p33 p34 p35 p36 
        p41 p42 p43 p44 p45 p46 
        p51 p52 p53 p54 p55 p56 
        p61 p62 p63 p64 p65 p66 - position
    )

    (:init
        ; Initial position of the UAV
        (at uav p11)

        ; Define movement constraints

        ; UP relations (moving downward in the grid)
        (up p11 p21) (up p12 p22) (up p13 p23) (up p14 p24) (up p15 p25) (up p16 p26)
        (up p21 p31) (up p22 p32) (up p23 p33) (up p24 p34) (up p25 p35) (up p26 p36)
        (up p31 p41) (up p32 p42) (up p33 p43) (up p34 p44) (up p35 p45) (up p36 p46)
        (up p41 p51) (up p42 p52) (up p43 p53) (up p44 p54) (up p45 p55) (up p46 p56)
        (up p51 p61) (up p52 p62) (up p53 p63) (up p54 p64) (up p55 p65) (up p56 p66)

        ; DOWN relations (moving upward in the grid)
        (down p21 p11) (down p22 p12) (down p23 p13) (down p24 p14) (down p25 p15) (down p26 p16)
        (down p31 p21) (down p32 p22) (down p33 p23) (down p34 p24) (down p35 p25) (down p36 p26)
        (down p41 p31) (down p42 p32) (down p43 p33) (down p44 p34) (down p45 p35) (down p46 p36)
        (down p51 p41) (down p52 p42) (down p53 p43) (down p54 p44) (down p55 p45) (down p56 p46)
        (down p61 p51) (down p62 p52) (down p63 p53) (down p64 p54) (down p65 p55) (down p66 p56)

        ; LEFT relations (moving rightward in the grid)
        (left p11 p12) (left p12 p13) (left p13 p14) (left p14 p15) (left p15 p16)
        (left p21 p22) (left p22 p23) (left p23 p24) (left p24 p25) (left p25 p26)
        (left p31 p32) (left p32 p33) (left p33 p34) (left p34 p35) (left p35 p36)
        (left p41 p42) (left p42 p43) (left p43 p44) (left p44 p45) (left p45 p46)
        (left p51 p52) (left p52 p53) (left p53 p54) (left p54 p55) (left p55 p56)
        (left p61 p62) (left p62 p63) (left p63 p64) (left p64 p65) (left p65 p66)

        ; RIGHT relations (moving leftward in the grid)
        (right p12 p11) (right p13 p12) (right p14 p13) (right p15 p14) (right p16 p15)
        (right p22 p21) (right p23 p22) (right p24 p23) (right p25 p24) (right p26 p25)
        (right p32 p31) (right p33 p32) (right p34 p33) (right p35 p34) (right p36 p35)
        (right p42 p41) (right p43 p42) (right p44 p43) (right p45 p44) (right p46 p45)
        (right p52 p51) (right p53 p52) (right p54 p53) (right p55 p54) (right p56 p55)
        (right p62 p61) (right p63 p62) (right p64 p63) (right p65 p64) (right p66 p65)

        (obs p25)
        (obs p32)
        (obs p41)(obs p42)(obs p43)(obs p44)
        (obs p52)(obs p54)
        (obs p62)
        
        (see-right uav)
    )

(:goal (and
    ;todo: put the goal condition here
    (at uav p63)
))

;un-comment the following line if metric is needed
(:metric minimize (cost))
)
