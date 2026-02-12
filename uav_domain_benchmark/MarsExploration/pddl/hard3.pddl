(define (problem mars-prob-10)
  (:domain MarsExplorationDomain)
  (:objects 
    u1 u2 - uav
    r1 r2 - rover
    l1 l2 l3 l4 l5 - location
  )

  (:init 
    ;; agent positions
    (at-uav u1 l1)
    (at-uav u2 l1)
    (at-rov r1 l1)
    (at-rov r2 l1)

    ;; resource locations
    (resource l2)
    (resource l3)
    (resource l4)

    ;; location values
    (= (value l2) 5)
    (= (value l3) 7)
    (= (value l4) 8)
    (= (total-resource) 0)
  )

  (:goal 
    (and
      (resource-collected l2)
      (resource-collected l3)
      (resource-collected l4)
    )
  )
   (:metric maximize (total-resource))
)
