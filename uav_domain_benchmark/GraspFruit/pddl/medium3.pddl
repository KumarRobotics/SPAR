(define (problem graspfruit-problem-7)
  (:domain GraspFruit)
  (:objects
    u1 - uav
    g1 - gripper
    f1 - fruit
    l1 l2 l3 - location
  )
  (:init
    (at-uav u1 l1)
    (charging-spot l1)
    (at-fruit f1 l2)
    (not (rot f1))
    (empty u1)
    (= (battery-level u1) 0)
    (= (capacity u1) 15)
    (= (energy-cost l1 l2) 5)
    (= (energy-cost l2 l3) 5)
  )
  (:goal (and (at-fruit f1 l3)))
)