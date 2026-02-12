(define (problem medium-decrease-then-pass)
  (:domain Gate)

  (:objects
    u1 - uav
  )

  (:init
    (= (cur_angel u1) 25)
    (= (control_rate u1) 3)
    (= (gate_angle) 19)
  )

  (:goal
    (pass u1)
  )
)
