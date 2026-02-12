(define (problem move-only)
  (:domain uav-sample-collection)
  (:objects 
    u1 - uav
    l1 l2 - location
  )
  (:init 
    (at-uav u1 l1)
  )
  (:goal 
    (at-uav u1 l2)
  )
)
