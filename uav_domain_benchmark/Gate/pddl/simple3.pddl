(define (problem test-pass-gate)
  (:domain Gate)

  (:objects
    u1 - uav
  )

  (:init
    (= (cur_angel u1) 30)
    (= (control_rate u1) 2)
    (= (gate_angle) 30)
  )

  (:goal
    (pass u1)
  )
)
