(define (problem sample-delivery-move-mid)
  (:domain uav-sample-collection)
  (:objects 
    u1 - uav
    l1 l2 l3 - location
    s1 - sample
  )
  (:init 
    (at-uav u1 l1)
    (at-sample s1 l2)
    (uav-empty u1)
  )
  (:goal 
    (and 
      (at-sample s1 l3)
    )
  )
)
