;Header and description

(define (domain NavDomain)

;remove requirements that are not needed
(:requirements :strips :typing :numeric-fluents)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
    uav position
)

; un-comment following line if constants are needed
;(:constants )

(:predicates ;todo: define predicates here
    (at ?r - uav ?p - position)
    (connect ?p0 - position ?p1 - position)
    (goal ?p - position)
    (finish)
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
    )
    :effect (and 
        (not(at ?r ?p0)) 
        (at ?r ?p1) 
        (increase (cost) 1)
    )
)


(:action reach-goal
    :parameters (?r - uav ?p - position)
    :precondition (and 
        (at ?r ?p) 
        (goal ?p)
    )
    :effect (and 
        (finish)
    )
)



)