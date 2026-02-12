
(define (problem graspfruit-problem-5)
  (:domain GraspFruit)
  (:objects
    u1 - uav
    g1 - gripper
    f1 f2 - fruit
    l1 - location
  )
  (:init
    (at-uav u1 l1)
    (at-fruit f1 l1)
    (at-fruit f2 l1)
    (rot f1)
    (not (rot f2))
    (empty u1)
    (= (battery-level u1) 10)
    (= (capacity u1) 10)
    (= (energy-cost l1 l1) 0)
  )
  (:goal (and (hold u1 f2)))
)