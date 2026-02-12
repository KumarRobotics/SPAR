; test decrease angle
(define (problem test-decrease-angle)
  (:domain Gate)

  (:objects
    u1 - uav
  )

  (:init
    (= (cur_angel u1) 20)
    (= (control_rate u1) 5)
    (= (gate_angle) 10)
  )

  (:goal
    (= (cur_angel u1) 15)
  )
)
