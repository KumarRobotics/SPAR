; 3 uav pass same gate
(define (problem hard-three-uav-diff-gates)
  (:domain Gate)

  (:objects
    u1 u2 u3 - uav
  )

  (:init
    (= (cur_angel u1) 10)
    (= (cur_angel u2) 25)
    (= (cur_angel u3) 5)


    (= (control_rate u1) 5)
    (= (control_rate u2) 2.5)
    (= (control_rate u3) 2)

    (= (gate_angle) 15)
  )

  (:goal
    (and
      (pass u1)
      (pass u2)
      (pass u3)
    )
  )
)
