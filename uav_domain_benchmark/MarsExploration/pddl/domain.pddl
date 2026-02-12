;Header and description

(define (domain MarsExplorationDomain)

;remove requirements that are not needed
(:requirements :strips :typing :numeric-fluents :negative-preconditions :equality)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
    uav 
    rover
    location
)

; un-comment following line if constants are needed
;(:constants )

(:predicates ;todo: define predicates here
    (at-uav ?u - uav ?l - location)
    (at-rov ?r - rover ?l - location)
    (explored ?l - location)
    (resource ?l - location)
    (resource-collected ?l - location)
)


(:functions ;todo: define numeric functions here
 (total-resource)
 (value ?l - location)
)

;define actions here
(:action Move-uav
    :parameters (?d - uav ?l - location ?to - location)
    :precondition (and 
                (at-uav ?d ?l)
            )
    :effect (and 
                (not(at-uav ?d ?l)) 
                (at-uav ?d ?to)
            )
)

(:action Move-rov
    :parameters (?r - rover ?l - location ?to - location)
    :precondition (and 
                    (at-rov ?r ?l)
                    )
    :effect (and 
                (not(at-rov ?r ?l)) 
                (at-rov ?r ?to)
            )
)

(:action Explore
    :parameters (?d - uav ?l - location)
    :precondition (and 
                    (at-uav ?d ?l)
                    (resource ?l)
                    (not (explored ?l))
    )
    :effect (and
                (explored ?l)
            )
)

(:action GetResource
    :parameters (?r - rover ?l - location)
    :precondition (and 
                    (at-rov ?r ?l)  
                    (explored ?l) 
                    (not (resource-collected ?l))
                 )
    :effect (and 
                (increase (total-resource) (value ?l)) 
                (resource-collected ?l)
            )
)

)

