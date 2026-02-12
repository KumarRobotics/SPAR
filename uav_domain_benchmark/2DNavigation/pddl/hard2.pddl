; big map with multiple paths and a big loop

(define (problem nav-problem-8)
  (:domain NavDomain)
  (:objects
    a b c d e f g h i j k l m n - position
    uav1 - uav
  )
  (:init
    (at uav1 a)
    ;; main loop
    (connect a b)
    (connect b c)
    (connect c d)
    (connect d e)
    (connect e f)
    (connect f g)
    (connect g h)
    (connect h a) ; closes the loop
    ;; spurs
    (connect c i)
    (connect i j)
    (connect j k)
    (connect f l)
    (connect l m)
    (connect m n)
    ;; goal
    (goal n)
    (= (cost) 0)
  )
  (:goal
    (finish)

  )

    (:metric minimize (cost))
)
