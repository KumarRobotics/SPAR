; two cities with two packages

(define (problem hard-city-dispatch)
  (:domain CityCargo)

  (:objects
    ;; vehicles
    u1 u2 - uav
    t1 t2 - truck

    ;; packages
    p1 p2 - package

    ;; locations
    l1 l2 a1 - location  ; city1
    l3 l4 a2 - location  ; city2

    ;; cities
    c1 c2 - city
  )

  (:init
    ;; vehicle locations
    (truck-at t1 l1)
    (truck-at t2 l3)
    (uav-at u1 a1)
    (uav-at u2 a2)

    ;; package locations
    (package-at p1 l2)
    (package-at p2 l4)

    ;; location-city map
    (location-in-city l1 c1)
    (location-in-city l2 c1)
    (location-in-city a1 c1)

    (location-in-city l3 c2)
    (location-in-city l4 c2)
    (location-in-city a2 c2)

    ;; airport tags
    (location-is-airport a1)
    (location-is-airport a2)
  )

  (:goal
    (and
      (package-at p1 l4)
      (package-at p2 l2)
    )
  )
)
