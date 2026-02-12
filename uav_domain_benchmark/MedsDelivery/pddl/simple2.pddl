(define (problem get-sample-only)
  (:domain uav-sample-collection)
  (:objects 
    u1 - uav
    l1 - location
    s1 - sample
  )
  (:init 
    (at-uav u1 l1)
    (at-sample s1 l1)
    (uav-empty u1)
  )
  (:goal 
    (holding u1 s1)
  )
)
