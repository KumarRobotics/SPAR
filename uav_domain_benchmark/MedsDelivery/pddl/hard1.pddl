(define (problem dual-uav-parallel-sample)
  (:domain uav-sample-collection)
  (:objects 
    u1 u2 - uav
    a1 a2 b1 b2 - location
    s1 s2 - sample
  )
  (:init 
    (at-uav u1 a1)
    (at-uav u2 a2)
    (at-sample s1 a1)
    (at-sample s2 a2)
    (uav-empty u1)
    (uav-empty u2)
  )
  (:goal 
    (and 
      (at-sample s1 b1)
      (at-sample s2 b2)
    )
  )
)
