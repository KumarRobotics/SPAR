; two uav pass 1 gate
(define (problem hard-two-uav-two-gates)
  (:domain Gate)

  (:objects
    u1 u2 - uav
  )

  (:init
    (= (cur_angel u1) 10)
    (= (cur_angel u2) 30)
    (= (control_rate u1) 5)
    (= (control_rate u2) 2)
    (= (gate_angle) 20) ; shared gate for both
  )

  (:goal
    (and
      (pass u1)
      (pass u2)
    )
  )
)
