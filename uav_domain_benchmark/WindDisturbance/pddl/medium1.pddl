(define (problem wind-medium-4)
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
    (connect e f)
    (connect f g)

    (wind c)
    (blow-to c e)

    (wind e)
    (blow-to e g)

    (= (cost) 0)
  )
  (:goal (at u1 g))
  (:metric minimize (cost))
)
