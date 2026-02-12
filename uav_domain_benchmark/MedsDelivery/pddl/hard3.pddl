(define (problem dual-uav-cross-task)
  (:domain uav-sample-collection)
  (:objects 
    u1 u2 - uav
    sa1 sa2 d1 d2 - location
    s1 s2 - sample
  )
  (:init 
    (at-uav u1 d2) ;
    (at-uav u2 d1) ;
    (at-sample s1 sa1)
    (at-sample s2 sa2)
    (uav-empty u1)
    (uav-empty u2)
  )
  (:goal 
    (and 
      (at-sample s1 d1)
      (at-sample s2 d2)
    )
  )
)
