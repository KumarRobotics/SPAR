(define (problem wind-medium-5)
  (:domain WindDist)
  (:objects
    u1 - uav
    a b c d e f - position
  )
  (:init
    (at u1 a)
    (connect a b)
    (connect b c)
    (connect c d)
    (connect d e)
    (connect e f)

    (wind b)
    (blow-to b d)

    (= (cost) 0)
  )
  (:goal (at u1 f))
  (:metric minimize (cost))
)
