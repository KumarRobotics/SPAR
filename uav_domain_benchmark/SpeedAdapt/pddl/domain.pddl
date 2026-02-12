;Header and description

(define (domain SpeedAdapt)

;remove requirements that are not needed
(:requirements :strips :numeric-fluents :typing)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
uav
position 
)

; un-comment following line if constants are needed
;(:constants )

(:predicates ;todo: define predicates here
(at ?r - uav ?p - position)
(next ?p1 - position ?p2 - position)
(is-clutter ?p - position)
(is-open-area ?p - position)
(is-narrow-gap ?p - position)
(is-pass ?p - position)
)

(:functions
    (acc ?r - uav)
    (speed ?r - uav)
    (clutter-speed)
    (narrow-gap-speed)
    (open-area-speed)
)


;define actions here
(:action const-move
    :parameters (?r - uav ?p1 - position ?p2 - position)
    :precondition (and 
        (at ?r ?p1) 
        (is-pass ?p1) 
        (next ?p1 ?p2)
    )
    :effect (and 
        (at ?r ?p2) 
        (not (at ?r ?p1))
    )
)

(:action acc-move
    :parameters (?r - uav ?p1 - position ?p2 - position)
    :precondition (and 
            (at ?r ?p1) 
            (is-pass ?p1) 
            (next ?p1 ?p2)
    )
    :effect (and 
            (at ?r ?p2) 
            (not (at ?r ?p1)) 
            (increase (speed ?r) (acc ?r))
    )
)


(:action dcc-move
    :parameters (?r - uav ?p1 - position ?p2 - position)
    :precondition (and 
            (at ?r ?p1) 
            (is-pass ?p1) 
            (next ?p1 ?p2) 
            (> (- (speed ?r) (acc ?r)) 0)
        )
    :effect (and 
            (at ?r ?p2) 
            (not (at ?r ?p1)) 
            (decrease (speed ?r) (acc ?r))
    )
)


(:action pass-clutter
    :parameters (?r - uav ?p - position)
    :precondition (and 
        (at ?r ?p) 
        (is-clutter ?p) 
        (<= (speed ?r) (clutter-speed))
    )
    :effect (and 
        (is-pass ?p)
    )
)

(:action pass-narrow-gap
    :parameters (?r - uav ?p - position)
    :precondition (and 
        (at ?r ?p) 
        (is-narrow-gap ?p) 
        (<= (speed ?r) (narrow-gap-speed))
    )
    :effect (and 
        (is-pass ?p)
    )
)

(:action pass-open-area
    :parameters (?r - uav ?p - position)
    :precondition (and 
        (at ?r ?p) 
        (is-open-area ?p) 
        (>= (speed ?r ) (open-area-speed))
    )
    :effect (and 
        (is-pass ?p)
    )
)



)