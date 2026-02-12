(define (problem sample-collection-prob)
  (:domain uav-sample-collection)

  (:objects
    uav1 - uav
    loc1 loc2 loc3 - location
    sample1 sample2 - sample
  )

  (:init
    (at-uav uav1 loc1)
    (uav-empty uav1)

    (at-sample sample1 loc2)
    (at-sample sample2 loc3)
  )

  (:goal
    (and
      (at-sample sample1 loc1)
      (at-sample sample2 loc1)
    )
  )
)
