(define (domain SimpleNavigationDomain)

(:requirements :strips :typing)

(:types 
    uav location
)

(:predicates 
    (at-location ?r - uav ?l - location) ; if uav ?r in location ?l
    (at-next ?current - location ?next - location) ; Specifies that if ?next is the next location after ?current
    (is-goal ?loc - location) ; if location ?loc is the goal location
    (reach-goal ?r -uav) ; if uav ?r reach goal
)

(:action move-next
    :parameters (?r - uav ?current - location ?next - location)
    :precondition (and 
        (at-location ?r ?current)
        (at-next ?current ?next)
    )
    :effect (and 
        (not(at-location ?r ?current))
        (at-location ?r ?next)
    )
)

(:action if-reach-goal
    :parameters (?r - uav ?loc - location)
    :precondition (and 
        (at-location ?r ?loc)
        (is-goal ?loc)
    )
    :effect (and 
        (reach-goal ?r)
    )
)
)