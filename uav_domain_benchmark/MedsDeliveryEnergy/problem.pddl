(define (problem MedsDelEngProb)

	(:domain uav-sample-energy)

	(:objects uav - uav
			  hospital1 hospital2 hospital3 central_hospital - location
			  sample1 sample2 sample3 - sample
	)

	(:init
		(at-uav uav central_hospital)
		(at-sample sample1 central_hospital)
		(at-sample sample2 central_hospital)
		(at-sample sample3 central_hospital)
		(empty uav)

        (= (energy-cost central_hospital hospital1) 1)
		(= (energy-cost central_hospital hospital2) 2) 
		(= (energy-cost central_hospital hospital3) 1) 
		(= (energy-cost hospital1 central_hospital) 2)
		(= (energy-cost hospital1 hospital2) 1) 
		(= (energy-cost hospital1 hospital3) 2) 
		(= (energy-cost hospital2 hospital1) 1)
		(= (energy-cost hospital2 hospital3) 2) 
		(= (energy-cost hospital2 central_hospital) 2) 
		(= (energy-cost hospital1 hospital1) 0)
		(= (energy-cost hospital2 hospital2) 0)
		(= (energy-cost hospital3 hospital3) 0)
		(= (energy-cost hospital3 hospital1) 1)
		(= (energy-cost hospital3 hospital2) 2)
		(= (energy-cost hospital3 central_hospital) 1)
		(= (energy-cost central_hospital central_hospital) 0)
		(= (battery-power uav) 8) 
        (= (recharge-capacity central_hospital) 5)
		(= (recharge-capacity hospital2) 4)
		(= (recharge-capacity hospital1) 3)
		(= (recharge-capacity hospital3) 0)
	)

	(:goal (and
		(at-sample sample1 hospital1)
		(at-sample sample2 hospital2)
		(at-sample sample3 hospital3)
		(at-uav uav central_hospital)
		)
	)

)