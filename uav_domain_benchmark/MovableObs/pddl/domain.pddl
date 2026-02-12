;Header and description

(define (domain MovableObs)

;remove requirements that are not needed
(:requirements :strips :fluents :typing :negative-preconditions :equality)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
    uav 
    ugv
    position 
)

; un-comment following line if constants are needed
;(:constants )

(:predicates ;todo: define predicates here
    (at-uav ?uav - uav ?p - position)
    (at-ugv ?ugv - ugv ?p - position)
    
    (clear ?p - position) ; ground truth
    (fix-obs ?p - position) ; ground truth
    (mov-obs ?p - position) ; ground truth

    (is-clear ?p - position)
    (is-fix ?p - position)
    (is-mov ?p - position)

    (connect ?p1 - position ?p2 - position)
)


(:functions ;todo: define numeric functions here
    (cost)
)

;define actions here
(:action move-ugv
    :parameters (?r - ugv ?p1 - position ?p2 - position)
    :precondition (and 
            (at-ugv ?r ?p1) 
            (connect ?p1 ?p2) 
            (is-clear ?p1) 
            (is-clear ?p2)
    )
    :effect (and 
        (not (at-ugv ?r ?p1)) 
        (at-ugv ?r ?p2) 
        (increase (cost) 1)
    )
)

(:action move-uav
    :parameters (?r - uav ?p1 - position ?p2 - position)
    :precondition (and 
        (at-uav ?r ?p1) 
        (connect ?p1 ?p2)
    )
    :effect (and 
        (not (at-uav ?r ?p1)) 
        (at-uav ?r ?p2) 
        (increase (cost) 1)
    )
)

(:action uav-detect-clear
    :parameters (?r - uav ?p - position)
    :precondition (and 
        (at-uav ?r ?p) 
        (clear ?p)
    )
    :effect (and 
                (is-clear ?p)
                (not (is-fix ?p))
                (not (is-mov ?p))
                (increase (cost) 1)
            )
)

(:action uav-detect-fix
    :parameters (?r - uav ?p - position)
    :precondition (and 
        (at-uav ?r ?p) 
        (fix-obs ?p)
    )
    :effect (and 
                (is-fix ?p)
                (not (is-clear ?p))
                (not (is-mov ?p))
                (increase (cost) 1)
            )
)

(:action uav-detect-mov
    :parameters (?r - uav ?p - position)
    :precondition (and 
        (at-uav ?r ?p) 
        (mov-obs ?p)
    )
    :effect (and 
                (is-mov ?p)
                (not (is-clear ?p))
                (not (is-fix ?p))
                (increase (cost) 1)
            )
)


(:action push
    :parameters (?r - ugv ?p - position ?pp - position ?ppp - position)
    :precondition (and 
                    (at-ugv ?r ?p)
                    (is-mov ?pp)
                    (connect ?p ?pp)
                    (connect ?pp ?ppp)
                    (is-clear ?p)
                    (is-clear ?ppp)
                    (not (= ?p ?ppp))
                  )
    :effect (and 
            (is-clear ?pp)
            (not (mov-obs ?pp))
            (mov-obs ?ppp)
            (is-mov ?ppp)
            (not (is-clear ?ppp))
            (not (clear ?ppp))
            (not (fix-obs ?ppp))
            (not (is-fix ?ppp))
            (at-ugv ?r ?pp)
            (not (at-ugv ?r ?p))
            (increase (cost) 2)
    )
)




)