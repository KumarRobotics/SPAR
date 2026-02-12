; 2 uavs, 2 trucks and 3 packages in two cities

(define (problem hard-multidelivery-with-transit)
  (:domain CityCargo)

  (:objects
    u1 u2 - uav
    t1 t2 - truck
    p1 p2 p3 - package

    la1 la2 - location   ; airports
    l1 l2 l3 - location  ; inner city
    c1 c2 - city
  )

  (:init
    ;; vehicles
    (truck-at t1 l1)
    (truck-at t2 l3)
    (uav-at u1 la1)
    (uav-at u2 la2)

    ;; packages
    (package-at p1 l1)
    (package-at p2 l2)
    (package-at p3 l3)

    ;; locations in cities
    (location-in-city l1 c1)
    (location-in-city l2 c1)
    (location-in-city la1 c1)

    (location-in-city l3 c2)
    (location-in-city la2 c2)

    ;; airports
    (location-is-airport la1)
    (location-is-airport la2)
  )

  (:goal
    (and
      (package-at p1 l2)
      (package-at p2 l3)
      (package-at p3 l1)
    )
  )
)
