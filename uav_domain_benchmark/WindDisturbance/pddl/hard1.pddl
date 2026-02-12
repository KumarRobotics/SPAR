(define (problem wind-hard-7)
  (:domain WindDist)
  (:objects
    u1 u2 - uav
    a b c d e f g h i j - position
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

    (wind b) (blow-to b d)
    (wind e) (blow-to e g)
    (wind h) (blow-to h j)

    (= (cost) 0)
  )
  (:goal 
    (and 
      (at u1 j)
      (at u2 g)
    )
  )
  (:metric minimize (cost))
)
