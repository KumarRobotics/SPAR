; complete action chains
(define (problem medium-truck-to-uav-transfer)
  (:domain CityCargo)

  (:objects
    t1 - truck
    u1 - uav
    p1 - package
    l1 a1 a2 - location
    c1 c2 - city
  )

  (:init
    
    (package-at p1 l1)
    (truck-at t1 a1)
    (uav-at u1 a1)


    (location-in-city l1 c1)
    (location-in-city a1 c1)
    (location-in-city a2 c2)
    (location-is-airport a1)
    (location-is-airport a2)
  )

  (:goal
    (package-at p1 a2)
  )
)
