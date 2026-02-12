(define (problem graspfruit-hard-3uav)
  (:domain GraspFruit)

  (:objects
    uav1 uav2 uav3 - uav
    g1 g2 g3 - gripper
    f1 f2 f3 f4 f5 - fruit
    l1 l2 l3 l4 l5 l6 - location
  )

  (:init
    ;; UAV initial locations
    (at-uav uav1 l1)
    (at-uav uav2 l2)
    (at-uav uav3 l3)
    
    ;; UAVs are empty and unclamped
    (empty uav1) (empty uav2) (empty uav3)

    
    ;; fruit locations
    (at-fruit f1 l4) (at-fruit f2 l3)
    (at-fruit f3 l1) (at-fruit f4 l2)
    (at-fruit f5 l2)

    ;; rot ground truth
    (rot f2)
    (rot f4)

    ;; charging spots
    (charging-spot l1)
    (charging-spot l2)

    ;; battery and cost (all locations fully connected)
    (= (battery-level uav1) 10)
    (= (battery-level uav2) 10)
    (= (battery-level uav3) 10)

    (= (capacity uav1) 10)
    (= (capacity uav2) 10)
    (= (capacity uav3) 10)

    ;; energy costs (fully connected map, uniform cost 2)
    (= (energy-cost l1 l2) 2) 
    (= (energy-cost l1 l3) 4)
    (= (energy-cost l1 l4) 2)
    (= (energy-cost l1 l5) 2)
    (= (energy-cost l1 l6) 5)

    (= (energy-cost l2 l1) 2)
    (= (energy-cost l2 l3) 4)
    (= (energy-cost l2 l4) 2)
    (= (energy-cost l2 l5) 2)
    (= (energy-cost l2 l6) 5)

    (= (energy-cost l3 l1) 4)
    (= (energy-cost l3 l2) 4)
    (= (energy-cost l3 l4) 2)
    (= (energy-cost l3 l5) 2)
    (= (energy-cost l3 l6) 5)

    (= (energy-cost l4 l1) 2)
    (= (energy-cost l4 l2) 2)
    (= (energy-cost l4 l3) 2)
    (= (energy-cost l4 l5) 5)
    (= (energy-cost l4 l6) 5)

    (= (energy-cost l5 l1) 2)
    (= (energy-cost l5 l2) 2)
    (= (energy-cost l5 l3) 2)
    (= (energy-cost l5 l4) 5)
    (= (energy-cost l5 l6) 5)

    (= (energy-cost l6 l1) 5)
    (= (energy-cost l6 l2) 5)
    (= (energy-cost l6 l3) 5)
    (= (energy-cost l6 l4) 5)
    (= (energy-cost l6 l5) 5)
    

  )

  (:goal
    (and
      ;; image must be taken for all fruits
      (image-taken f1)
      (image-taken f2)
      (image-taken f3)
      (image-taken f4)
      (image-taken f5)

      ;; only good fruits should be grasped and moved to l9
      (at-fruit f1 l6)
      (at-fruit f3 l4)
      (at-fruit f5 l6)
    )
  )
)
