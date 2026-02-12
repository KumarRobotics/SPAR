; test Move-uav - Explore - Move-rov - GetResource
(define (problem mars-prob-6)
  (:domain MarsExplorationDomain)
  (:objects u1 - uav r1 - rover l1 l2 - location)
  (:init 
    (at-uav u1 l1)
    (at-rov r1 l1)
    (resource l2)
    (= (value l2) 10)
    (= (total-resource) 0)
  )
  (:goal 
    (resource-collected l2)
  )
   (:metric maximize (total-resource))
)
