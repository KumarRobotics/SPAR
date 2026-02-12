;Header and description

(define (domain trackingdomain)

;remove requirements that are not needed
(:requirements :strips :typing :numeric-fluents)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
uav
position
)


(:predicates ;todo: define predicates here
(at ?r - uav ?p - position) ; uav at position
(next-goal ?p1 - position ?p2 - position) ; next tracking goal for uav
(next-uav ?p1 - position ?p2 - position) ; uav movement constraints
(current-goal ?p - position) ; current tracking goal for uav
(reach-subgoal ?p - position) ; uav has reached a subgoal      
)

(:functions
    (cost)
)


;define actions here

(:action move
    :parameters (?r - uav ?p1 - position ?p2 - position)
    :precondition (and 
            (at ?r ?p1) 
            (next-uav ?p1 ?p2)
    )   
    :effect (and 
            (not (at ?r ?p1)) 
            (at ?r ?p2) 
            (increase (cost) 1) ; increase cost by 1 for each move
    )
)


(:action update-subgoal
    :parameters (?r - uav ?p1 - position ?p2 - position)
    :precondition (and
      (at ?r ?p1)
      (current-goal ?p1)
      (next-goal ?p1 ?p2)
    )
    :effect (and
      (not (current-goal ?p1))
      (current-goal ?p2)
      (reach-subgoal ?p1)
    )
)

)