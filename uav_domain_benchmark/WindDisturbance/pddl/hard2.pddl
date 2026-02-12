(define (problem wind-hard-8)
  (:domain WindDist)
  (:objects
    u1 u2 - uav
    a b c d e f g h i j k l m - position
  )
  (:init
    (at u1 a)
    (at u2 a)

    ;; Bi-directional connectivity
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

    ;; Wind zones
    (wind c) (blow-to c e)
    (wind f) (blow-to f h)
    (wind j) (blow-to j l)

    (= (cost) 0)
  )
  (:goal 
    (and 
      (at u1 m)
      (at u2 k)
    )
  )
  (:metric minimize (cost))
)
