(define (domain UAV-Perching)

  (:requirements 
    :strips 
    :typing 
    :negative-preconditions
  )

  (:types 
    uav location
  )

  (:predicates 
    (at ?u - uav ?l - location)         ; UAV is at a location
    (perch-spot ?l - location)           ; Location is a perchable spot
    (clear ?l - location)                ; Location is clear for perching
    (perched ?u - uav)                   ; UAV is perched
    (in-air ?u - uav)                    ; UAV is flying
    (perch-visit ?l - location)
    (connected ?from - location ?to - location) ; There is a path between two locations
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

  (:action detect-perch-spot
    :parameters (?u - uav ?l - location)
    :precondition (and
      (at ?u ?l)
      (in-air ?u)
      (clear ?l)
    )
    :effect (and 
      (perch-spot ?l)
    )
  )

  (:action perch
    :parameters (?u - uav ?l - location)
    :precondition (and
      (at ?u ?l)
      (perch-spot ?l)
      (in-air ?u)
    )
    :effect (and
      (perched ?u)
      (not (in-air ?u))
      (perch-visit ?l)
    )
  )

  (:action takeoff
    :parameters (?u - uav ?l - location)
    :precondition (and
      (at ?u ?l)
      (perched ?u)
    )
    :effect (and
      (in-air ?u)
      (not (perched ?u))
    )
  )

)