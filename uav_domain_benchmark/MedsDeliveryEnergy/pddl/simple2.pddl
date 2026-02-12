(define (problem test-collect)
  (:domain uav-sample-energy)
  (:objects
    u1 - uav
    s1 - sample
    l1 - location
  )
  (:init
    (at-uav u1 l1)
    (at-sample s1 l1)
    (empty u1)
  )
  (:goal (and
    (holding u1 s1)
  ))
)
