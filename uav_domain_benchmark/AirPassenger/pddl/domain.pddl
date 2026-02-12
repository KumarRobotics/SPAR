(define (domain uav_passenger_transport)

  (:requirements :typing :strips :numeric-fluents :equality)

  (:types
    uav
    passenger
    location
  )

  (:predicates
    (at-uav ?u - uav ?l - location)                     ; UAV is at a location
    (at-passenger ?p - passenger ?l - location)     ; Passenger is at a location
    (in-uav ?p - passenger ?u - uav)                ; Passenger is onboard
    (is-charging-station ?l - location)             ; Location is a charging station
  )

  (:functions
    (battery-level ?u - uav)                        ; Current battery level
    (weight ?p - passenger)                         ; Passenger's weight
    (remaining-load ?u - uav)                         ; remaining load capacity of the UAV
    (max-battery ?u - uav)                          ; UAV's battery capacity
    (energy-cost ?from - location ?to - location)     ; Movement cost between locations
  )

  ;; Move UAV
  (:action move
    :parameters (?u - uav ?from - location ?to - location)
    :precondition (and
      (at-uav ?u ?from)
      (<= (energy-cost ?from ?to) (battery-level ?u))
    )
    :effect (and
      (not (at-uav ?u ?from))
      (at-uav ?u ?to)
      (decrease (battery-level ?u) (energy-cost ?from ?to))
    )
  )

  ;; Passenger boards UAV
  (:action board
    :parameters (?u - uav ?p - passenger ?l - location)
    :precondition (and
      (at-passenger ?p ?l)
      (at-uav ?u ?l)
      (<= (weight ?p) (remaining-load ?u))
    )
    :effect (and
      (not (at-passenger ?p ?l))
      (in-uav ?p ?u)
      (decrease (remaining-load ?u) (weight ?p))
    )
  )

  ;; Passenger exits UAV
  (:action deboard
    :parameters (?p - passenger ?u - uav ?l - location)
    :precondition (and
      (in-uav ?p ?u)
      (at-uav ?u ?l)
    )
    :effect (and
      (not (in-uav ?p ?u))
      (at-passenger ?p ?l)
      (increase (remaining-load ?u) (weight ?p))
    )
  )

  ;; UAV recharges to max battery
  (:action recharge
    :parameters (?u - uav ?l - location)
    :precondition (and
      (at-uav ?u ?l)
      (is-charging-station ?l)
    )
    :effect (and
      (assign (battery-level ?u) (max-battery ?u))
    )
)
)
