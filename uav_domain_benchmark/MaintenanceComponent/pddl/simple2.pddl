; measure and analyse over heat
(define (problem maintenance-prob-4)
  (:domain uav_maintenance)
  (:objects u1 - uav c1 - component)
  (:init 
    (available u1)
    (= (heat c1) 55)
    (= (max_heat) 50)
  )
  (:goal 
    (and
      (anomaly c1)
    )
  )
)
