; measure and analyse normal heat
(define (problem maintenance-prob-3)
  (:domain uav_maintenance)
  (:objects u1 - uav c1 - component)
  (:init 
    (available u1)
    (= (heat c1) 30)
    (= (max_heat) 50)
  )
  (:goal 
    (and
      (heat_analyzed c1)
    )
  )
)
