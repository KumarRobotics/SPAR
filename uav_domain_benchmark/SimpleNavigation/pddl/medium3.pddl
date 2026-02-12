
(define (problem nav-prob-4)
  (:domain SimpleNavigationDomain)
  (:objects u1 - uav a b1 b2 g - location)
  (:init
    (at-location u1 a)
    (at-next a b1)
    (at-next a b2)
    (at-next b1 g)
    (is-goal g)
  )
  (:goal (reach-goal u1))
)