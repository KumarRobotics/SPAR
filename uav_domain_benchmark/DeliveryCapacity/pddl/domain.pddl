(define (domain DeliveryCapacityDomain)
	
	(:requirements :typing :strips :numeric-fluents)

	(:types uav package location)

	(:predicates
		(holding ?d - uav ?p - package)
		(at-uav ?d - uav ?l - location)
		(at-package ?p - package ?l - location)
	)

	(:functions
		(distance ?from - location ?to - location)
		(weights ?p - package)
		(total-distance)
		(remaining-load)
	)

	(:action LOAD
		:parameters (?d - uav ?p - package ?l - location)
		:precondition (and 
		                (at-uav ?d ?l)
						(at-package ?p ?l)
						(>= (remaining-load) (weights ?p))	
					)
		:effect (and 
		             (holding ?d ?p)
					 (not (at-package ?p ?l))
					 (decrease (remaining-load) (weights ?p)) 	 
				)
	)

	(:action UNLOAD
		:parameters (?d - uav ?p - package ?l - location)
		:precondition (and 
		                (at-uav ?d ?l)
						(holding ?d ?p)
						)
		:effect (and 
		             (not (holding ?d ?p))
					 (at-package ?p ?l)
					 (increase (remaining-load) (weights ?p))
				)
	)

	(:action MOVE
		:parameters (?d - uav ?from ?to - location)
		:precondition (and 
							(at-uav ?d ?from)
						)
		:effect (and 
		             (at-uav ?d ?to)
					 (not (at-uav ?d ?from))
					 (increase (total-distance) (distance ?from ?to))
				)
	)
)