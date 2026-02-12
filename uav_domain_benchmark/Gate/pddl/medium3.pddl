(define (problem medium-overadjust-then-correct)
  (:domain Gate)

  (:objects
    u1 - uav
  )

  (:init
    (= (cur_angel u1) 3)
    (= (control_rate u1) 7)
    (= (gate_angle) 38)
  )

  (:goal
    (pass u1)
  )
)
