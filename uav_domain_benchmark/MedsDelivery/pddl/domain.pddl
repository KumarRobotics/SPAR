(define (domain uav-sample-collection)
    (:requirements :strips :typing)
    
    (:types 
        uav 
        location 
        sample 
    )

    (:predicates 
        (at-uav ?d - uav ?l - location) 
        (uav-empty ?d - uav) 
        (holding ?d - uav ?s - sample) 
        (at-sample ?s - sample ?h - location)
    )

    (:action move-uav
        :parameters (?d - uav ?from - location ?to - location)
        :precondition (and 
                        (at-uav ?d ?from)
                      )
        :effect (and 
            (at-uav ?d ?to) 
            (not (at-uav ?d ?from))
        )
    )

    (:action get-blood-sample
        :parameters (?d - uav ?s - sample ?h - location)
        :precondition (and 
            (at-uav ?d ?h) 
            (uav-empty ?d) 
            (at-sample ?s ?h)
        )
        :effect (and 
            (holding ?d ?s) 
            (not (uav-empty ?d)) 
            (not (at-sample ?s ?h))
        )
    )

    (:action give-blood-sample
        :parameters (?d - uav ?s - sample ?h - location)
        :precondition (and 
            (at-uav ?d ?h) 
            (holding ?d ?s)
        )
        :effect (and 
            (not (holding ?d ?s)) 
            (uav-empty ?d) 
            (at-sample ?s ?h)
        )
    )
)