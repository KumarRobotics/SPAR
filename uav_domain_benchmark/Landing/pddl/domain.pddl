(define (domain UAV-Landing)

  (:requirements 
    :strips 
    :typing
  )

  (:types 
    uav location
  )

  (:predicates 
    (at ?u - uav ?l - location)        ; UAV is at a location
    (landing-spot ?l - location)        ; Location is suitable for landing
    (clear ?l - location)               ; Location is currently clear
    (landed ?u - uav)                   ; UAV has successfully landed
    (in-air ?u - uav)                   ; UAV is flying
    (connected ?from - location ?to - location) ; Locations are connected
  )

  (:action fly
    :parameters (?u - uav ?from - location ?to - location)
    :precondition (and 
      (at ?u ?from)
      (connected ?from ?to)
      (in-air ?u)
    )
    :effect (and
      (not (at ?u ?from))
      (at ?u ?to)
    )
  )

  (:action check-landing-spot
    :parameters (?u - uav ?l - location)
    :precondition (and 
      (at ?u ?l)
      (in-air ?u)
      (clear ?l)
    )
    :effect (and
      (landing-spot ?l)
    )
  )


  (:action land
    :parameters (?u - uav ?l - location)
    :precondition (and 
      (at ?u ?l)
      (landing-spot ?l)
      (in-air ?u)
    )
    :effect (and
      (landed ?u)
      (not (in-air ?u))
    )
  )

)
