(define (domain CityCargo)
    (:requirements :strips :typing :negative-preconditions)
    
    (:types 
        uav 
        truck 
        location 
        city 
        package 
    )

    (:predicates 
        (package-at ?p - package ?l - location)
        (truck-at ?t - truck ?l - location)
        (uav-at ?u - uav ?l - location)
        (location-is-airport ?l - location)
        (package-in-truck ?p - package ?t - truck)
        (package-in-uav ?p - package ?u - uav)
        (location-in-city ?l - location ?c - city)
    )

    (:action truck-load
        :parameters (?t - truck ?p - package ?l - location)
        :precondition (and 
            (package-at ?p ?l)
            (truck-at ?t ?l)
        
        )
        :effect (and 
            (not (package-at ?p ?l))
            (package-in-truck ?p ?t)
        )
    )

    (:action truck-unload
        :parameters (?t - truck ?p - package ?l - location)
        :precondition (and 
            (package-in-truck ?p ?t)
            (truck-at ?t ?l)
        )
        :effect (and 
            (not (package-in-truck ?p ?t))
            (package-at ?p ?l)
        )
    )

    (:action uav-load
        :parameters (?u - uav ?p - package ?l - location)
        :precondition (and 
            (package-at ?p ?l)
            (uav-at ?u ?l)
            (location-is-airport ?l)
        )
        :effect (and 
            (not (package-at ?p ?l))
            (package-in-uav ?p ?u)
        )
    )

    (:action uav-unload
        :parameters (?u - uav ?p - package ?l - location)
        :precondition (and 
            (package-in-uav ?p ?u)
            (uav-at ?u ?l)
            (location-is-airport ?l)
        )
        :effect (and 
            (not (package-in-uav ?p ?u))
            (package-at ?p ?l)
        )
    )

   
    (:action truck-drive
        :parameters (?t - truck ?from - location ?to - location ?c - city)
        :precondition (and 
            (truck-at ?t ?from)
            (location-in-city ?from ?c)
            (location-in-city ?to ?c)
        )
        :effect (and 
            (not (truck-at ?t ?from))
            (truck-at ?t ?to)
        )
    )
    

     (:action uav-fly
        :parameters (?u - uav ?from - location ?to - location ?c1 - city ?c2 - city)
        :precondition (and 
            (uav-at ?u ?from)
            (location-in-city ?from ?c1)
            (location-in-city ?to ?c2)
            (location-is-airport ?from)
            (location-is-airport ?to)
        )
        :effect (and 
            (not (uav-at ?u ?from))
            (uav-at ?u ?to)
        )
    )
    
    
)