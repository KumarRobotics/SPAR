; uav-load  uav-fly  uav-unload
(define (problem medium-uav-transfer)
  (:domain CityCargo)

  (:objects
    u1 - uav
    p1 - package
    a1 a2 - location
    c1 c2 - city
  )

  (:init
    (package-at p1 a1)
    (uav-at u1 a1)
    (location-in-city a1 c1)
    (location-in-city a2 c2)
    (location-is-airport a1)
    (location-is-airport a2)
  )

  (:goal
    (package-at p1 a2)
  )
)
