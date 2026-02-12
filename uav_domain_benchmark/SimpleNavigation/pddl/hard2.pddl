;;  Looping map
(define (problem nav-prob-7)
  (:domain SimpleNavigationDomain)
  (:objects u1 - uav a b c d g - location)
  (:init
    (at-location u1 a)
    (at-next a b)
    (at-next b c)
    (at-next c d)
    (at-next d b) ;; loop back
    (at-next d g)
    (is-goal g)
  )
  (:goal (reach-goal u1))
)