;Header and description

(define (domain GridExplore)

;remove requirements that are not needed
(:requirements :strips :fluents :typing :negative-preconditions )

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
    uav position 
)

; un-comment following line if constants are needed
;(:constants )

(:predicates ;todo: define predicates here
    (at ?r - uav ?p - position)
    (obs ?p2 - position) ; ground truth map
    (clear ?p - position) ; if uav identify it's clear
    (connect ?p1 - position ?p2 - position) 
)


(:functions ;todo: define numeric functions here
    (cost)
)

;define actions here
(:action move
    :parameters (?r - uav ?p1 - position ?p2 - position)
    :precondition (and 
            (at ?r ?p1) 
            (connect ?p1 ?p2) 
            (clear ?p2)
            )
    :effect (and 
            (at ?r ?p2) 
            (not(at ?r ?p1)) 
            (increase (cost) 1)
            )
)

(:action mark-clear
    :parameters (?r - uav ?p1 - position ?p2 - position)
    :precondition (and 
        (at ?r ?p1) 
        (connect ?p1 ?p2) 
        (not (obs ?p2))
    )
    :effect (and 
        (clear ?p2)
        )
)

)