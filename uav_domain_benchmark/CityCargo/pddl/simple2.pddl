; test uav load

(define (problem test-uav-load)
  (:domain CityCargo)

  (:objects
    u1 - uav
    p1 - package
    l1 - location
    c1 - city
  )

  (:init
    (package-at p1 l1)
    (uav-at u1 l1)
    (location-in-city l1 c1)
    (location-is-airport l1)
  )

  (:goal
    (package-in-uav p1 u1)
  )
)
