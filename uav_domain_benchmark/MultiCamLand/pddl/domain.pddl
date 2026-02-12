;Header and description

(define (domain Multicam)

;remove requirements that are not needed
(:requirements :strips :fluents :typing :negative-preconditions)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
    uav position
)

; un-comment following line if constants are needed
;(:constants )

(:predicates ;todo: define predicates here
(at ?r - uav ?p - position)
(clear ?p - position)
(obs ?p - position)
(see-right ?r)
(see-left ?r)
(down ?pp ?p)
(right ?pp ?p) 
(left ?pp ?p) 
(up ?pp ?p)
)


(:functions ;todo: define numeric functions here
(cost)
)

;define actions here
(:action move-right
    :parameters (?r - uav ?p1 - position ?p2 - position)
    :precondition (and 
                    (at ?r ?p1) 
                    (clear ?p2) 
                    (right ?p2 ?p1)
                )
    :effect (and 
                (at ?r ?p2) 
                (not(at ?r ?p1)) 
                (increase (cost) 1)
            )
)


(:action move-left
    :parameters (?r - uav ?p1 - position ?p2 - position)
    :precondition (and 
                    (at ?r ?p1) 
                    (clear ?p2) 
                    (left ?p2 ?p1)
                )
    :effect (and 
                (at ?r ?p2) 
                (not(at ?r ?p1)) 
                (increase (cost) 1)
            )
)


(:action move-down
    :parameters (?r - uav ?p1 - position ?p2 - position)
    :precondition (and 
                    (at ?r ?p1) 
                    (clear ?p2) 
                    (down ?p2 ?p1)
                )
    :effect (and 
                (at ?r ?p2) 
                (not(at ?r ?p1)) 
                (increase (cost) 1)
            )
)


(:action move-up
    :parameters (?r - uav ?p1 - position ?p2 - position)
    :precondition (and 
                    (at ?r ?p1) 
                    (clear ?p2) 
                    (up ?p2 ?p1)
                )
    :effect (and 
                (at ?r ?p2) 
                (not(at ?r ?p1)) 
                (increase (cost) 1)
            )
)

(:action rotate-to-right
    :parameters (?r - uav)
    :precondition (and 
                    (see-left ?r)
                  )
    :effect (and 
            (see-right ?r)
            (not (see-left ?r))
            (increase (cost) 1)
    )
)

(:action rotate-to-left
    :parameters (?r - uav)
    :precondition (and 
                    (see-right ?r)
                  )
    :effect (and 
            (see-left ?r)
            (not (see-right ?r))
            (increase (cost) 1)
    )
)


(:action detect_down
    :parameters (?r - uav ?p - position ?pp - position)
    :precondition (and 
        (at ?r ?p)
        (down ?pp ?p)
        (not (obs ?pp))
    )
    :effect (and 
        (clear ?pp)
        (increase (cost) 1)
    )
)


(:action detect_right
    :parameters (?r - uav ?p - position ?pp - position)
    :precondition (and 
        (at ?r ?p)
        (see-right ?r)
        (right ?pp ?p)
        (not (obs ?pp))
    )
    :effect (and
            (clear ?pp)
            (increase (cost) 1)
    )
)

(:action detect_left
    :parameters (?r - uav ?p - position ?pp - position)
    :precondition (and 
        (at ?r ?p)
        (see-left ?r)
        (left ?pp ?p)
        (not (obs ?pp))
    )
    :effect (and
            (clear ?pp)
            (increase (cost) 1)
    )
)

)