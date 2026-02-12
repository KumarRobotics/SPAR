(define (problem graspfruit-problem-9)
  (:domain GraspFruit)
  (:objects
    u1 u2 - uav
    g1 g2 - gripper
    f1 f2 f3 - fruit
    l1 l2 l3 - location
  )
  (:init
    (at-uav u1 l1)
    (at-uav u2 l1)
    (at-fruit f1 l2)
    (at-fruit f2 l2)
    (at-fruit f3 l3)
    (not (rot f1))
    (not (rot f2))
    (not (rot f3))
    (charging-spot l1)
    (empty u1)
    (empty u2)
    (= (battery-level u1) 5)
    (= (battery-level u2) 5)
    (= (capacity u1) 10)
    (= (capacity u2) 10)

    (= (energy-cost l1 l2) 5)
    (= (energy-cost l1 l3) 2)
    (= (energy-cost l2 l1) 5)
    (= (energy-cost l2 l3) 2)
    (= (energy-cost l3 l1) 3)
    (= (energy-cost l3 l2) 1)
  )
  (:goal (and
    (image-taken f1)
    (image-taken f2)
    (image-taken f3)
    (at-fruit f1 l1)
    (at-fruit f2 l1)
    (at-fruit f3 l1)
  ))
)
