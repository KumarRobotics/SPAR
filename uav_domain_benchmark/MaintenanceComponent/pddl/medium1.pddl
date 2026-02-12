;take_image - analyse_bad_image - measure_thermal - analyse_nomaly_heat
(define (problem maintenance-prob-5)
  (:domain uav_maintenance)
  (:objects u1 - uav c1 - component)
  (:init 
    (available u1)
    (bad-state c1)
    (= (heat c1) 60)
    (= (max_heat) 50)
  )
  (:goal 
    (and
      (image_analyzed c1)
      (heat_analyzed c1)
    )
  )
)
