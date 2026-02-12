(define (problem wind-hard-9)
  (:domain WindDist)
  (:objects
    u1 u2 - uav
    a b c d e f g h i j k l m n o p - position
  )
  (:init
    (at u1 a)
    (at u2 a)

    ;; map connectivity
    (connect a b) (connect b a)
    (connect b c) (connect c b)
    (connect c d) (connect d c)
    (connect d e) (connect e d)
    (connect e f) (connect f e)
    (connect f g) (connect g f)
    (connect g h) (connect h g)
    (connect h i) (connect i h)
    (connect i j) (connect j i)
    (connect j k) (connect k j)
    (connect k l) (connect l k)
    (connect l m) (connect m l)
    (connect m n) (connect n m)
    (connect n o) (connect o n)
    (connect o p) (connect p o)


    ;; wind regions
    (wind b) (blow-to b d)
    (wind d) (blow-to d f)
    (wind h) (blow-to h j)
    (wind j) (blow-to j l)
    (wind n) (blow-to n p)

    (= (cost) 0)
  )
  (:goal 
    (and 
      (at u1 p)
      (at u2 m)
    )
  )
  (:metric minimize (cost))
)
