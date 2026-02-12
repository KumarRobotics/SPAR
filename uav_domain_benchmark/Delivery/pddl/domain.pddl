(define (domain DeliveryDomain)
	
	(:requirements :typing)

	(:types uav package location)

	(:predicates
		(uav-empty ?d - uav)
		(holding ?d - uav ?p - package)
		(at-uav ?d - uav ?l - location)
		(at-package ?p - package ?l - location)
	)

	(:action LOAD
		:parameters (?d - uav ?p - package ?l - location)
		:precondition (and 
		                (at-uav ?d ?l)
						(uav-empty ?d)
						(at-package ?p ?l))
		:effect (and 
					 (holding ?d ?p)
					 (not (uav-empty ?d))
					 (not (at-package ?p ?l))
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
					 (uav-empty ?d)
					 (at-package ?p ?l)
					 )
	)

	(:action MOVE
		:parameters (?d - uav ?from ?to - location)
		:precondition (at-uav ?d ?from)
		:effect (and 
		             (at-uav ?d ?to)
					 (not (at-uav ?d ?from))
                )
	)
)