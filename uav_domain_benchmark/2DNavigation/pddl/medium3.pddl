; single uav on medium map with branching paths, ensuring correct navigation to the goal

(define (problem nav-problem-3)
  (:domain NavDomain)
  (:objects
    uav1 - uav
    a b c d e f g h - position
  )
  (:init
    (at uav1 a)
    (connect a b)
    (connect a c)
    (connect b d)
    (connect c e)
    (connect d f)
    (connect e f)
    (connect f g)
    (connect g h)
    (goal h)
    (= (cost) 0)
  )
  (:goal
    (finish)
  )
)
