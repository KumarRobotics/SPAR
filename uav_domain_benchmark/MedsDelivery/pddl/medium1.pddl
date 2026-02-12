(define (problem sample-delivery-basic)
  (:domain uav-sample-collection)
  (:objects 
    u1 - uav
    h1 h2 - location
    s1 - sample
  )
  (:init 
    (at-uav u1 h1)
    (at-sample s1 h1)
    (uav-empty u1)
  )
  (:goal 
    (and 
      (at-sample s1 h2)
    )
  )
)
