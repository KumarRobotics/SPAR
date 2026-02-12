;Header and description

(define (domain DeliveryDuratiion)

;remove requirements that are not needed
(:requirements :strips :numeric-fluents :typing :negative-preconditions)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
	uav
	package
	location
)

(:predicates ;todo: define predicates here
	(holding ?d - uav ?p - package)
	(at-uav ?d - uav ?l - location)
	(at-package ?p - package ?l - location)
	(empty ?d - uav)
	(is-warehouse ?l - location)
)


(:functions ;todo: define numeric functions here
	(time-cost ?from - location ?to - location)
	(total-duration)
	(value ?p - package)
	(total-value)
)

(:action LOAD
	:parameters (?d - uav ?p - package ?l - location)
	:precondition (and 
					(at-uav ?d ?l)
					(at-package ?p ?l)	
					(empty ?d)
					(not (is-warehouse ?l)) ; packages can not be loaded in warehouse
				)
	:effect (and 
				(holding ?d ?p)
				(not (empty ?d))
				(not (at-package ?p ?l))	 
			)
)

(:action UNLOAD
	:parameters (?d - uav ?p - package ?l - location)
	:precondition (and 
					(at-uav ?d ?l)
					(holding ?d ?p)
					(is-warehouse ?l)
				)
	:effect (and 
				(not (holding ?d ?p))
				(empty ?d)
				(at-package ?p ?l)
				(increase (total-value) (value ?p))
			)
)

(:action MOVE
	:parameters (?d - uav ?from - location ?to - location)
	:precondition (and 
						(at-uav ?d ?from)
					)
	:effect (and 
				(at-uav ?d ?to)
				(not (at-uav ?d ?from))
				(increase (total-duration) (time-cost ?from ?to))
			)
)


)