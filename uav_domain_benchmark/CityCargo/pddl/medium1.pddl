; truck-load  truck-drive  truck-unload

(define (problem medium-truck-move-package)
  (:domain CityCargo)

  (:objects
    t1 - truck
    p1 - package
    l1 l2 - location
    c1 - city
  )

  (:init
    (package-at p1 l1)
    (truck-at t1 l1)
    (location-in-city l1 c1)
    (location-in-city l2 c1)
  )

  (:goal
    (package-at p1 l2)
  )
)
