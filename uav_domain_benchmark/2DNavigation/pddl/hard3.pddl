; map with tree structure

(define (problem nav-problem-9)
  (:domain NavDomain)
  (:objects
    root a1 a2 a3 b1 b2 b3 c1 c2 c3 goal - position
    uav1 - uav
  )
  (:init
    (at uav1 root)
    ;; tree level 1
    (connect root a1)
    (connect root a2)
    (connect root a3)
    ;; tree level 2
    (connect a1 b1)
    (connect a2 b2)
    (connect a3 b3)
    ;; level 3
    (connect b1 c1)
    (connect b2 c2)
    (connect b3 c3)
    ;; only c3 connects to goal
    (connect c3 goal)

    (goal goal)
    (= (cost) 0)
  )
  (:goal
    (finish)
  )
    (:metric minimize (cost))
)
