(define (problem medium-increase-then-pass)
  (:domain Gate)

  (:objects
    u1 - uav
  )

  (:init
    (= (cur_angel u1) 10)
    (= (control_rate u1) 5)
    (= (gate_angle) 20)
  )

  (:goal
    (pass u1)
  )
)
