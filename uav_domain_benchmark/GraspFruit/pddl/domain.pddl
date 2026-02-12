;Header and description

(define (domain GraspFruit)

;remove requirements that are not needed
(:requirements :strips :numeric-fluents :typing :negative-preconditions :equality)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
gripper 
uav
fruit
location
)

; un-comment following line if constants are needed
;(:constants )

(:predicates ;todo: define predicates here
(at-uav ?u - uav ?l - location) ; UAV is at a specific location
(at-fruit ?f - fruit ?l - location) ; Fruit is at a specific location
(hold ?u - uav ?f - fruit) ; UAV has grasped a fruit
(empty ?u - uav)
(clamped ?u - uav ?g - gripper) ; UAV's gripper is clamped
(image-taken ?F - fruit) ; Image of the fruit has been taken
(rot ?f - fruit) ; ground truth rot fruit
(good ?f - fruit) ; UAV detects an not rot fruit
(charging-spot ?l - location)
)


(:functions ;todo: define numeric functions here
(battery-level ?u - uav) ; Battery level of UAV
(capacity ?u - uav) ; Capacity of UAV
(energy-cost ?l1 - location ?l2 - location) ; Energy cost to move from one location to another
)

;define actions here

(:action move
    :parameters (?u - uav ?from - location ?to - location)
    :precondition (and 
        (at-uav ?u ?from)
        (>= (battery-level ?u) (energy-cost ?from ?to))
    )
    :effect (and 
        (at-uav ?u ?to)
        (not (at-uav ?u ?from))
        (decrease (battery-level ?u) (energy-cost ?from ?to))
    )
)



(:action recharge
    :parameters (?u - uav ?l - location)
    :precondition (and 
        (at-uav ?u ?l)
        (charging-spot ?l) ; Assuming a predicate that defines charging spots
        (>= (battery-level ?u) 0) ; Ensure UAV is not already fully charged
    )
    :effect (and 
        (assign (battery-level ?u) (capacity ?u)) ; Recharge UAV to its full capacity
    )
)

(:action grasp-fruit
    :parameters (?u - uav ?f - fruit ?l - location ?g - gripper)
    :precondition (and
        (at-uav ?u ?l)
        (at-fruit ?f ?l)
        (good ?f)

        (empty ?u)
        (not (clamped ?u ?g))
    )
    :effect (and
        (hold ?u ?f)
        (not (empty ?u))
        (not (at-fruit ?f ?l))
        (clamped ?u ?g)
    )
)

(:action put-down-fruit
    :parameters (?u - uav ?f - fruit ?l - location ?g - gripper)
    :precondition (and
        (hold ?u ?f)
        (clamped ?u ?g)
        (at-uav ?u ?l)
    )
    :effect (and
        (not (hold ?u ?f))
        (empty ?u)
        (at-fruit ?f ?l)
        (not (clamped ?u ?g))
    )
)

(:action take-not-rot-image
    :parameters ( ?u - uav ?f - fruit ?l - location)
    :precondition (and 
        (at-uav ?u ?l)
        (at-fruit ?f ?l)
        (not (rot ?f))
        (not (image-taken ?f))
    )
    :effect (and 
        (image-taken ?f)
        (good ?f)
    )
)


(:action take-rot-image
    :parameters (?u - uav ?f - fruit ?l - location)
    :precondition (and 
        (at-uav ?u ?l)
        (at-fruit ?f ?l)
        (rot ?f)
        (not (image-taken ?f))
    )
    :effect (and 
        (not (good ?f))
        (image-taken ?f)
    )
)








)