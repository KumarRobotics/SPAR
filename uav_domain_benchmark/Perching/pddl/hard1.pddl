(define (problem uav-perching-problem)
  (:domain UAV-Perching)

  (:objects
    uav1 - uav
    loc_start loc_mid loc_goal - location
  )

  (:init

    (at uav1 loc_start)
    (in-air uav1)


    (connected loc_start loc_mid)
    (connected loc_mid loc_goal)


    (clear loc_goal)
    (clear loc_mid)
    (clear loc_goal)
  )

  (:goal
    (and
        (perch-visit loc_mid)
      (perch-visit loc_goal)
      
    )
  )
)