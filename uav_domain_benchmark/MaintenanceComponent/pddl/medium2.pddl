; take_image - analyse_good_image - measure_thermal - analyse_normal_heat
(define (problem maintenance-prob-6)
  (:domain uav_maintenance)
  (:objects u1 - uav c1 - component)
  (:init 
    (available u1)
    (not (bad-state c1))
    (= (heat c1) 45)
    (= (max_heat) 50)
  )
  (:goal 
    (and
      (image_analyzed c1)
      (heat_analyzed c1)
    )
  )
)
