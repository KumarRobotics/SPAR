(define (problem single-uav-multi-sample)
  (:domain uav-sample-collection)
  (:objects 
    u1 - uav
    loc1 loc2 loc3 - location
    s1 s2 - sample
  )
  (:init 
    (at-uav u1 loc1)
    (at-sample s1 loc1)
    (at-sample s2 loc2)
    (uav-empty u1)
  )
  (:goal 
    (and 
      (at-sample s1 loc3)
      (at-sample s2 loc3)
    )
  )
)
