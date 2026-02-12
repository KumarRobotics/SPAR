; big map
(define (problem nav-problem-7)
  (:domain NavDomain)
  (:objects
    a b c d e f g h i j k l m n o p q r s t - position
    uav1 - uav
  )
  (:init
    (at uav1 a)
    ;; maze structure
    (connect a b)
    (connect b c)
    (connect c d)
    (connect d e)
    (connect b f)
    (connect f g)
    (connect g h)
    (connect h i)
    (connect i j)
    (connect f k)
    (connect k l)
    (connect l m)
    (connect m n)
    (connect n o)
    (connect o p)
    (connect p q)
    (connect q r)
    (connect r s)
    (connect s t)
    ;; goal
    (goal t)
    
    (= (cost) 0)
  )
  (:goal
    (finish)
  )

    (:metric minimize (cost))
)
