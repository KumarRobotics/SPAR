; 3 uav
(define (problem landing-prob-9)
  (:domain UAV-Landing)
  (:objects u1 u2 u3 - uav
            a b c d e f g - location)
  (:init
    (at u1 a) (in-air u1)
    (at u2 g) (in-air u2)
    (at u3 c) (in-air u3)

    ;; map
    (connected a b) (connected b a)
    (connected b c) (connected c b)
    (connected c d) (connected d c)
    (connected d e) (connected e d)
    (connected e f) (connected f e)
    (connected f g) (connected g f)

    (clear c)
    (clear e)
    (clear g)
  )
  (:goal (and
    (landed u1)
    (landed u2)
    (landed u3)
  ))
)
