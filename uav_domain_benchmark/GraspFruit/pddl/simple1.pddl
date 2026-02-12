(define (problem graspfruit-problem-1)
  (:domain GraspFruit)
  (:objects
    u1 - uav
    g1 - gripper
    f1 - fruit
    l1 - location
  )
  (:init
    (at-uav u1 l1)
    (at-fruit f1 l1)
    (not (rot f1))
    (empty u1)
    (= (battery-level u1) 10)
    (= (capacity u1) 10)
    (= (energy-cost l1 l1) 0)
  )
  (:goal (and (hold u1 f1)))
)