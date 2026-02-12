(define (domain DeliveryOrderDomain-STRIPS)

  (:requirements :strips :typing :negative-preconditions)

  (:types 
    uav package location
  )

  (:predicates
    (uav-empty ?d - uav)
    (holding ?d - uav ?p - package)
    (at-uav ?d - uav ?l - location)
    (at-package ?p - package ?l - location)
    (delivered ?p - package)
    (loadable ?p - package)
    (next ?prev - package ?p - package)
  )


  (:action MOVE
    :parameters (?d - uav ?from - location ?to - location)
    :precondition (and
                    (at-uav ?d ?from)
                  )
    :effect (and 
      (not (at-uav ?d ?from))
      (at-uav ?d ?to)
    )
  )


  (:action LOAD
    :parameters (?d - uav ?p - package ?l - location)
    :precondition (and 
      (at-uav ?d ?l)
      (at-package ?p ?l)
      (uav-empty ?d)
      (loadable ?p)
    )
    :effect (and
      (not (uav-empty ?d))
      (not (at-package ?p ?l))
      (holding ?d ?p)
    )
  )

  (:action PickNext
      :parameters (?p1 - package ?p2 - package)
      :precondition (and 
        (next ?p1 ?p2)
        (delivered ?p1)
        (not (delivered ?p2))
      )
      :effect (and 
        (loadable ?p2)
        (not (loadable ?p1))
      )
  )
  


  (:action UNLOAD
    :parameters (?d - uav ?p - package ?l - location)
    :precondition (and 
      (at-uav ?d ?l)
      (holding ?d ?p)
    )
    :effect (and
      (uav-empty ?d)
      (delivered ?p)
      (at-package ?p ?l)
      (not (holding ?d ?p))
    )
  )

)
