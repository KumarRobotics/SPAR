; test recharge action

(define (problem test-recharge)
  (:domain uav_passenger_transport)

  (:objects
    u1 - uav
    locA - location
  )

  (:init
    (at-uav u1 locA)
    (is-charging-station locA)
    (= (battery-level u1) 2)
    (= (max-battery u1) 10)
  )

  (:goal
    (= (battery-level u1) 10)
  )
)
