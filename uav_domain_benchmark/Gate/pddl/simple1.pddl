; test increase angle
(define (problem test-increase-angle)
  (:domain Gate)

  (:objects
    u1 - uav
  )

  (:init
    (= (cur_angel u1) 10)
    (= (control_rate u1) 2)
    (= (gate_angle) 15)
  )

  (:goal
    (= (cur_angel u1) 12)
  )
)
