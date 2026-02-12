(define (problem uavWateringProb) (:domain uavWatering)
(:objects 
uav - uav
pot1 - pot
f0 f1 f2 f3 - location
)

(:init
    ;todo: put the initial state's facts and numeric values here
    (at-uav uav f0)
    (home f0)
    (at-pot pot1 f0)
    (empty uav)
    (= (capacity pot1) 10)
    (= (water-level pot1) 0)
    (= (need-water f1) 21)
    (= (need-water f2) 25)
    (= (need-water f3) 12)
    (= (need-water f0) 6)
)

(:goal (and
    ;todo: put the goal condition here
    (done f1)
    (done f2)
    (done f3)
    (done f0)
))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)
