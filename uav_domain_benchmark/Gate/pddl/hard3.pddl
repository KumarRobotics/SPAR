; 3 uav pass same gate

(define (problem hard-extreme-multi-adjust)
  (:domain Gate)

  (:objects
    u1 u2 u3 - uav
  )

  (:init

    (= (cur_angel u1) 0)
    (= (cur_angel u2) 45)
    (= (cur_angel u3) 90)

    (= (control_rate u1) 10)
    (= (control_rate u2) 5)
    (= (control_rate u3) 15)

    (= (gate_angle) 30)
  )

  (:goal
    (and
      (pass u1)
      (pass u2)
      (pass u3)
    )
  )
)
