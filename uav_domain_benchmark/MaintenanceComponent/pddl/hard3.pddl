; 2 components
(define (problem maintenance-prob-8)
  (:domain uav_maintenance)
  (:objects u1 - uav c1 c2 - component)
  (:init 
    (available u1)
    (bad-state c1)
    (bad-state c2)
    (= (heat c1) 25)
    (= (heat c2) 55)
    (= (max_heat) 50)
  )
  (:goal 
    (and
      (image_analyzed c1)
      (heat_analyzed c2)
    )
  )
)
