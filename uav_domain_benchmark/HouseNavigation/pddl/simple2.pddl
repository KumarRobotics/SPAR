; test reach goal
(define (problem nav-prob-2)
  (:domain uav-navigation)
  (:objects u1 - uav l1 - location)
  (:init
    (at-uav u1 l1)
  )
  (:goal (goal-reached u1 l1))
)
