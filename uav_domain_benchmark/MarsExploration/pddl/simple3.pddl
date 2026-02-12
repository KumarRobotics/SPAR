; test get resource
(define (problem mars-prob-4)
  (:domain MarsExplorationDomain)
  (:objects r1 - rover l1 - location)
  (:init 
    (at-rov r1 l1)
    (explored l1)
    (resource l1)
    (not (resource-collected l1))
    (= (value l1) 5)
    (= (total-resource) 0)
  )
  (:goal 
    (resource-collected l1)
  )
)
