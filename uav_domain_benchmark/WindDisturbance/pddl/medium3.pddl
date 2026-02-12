(define (problem wind-medium-6)
  (:domain WindDist)
  (:objects
    u1 - uav
    a b c d e f g - position
  )
  (:init
    (at u1 a)
    (connect a b)
    (connect b c)
    (connect c d)
    (connect d e)
    (connect c f)
    (connect f g)
    (connect g e)

    (wind b)
    (blow-to b c)

    (wind d)
    (blow-to d f)

    (= (cost) 0)
  )
  (:goal (at u1 e))
  (:metric minimize (cost))
)
