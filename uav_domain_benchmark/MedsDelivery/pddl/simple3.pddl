(define (problem give-sample-only)
  (:domain uav-sample-collection)
  (:objects 
    u1 - uav
    l1 - location
    s1 - sample
  )
  (:init 
    (at-uav u1 l1)
    (holding u1 s1)
  )
  (:goal 
    (and 
      (at-sample s1 l1)
    )
  )
)
