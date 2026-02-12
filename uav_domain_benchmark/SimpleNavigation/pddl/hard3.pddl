(define (problem nav-prob-6)
  (:domain SimpleNavigationDomain)
  (:objects u1 - uav s a b c d g - location)
  (:init
    (at-location u1 s)
    (at-next s a)
    (at-next a b)
    (at-next b g)
    (at-next a c)
    (at-next c d) ;; dead-end
    (is-goal g)
  )
  (:goal (reach-goal u1))
)