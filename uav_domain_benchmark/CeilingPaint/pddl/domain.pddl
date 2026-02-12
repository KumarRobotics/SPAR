;Header and description

(define (domain CeilingPaintDomain)

;remove requirements that are not needed
(:requirements :strips :numeric-fluents :typing :negative-preconditions)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
uav
position
sprayer
color
)


(:predicates ;todo: define predicates here
(uav-at ?r - uav ?x - position)
(holding ?r - uav ?b - sprayer)
(empty ?r - uav)
(sprayer-color ?b - sprayer ?c - color)
(painted ?x - position ?c - Colorr)
(clear ?x - position)
(landed ?r - uav)
(flying ?r - uav)
)


(:functions ;todo: define numeric functions here
    (cost)
)

;define actions here

(:action Pick-up-sprayer
    :parameters (?r - uav ?b - sprayer)
    :precondition (and 
                    (landed ?r)
                    (empty ?r)
    )
    :effect (and 
            (holding ?r ?b) 
            (not (empty ?r))
            (increase (cost) 5)
    )
)

(:action Put-down-sprayer
    :parameters (?r - uav ?b - sprayer)
    :precondition (and 
        (holding ?r ?b)
        (landed ?r)
    )
    :effect (and 
        (not (holding ?r ?b))
        (empty ?r)
        (increase (cost) 4)
    )
)


(:action Take-off
    :parameters (?r - uav)
    :precondition (and 
        (landed ?r)
    )
    :effect (and 
        (not (landed ?r))
        (flying ?r)
        (increase (cost) 6)
    )
)


(:action Landing
    :parameters (?r - uav)
    :precondition (and 
        (flying ?r)
    )
    :effect (and 
        (not (flying ?r))
        (landed ?r)
        (increase (cost) 7)
    )
)

(:action Fly-to
    :parameters (?r - uav ?from - position ?to - position)
    :precondition (and 
        (flying ?r)
        (uav-at ?r ?from)
    )
    :effect (and 
        (not (uav-at ?r ?from))
        (uav-at ?r ?to)
        (increase (cost) 1)
    )
)


(:action Paint
    :parameters (?r - uav ?b - sprayer ?c - color ?t - position)
    :precondition (and 
        (flying ?r)
        (holding ?r ?b)
        (uav-at ?r ?t)
        (sprayer-color ?b ?c)
        (clear ?t)
    )
    :effect (and 
        (painted ?t ?c)
        (not (clear ?t))
        (increase (cost) 1)
    )
)







)