(define (domain uav-navigation)
    (:requirements :strips :typing)
    
    (:types 
        uav 
        location
    )
    
    (:predicates 
        (at-uav ?d - uav ?l - location) 
        (next-location ?from - location ?to - location)
        (goal-reached ?d - uav ?goal - location)
    )
    
    (:action Move-to-Next-Location
        :parameters (?d - uav ?from - location ?to - location)
        :precondition (and 
            (at-uav ?d ?from)
            (next-location ?from ?to)
        )
        :effect (and
            (at-uav ?d ?to)
            (not (at-uav ?d ?from))
        )
    )
    
    (:action Verify-Arrival-at-Goal-Location
        :parameters (?d - uav ?goal - location)
        :precondition (and
            (at-uav ?d ?goal)
        )
        :effect (and
            (goal-reached ?d ?goal)
        )
    )
)