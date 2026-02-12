(define (problem tracking-simple-1)
  (:domain trackingdomain)
  (:objects u1 - uav p1 p2 - position)
  (:init 
    (at u1 p1)
    (next-uav p1 p2)
    (= (cost) 0)
  )
  (:goal 
    (at u1 p2)
  )
  (:metric minimize (cost))
)
