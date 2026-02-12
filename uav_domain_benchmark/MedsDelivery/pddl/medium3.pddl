(define (problem sample-delivery-disjoint-start)
  (:domain uav-sample-collection)
  (:objects 
    u1 - uav
    base siteA lab - location
    s1 - sample
  )
  (:init 
    (at-uav u1 base)
    (at-sample s1 siteA)
    (uav-empty u1)
  )
  (:goal 
    (and 
      (at-sample s1 lab)
    )
  )
)
