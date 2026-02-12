; test board action
(define (problem test-board)
  (:domain uav_passenger_transport)

  (:objects
    u1 - uav
    p1 - passenger
    locA - location
  )

  (:init
    (at-uav u1 locA)
    (at-passenger p1 locA)
    (= (weight p1) 3)
    (= (remaining-load u1) 5)
  )

  (:goal
    (and
      (in-uav p1 u1)
      (= (remaining-load u1) 2)
    )
  )
)
