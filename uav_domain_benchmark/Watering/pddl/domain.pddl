;Header and description

(define (domain uavWatering)

;remove requirements that are not needed
(:requirements :strips :numeric-fluents :typing)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
    uav 
    pot
    location
)

; un-comment following line if constants are needed
;(:constants )

(:predicates ;todo: define predicates here
    (at-uav ?r - uav ?l - location)
    (at-pot ?p - pot ?l - location)
    (hold ?r - uav ?p - pot)
    (home ?l - location)
    (done ?l - location)
    (empty ?r - uav)
)


(:functions ;todo: define numeric functions here
    (capacity ?p - pot)
    (water-level ?p - pot)
    (need-water ?l - location)
)

(:action load-pot
    :parameters (?r - uav ?p - pot ?l - location)
    :precondition (and 
        (at-uav ?r ?l) 
        (at-pot ?p ?l)
        (empty ?r)
    )
    :effect (and 
        (hold ?r ?p) 
        (not (empty ?r))
        (not (at-pot ?p ?l))
    )
)

(:action refill
    :parameters (?r - uav ?p - pot ?l - location)
    :precondition (and 
        (at-uav ?r ?l) 
        (home ?l) 
        (hold ?r ?p)
    )
    :effect (and 
        (assign (water-level ?p) (capacity ?p))
    )
)

(:action watering-pour-to-fill
    :parameters (?r - uav ?p - pot ?l - location)
    :precondition (and 
                (at-uav ?r ?l) 
                (hold ?r ?p) 
                (> (water-level ?p) 0)
                (< (need-water ?l) (water-level ?p)) 
    )
    :effect (and 
                        (assign (need-water ?l) 0) 
                        (decrease (water-level ?p) (need-water ?l))
                        (done ?l)
            )
)


(:action watering-pour-empty
    :parameters (?r - uav ?p - pot ?l - location)
    :precondition (and 
                (at-uav ?r ?l) 
                (hold ?r ?p) 
                (> (water-level ?p) 0)
                 (> (need-water ?l)(water-level ?p)) 
    )
    :effect (and 
                (decrease (need-water ?l) (water-level ?p))
                (assign (water-level ?p) 0)
            )
)



(:action move
    :parameters (?r - uav ?l1 - location ?l2 - location)
    :precondition (and 
        (at-uav ?r ?l1)
    )
    :effect (and 
        (at-uav ?r ?l2) 
        (not (at-uav ?r ?l1))
    )
)

(:action unload
    :parameters (?r - uav ?p - pot ?l - location)
    :precondition (and 
        (hold ?r ?p)
        (at-uav ?r ?l)
    )
    :effect (and 
        (not (hold ?r ?p)) 
        (empty ?r)
        (at-pot ?p ?l)
    )
)


)


