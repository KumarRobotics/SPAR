;Header and description

(define (domain ForestFireCollabration)

;remove requirements that are not needed
(:requirements :strips :typing :negative-preconditions)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
    area
    uav
    ugv
)


(:predicates ;todo: define predicates here
    (at-uav-location ?r - uav ?l - area)
    (at-ugv-location ?r - ugv ?l - area)
    (on-fire ?a - area)
    (danger ?a - area)
    (next ?from - area ?to -area)
)

;define actions here


(:action MOVE-uav
    :parameters (?d - uav ?from - area ?to - area)
    :precondition (and 
        (at-uav-location ?d ?from)
        (next ?from ?to)
    )
    :effect (and 
        (not (at-uav-location ?d ?from))
        (at-uav-location ?d ?to)
    )
)


(:action MOVE-ugv
    :parameters (?d - ugv ?from - area ?to - area)
    :precondition (and 
        (at-ugv-location ?d ?from)
        (next ?from ?to)
    )
    :effect (and 
        (not(at-ugv-location ?d ?from))
        (at-ugv-location ?d ?to)
    )
)


(:action CALL-uav
    :parameters (?d - uav ?a - area)
    :precondition (and 
        (at-uav-location ?d ?a)
        (on-fire ?a)
    )
    :effect (and 
        (danger ?a)
    )
)

(:action ExTINGUISH-FIRE
    :parameters (?d - ugv ?a - area)
    :precondition (and 
        (danger ?a)
        (at-ugv-location ?d ?a)
    )
    :effect (and 
        (not (on-fire ?a))
        (not (danger ?a))
    )
)

)