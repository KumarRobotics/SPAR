;Header and description

(define (domain GraspDelivery)

;remove requirements that are not needed
(:requirements :strips :typing :negative-preconditions)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
uav 
package
location
)

; un-comment following line if constants are needed
;(:constants )

(:predicates ;todo: define predicates here
(at ?o - object ?l - location)
(next ?l1 - location ?l2 - location)
(narrow-gap ?l - location)
(is-narrow ?l - location)
(shrink ?r - uav)
(hold ?r - uav)
(clear ?l - location) 
)


(:action move
    :parameters (?r - uav ?l1 - location ?l2 - location)
    :precondition (and 
                    (at ?r ?l1) 
                    (next ?l1 ?l2) 
                    (clear ?l1)
                    )
    :effect (and 
                (not (at ?r ?l1)) 
                (at ?r ?l2)
    )
)

(:action detect-obstacle
    :parameters (?r - uav ?l - location)
    :precondition (and 
            (at ?r ?l) 
            (narrow-gap ?l)
    )
    :effect (and 
        (is-narrow ?l)
        (not (clear ?l))
    )
)


(:action detect-clear
    :parameters (?r - uav ?l - location)
    :precondition (and 
        (at ?r ?l) 
        (not (narrow-gap ?l))
    )
    :effect (and 
        (not (is-narrow ?l))
        (clear ?l)
    )
)


(:action shrink-pass
    :parameters (?r - uav ?l1 - location ?l2 - location)
    :precondition (and 
            (at ?r ?l1)
            (is-narrow ?l1) 
            (shrink ?r)
            (next ?l1 ?l2)
    )
    :effect (and 
        (at ?r ?l2) 
        (not (at ?r ?l1))
    )
)

(:action shrinking
    :parameters (?r - uav)
    :precondition (and 
        (not (shrink ?r))
    )
    :effect (and 
        (shrink ?r)
    )
)

(:action release
    :parameters (?r - uav)
    :precondition (and 
        (shrink ?r)
    )
    :effect (and 
        (not (shrink ?r))
    )
)

(:action grasp
    :parameters (?r - uav ?l - location ?p - package)
    :precondition (and 
        (at ?r ?l) 
        (at ?p ?l) 
        (not (hold ?r)) 
        (not (shrink ?r))
    )
    :effect (and 
        (hold ?r) 
        (shrink ?r)
    )
)

(:action unload
    :parameters (?r - uav ?l - location ?p - package)
    :precondition (and 
        (at ?r ?l) 
        (hold ?r) 
        (shrink ?r)
    )
    :effect (and 
        (not (hold ?r)) 
        (at ?p ?l) 
        (not(shrink ?r))
    )
)


)