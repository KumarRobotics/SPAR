; one uav two packages

(define (problem hard-capacity-sequencing)
  (:domain DeliveryCapacityDomain)

  (:objects
    u1 - uav
    p1 p2 - package
    la lb lc - location
  )

  (:init
    (at-uav u1 la)
    (at-package p1 la)
    (at-package p2 la)

    (= (weights p1) 2)
    (= (weights p2) 5)
    (= (remaining-load) 5)

    (= (distance la lb) 2)
    (= (distance lb la) 2)
    (= (distance la lc) 4)

    (= (total-distance) 0)
  )

  (:goal
    (and
      (at-package p1 lb)
      (at-package p2 lc)
    )
  )

    (:metric minimize (total-distance))
)
