(define (problem nav-prob-1)
  (:domain SimpleNavigationDomain)
  (:objects u1 - uav l1 l2 - location)
  (:init
    (at-location u1 l1)
    (is-goal l1)
  )
  (:goal (reach-goal u1))
)