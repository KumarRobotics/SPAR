(define (problem detect-clear-simple)
  (:domain MovableObs)
  (:objects u1 - uav p1 - position)
  (:init
    (at-uav u1 p1)
    (clear p1)
  )
  (:goal (is-clear p1))
)
