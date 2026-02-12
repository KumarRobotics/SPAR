;Header and description

(define (domain Gate)

;remove requirements that are not needed
(:requirements :strips :numeric-fluents :typing)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
    uav
)

; un-comment following line if constants are needed
;(:constants )

(:predicates ;todo: define predicates here
(pass ?r - uav)
)


(:functions ;todo: define numeric functions here
(cur_angel ?r - uav)
(control_rate ?r - uav)
(gate_angle)
)

(:action increase_angle
    :parameters (?r - uav)
    :precondition (and 
        (> (gate_angle) (cur_angel ?r))
    )
    :effect (and 
        (increase (cur_angel ?r) (control_rate ?r))
    )
)

(:action decrease_angle
    :parameters (?r - uav)
    :precondition (and 
        (< (gate_angle) (cur_angel ?r)) 
    )
    :effect (and 
        (decrease (cur_angel ?r) (control_rate ?r))
    )
)


(:action pass-gate
    :parameters (?r - uav)
    :precondition (and 
                    (= (cur_angel ?r) (gate_angle))
                  )
    :effect (and (pass ?r))
)


)