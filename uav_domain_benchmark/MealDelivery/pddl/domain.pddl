(define (domain uav_meal_delivery)
  (:requirements :typing :strips :negative-preconditions)

  (:types
    uav
    arm          
    meal          
    location      
  )

  (:predicates
    (at-uav ?u - uav ?l - location)
    (at-arm ?r - arm ?l - location)
    (at-meal ?m - meal ?l - location)

    (prepared ?m - meal)
    (carrying ?u - uav ?m - meal)
    (empty-uav ?u - uav)
    (cooking ?r - arm ?m - meal)
  )

  (:action start-cooking
    :parameters (?r - arm ?m - meal ?l - location)
    :precondition (and
      (at-arm ?r ?l)
      (not (prepared ?m))
    )
    :effect (and
      (cooking ?r ?m)
    )
  )
  

  (:action finish-cooking
    :parameters (?r - arm ?m - meal ?l - location)
    :precondition (and
      (at-arm ?r ?l)
      (cooking ?r ?m)
    )
    :effect (and
      (prepared ?m)
      (at-meal ?m ?l)
      (not (cooking ?r ?m))
    )
  )

  (:action fly
    :parameters (?u - uav ?from - location ?to - location)
    :precondition (and
      (at-uav ?u ?from)
    )    
    :effect (and
      (not (at-uav ?u ?from))
      (at-uav ?u ?to)
    )
  )

  (:action pick-up-meal
    :parameters (?u - uav ?m - meal ?l - location)
    :precondition (and
      (at-uav ?u ?l)
      (at-meal ?m ?l)
      (prepared ?m)
      (empty-uav ?u)
    )
    :effect (and
      (carrying ?u ?m)
      (not (at-meal ?m ?l))
      (not (empty-uav ?u))
    )
  )


  (:action deliver-meal
    :parameters (?u - uav ?m - meal ?l - location)
    :precondition (and
      (at-uav ?u ?l)
      (carrying ?u ?m)
    )
    :effect (and
      (not (carrying ?u ?m))
      (at-meal ?m ?l)
      (empty-uav ?u)
    )
  )
)
