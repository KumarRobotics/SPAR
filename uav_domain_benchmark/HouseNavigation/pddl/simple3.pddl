; test move reached goal
(define (problem uav-house-navigation)
  (:domain uav-navigation)

  (:objects
    drone1 - uav
    kitchen living_room hallway bathroom - location
  )

  (:init
    (at-uav drone1 kitchen)
    (next-location kitchen living_room)
    (next-location living_room hallway)
    (next-location hallway bathroom)
  )

  (:goal
    (goal-reached drone1 bathroom)
  )
)
