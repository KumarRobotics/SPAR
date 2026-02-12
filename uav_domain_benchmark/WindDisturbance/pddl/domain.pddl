;Header and description

(define (domain WindDist)

;remove requirements that are not needed
(:requirements :strips :typing :numeric-fluents :negative-preconditions)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
    uav position
)

; un-comment following line if constants are needed
;(:constants )

(:predicates ;todo: define predicates here
    (at ?r - uav ?p - position)
    (connect ?p0 - position ?p1 - position)
    (wind ?p - position)
    (blow-to ?p0 - position ?p1 - position)
)

(:functions
    (cost)
)

;define actions here
(:action move
    :parameters (?r - uav ?p0 - position ?p1 - position)
    :precondition (and 
        (at ?r ?p0) 
        (connect ?p0 ?p1) 
        (not (wind ?p0))
    )
    :effect (and 
        (not(at ?r ?p0)) 
        (at ?r ?p1) 
        (increase (cost) 1) 
    )
)

(:action blow
    :parameters (?r - uav ?p - position ?p2 - position)
    :precondition (and 
        (at ?r ?p) 
        (wind ?p) 
        (blow-to ?p ?p2)
    )
    :effect (and 
        (not (at ?r ?p)) 
        (at ?r ?p2)
    )
    )
)
