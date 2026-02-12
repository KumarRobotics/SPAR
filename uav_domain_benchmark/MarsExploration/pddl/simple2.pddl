; test explore
(define (problem mars-prob-3)
  (:domain MarsExplorationDomain)
  (:objects u1 - uav l1 - location)
  (:init 
    (at-uav u1 l1)
    (resource l1)
  )
  (:goal 
    (explored l1)
  )
)
