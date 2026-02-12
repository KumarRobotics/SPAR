; take picture + analyze bad image
(define (problem maintenance-prob-2)
  (:domain uav_maintenance)
  (:objects u1 - uav c1 - component)
  (:init 
    (available u1)
    (bad-state c1)
  )
  (:goal 
    (and
      (anomaly c1)
    )
  )
)
