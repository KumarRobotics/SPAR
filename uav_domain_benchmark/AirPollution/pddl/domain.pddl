(define (domain AirQualityMonitoring)

  (:requirements :strips :typing :numeric-fluents)

  (:types 
    uav region
  )

  (:predicates 
    (at ?u - uav ?r - region)
    (next ?r1 - region ?r2 - region)
  )

  (:functions
    (need-time ?r - region)
    (spend-time ?r - region) 
  )

  (:action move
    :parameters (?u - uav ?from - region ?to - region)
    :precondition (and 
      (at ?u ?from)
      (next ?from ?to)
    )
    :effect (and 
      (not (at ?u ?from))
      (at ?u ?to)
    )
  )

  (:action monitoring
      :parameters (?u - uav ?r - region)
      :precondition (and 
        (at ?u ?r)
        (>= (need-time ?r) (spend-time ?r))
      )
      :effect (and 
        (increase (spend-time ?r) 1)
      )
  )
  
)
