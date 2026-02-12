(define (problem graspfruit-problem-6)
  (:domain GraspFruit)
  (:objects
    u1 u2 - uav
    g1 g2 - gripper
    f1 f2 - fruit
    l1 - location
  )
  (:init
    (at-uav u1 l1)
    (at-uav u2 l1)
    (at-fruit f1 l1)
    (at-fruit f2 l1)
    (not (rot f1))
    (not (rot f2))
    (empty u1)
    (empty u2)
    (= (battery-level u1) 10)
    (= (battery-level u2) 10)
    (= (capacity u1) 10)
    (= (capacity u2) 10)
    (= (energy-cost l1 l1) 0)
  )
  (:goal (and (hold u1 f1) (hold u2 f2)))
)