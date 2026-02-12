; test trcuk load

(define (problem test-truck-load)
  (:domain CityCargo)

  (:objects
    t1 - truck
    p1 - package
    l1 - location
    c1 - city
  )

  (:init
    (package-at p1 l1)
    (truck-at t1 l1)
    (location-in-city l1 c1)
  )

  (:goal
    (package-in-truck p1 t1)
  )
)
