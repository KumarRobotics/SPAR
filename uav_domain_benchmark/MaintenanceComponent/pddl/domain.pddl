(define (domain uav_maintenance)
    (:requirements :strips :typing :fluents :negative-preconditions)

    (:types uav component)

    (:predicates
        (available ?d - uav)
        (heat_analyzed ?c - component)
        (anomaly ?c - component)
        (image_taken ?c - component)
        (image_analyzed ?c - component)
        (thermal_measured ?c - component)
        (bad-state ?c - component)
    )

    (:functions
        (heat ?c - component) 
        (max_heat)
    )

    (:action take_image
        :parameters (?d - uav ?c - component)
        :precondition (and 
             (available ?d)
        )
        :effect (and 
                (image_taken ?c)
                (not (available ?d))
                )
    )

    (:action analyse_bad_image
        :parameters (?d - uav ?c - component)
        :precondition (and
                        (image_taken ?c)
                        (bad-state ?c)
                    )
        :effect (and 
                (image_analyzed ?c)
                (anomaly ?c)
                (available ?d)
                )
    )

    (:action analyse_good_image
        :parameters (?d - uav ?c - component)
        :precondition (and
                        (image_taken ?c)
                        (not (bad-state ?c))
                    )
        :effect (and 
                (image_analyzed ?c)
                (available ?d)
                )
    )

    (:action measure_thermal
        :parameters (?d - uav ?c - component)
        :precondition (and 
                (available ?d)
                )
        :effect (and 
                (thermal_measured ?c)
                (not (available ?d))
                )
    )

    (:action analyse_normal_heat
        :parameters (?d - uav ?c - component)
        :precondition (and 
                    (thermal_measured ?c)
                    (< (heat ?c) (max_heat))
        )
        :effect (and 
                (heat_analyzed ?c)
                (available ?d)
                )
    )


    (:action analyse_nomaly_heat
        :parameters (?d - uav ?c - component)
        :precondition (and 
                    (thermal_measured ?c)
                    (>= (heat ?c) (max_heat))
        )
        :effect (and 
                (heat_analyzed ?c)
                (anomaly ?c)
                (available ?d)
                )
    )

)