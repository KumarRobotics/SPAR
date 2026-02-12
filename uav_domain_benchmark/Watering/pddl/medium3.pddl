(define (problem watering-medium-3)
  (:domain uavWatering)
  (:objects 
  u1 - uav 
  p1 - pot 
  l1 l2 l3 - location)
  (:init
    (at-uav u1 l1)
    (at-pot p1 l1)
    (empty u1)
    (home l1)

    (= (capacity p1) 3)
    (= (water-level p1) 0)
    (= (need-water l1) 4)
    (= (need-water l2) 4)
    (= (need-water l3) 5)
  )
  (:goal (and (done l1) (done l2) (done l3)))
)