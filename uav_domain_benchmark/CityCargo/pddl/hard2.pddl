; 3 cities with 3 packages
(define (problem hard-triple-city-transfer)
  (:domain CityCargo)

  (:objects
    u1 u2 - uav
    t1 t2 t3 - truck
    p1 p2 p3 - package

    la1 la2 la3 - location  ; airports
    lx1 lx2 lx3 - location  ; local locations

    c1 c2 c3 - city
  )

  (:init
    ;; vehicles
    (truck-at t1 lx1)
    (truck-at t2 lx2)
    (truck-at t3 lx3)

    (uav-at u1 la1)
    (uav-at u2 la2)

    ;; packages
    (package-at p1 lx1)
    (package-at p2 lx2)
    (package-at p3 lx3)

    ;; cities
    (location-in-city lx1 c1)
    (location-in-city la1 c1)

    (location-in-city lx2 c2)
    (location-in-city la2 c2)

    (location-in-city lx3 c3)
    (location-in-city la3 c3)

    ;; airports
    (location-is-airport la1)
    (location-is-airport la2)
    (location-is-airport la3)
  )

  (:goal
    (and
      (package-at p1 la2)
      (package-at p2 la3)
      (package-at p3 la1)

    )
  )
)
