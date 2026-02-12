;Header and description

(define (domain TerrainAdapt)

;remove requirements that are not needed
(:requirements :strips :numeric-fluents :typing :negative-preconditions)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
    uav
    position
)

; un-comment following line if constants are needed
;(:constants )

(:predicates ;todo: define predicates here
    (at ?r - uav ?p - position)
    (fly-mode ?r - uav)
    (drive-mode ?r - uav)
    (bad-weather ?p - position)
    (slippery-road ?p - position)
    (next ?p1 - position ?p2 - position)
)

;define actions here
(:action fly
    :parameters (?r - uav ?p1 - position ?p2 - position)
    :precondition (and 
        (at ?r ?p1) 
        (fly-mode ?r) 
        (not (bad-weather ?p1)) 
        (next ?p1 ?p2)
    )
    :effect (and 
        (at ?r ?p2) 
        (not (at ?r ?p1))
    )
)

(:action drive
    :parameters (?r - uav ?p1 - position ?p2 - position)
    :precondition (and 
        (at ?r ?p1) 
        (drive-mode ?r) 
        (not (slippery-road ?p1)) 
        (next ?p1 ?p2)
    )
    :effect (and 
        (at ?r ?p2) 
        (not (at ?r ?p1))
    )
)

(:action switch-fly
        :parameters (?r - uav ?p - position)
        :precondition (and 
            (slippery-road ?p) 
            (at ?r ?p) 
            (drive-mode ?r)
        )
        :effect (and 
            (not (drive-mode ?r)) 
            (fly-mode ?r)
        )
    )

(:action switch-drive
    :parameters (?r - uav ?p - position)
    :precondition (and 
        (bad-weather ?p) 
        (at ?r ?p) 
        (fly-mode ?r)
    )
    :effect (and 
        (not (fly-mode ?r)) 
        (drive-mode ?r)
    )
)
)