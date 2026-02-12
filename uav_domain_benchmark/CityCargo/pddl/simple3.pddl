; test trcuk drive
(define (problem test-truck-drive)
  (:domain CityCargo)

  (:objects
    t1 - truck
    l1 l2 - location
    c1 - city
  )

  (:init
    (truck-at t1 l1)
    (location-in-city l1 c1)
    (location-in-city l2 c1)
  )

  (:goal
    (truck-at t1 l2)
  )
)
