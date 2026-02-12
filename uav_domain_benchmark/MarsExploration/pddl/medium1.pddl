; test move + explore
(define (problem mars-prob-5)
  (:domain MarsExplorationDomain)
  (:objects u1 - uav l1 l2 - location)
  (:init 
    (at-uav u1 l1)
    (resource l2)
  )
  (:goal 
    (explored l2)
  )
)
