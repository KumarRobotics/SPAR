(define (domain uav-sample-energy)
    (:requirements :strips :typing :numeric-fluents)
    (:types uav location sample)

    (:predicates
        (at-uav ?d - uav ?from - location)
        (holding ?d - uav ?s - sample)
        (at-sample ?s - sample ?h - location)
        (empty ?d - uav) 
    )

    (:functions
        (battery-power ?d - uav) 
        (energy-cost ?from - location ?to - location) 
        (recharge-capacity ?h - location) 
    )

    (:action Travel
        :parameters (?d - uav ?from - location ?to - location)
        :precondition (and 
            (at-uav ?d ?from)
            (>= (battery-power ?d) (energy-cost ?from ?to))
        )
        :effect (and
            (not (at-uav ?d ?from))
            (at-uav ?d ?to)
            (decrease (battery-power ?d) (energy-cost ?from ?to))
        )
    )

    (:action Collect_Blood_Sample
        :parameters (?d - uav ?s - sample ?h - location)
        :precondition (and
            (at-uav ?d ?h)
            (at-sample ?s ?h)
            (empty ?d) 
        )
        :effect (and
            (holding ?d ?s)
            (not (empty ?d))
            (not (at-sample ?s ?h))
        )
    )

    (:action Unload_Blood_Sample
        :parameters (?d - uav ?s - sample ?h - location)
        :precondition (and
            (at-uav ?d ?h)
            (holding ?d ?s)
        )
        :effect (and
            (not (holding ?d ?s))
            (at-sample ?s ?h)
            (empty ?d)
        )
    )

    (:action Recharge_Battery
        :parameters (?d - uav ?h - location)
        :precondition (and
            (at-uav ?d ?h)
            (> (battery-power ?d) 0)
        )
        :effect (and
            (assign (battery-power ?d) (recharge-capacity ?h))
        )
    )
)