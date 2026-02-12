(define (problem detect-fix-simple)
  (:domain MovableObs)
  (:objects u1 - uav p1 - position)
  (:init
    (at-uav u1 p1)
    (fix-obs p1)
  )
  (:goal (is-fix p1))
)
