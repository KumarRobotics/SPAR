(define (problem DeliveryDurativePromblem)

	(:domain DeliveryDuratiion)

	(:objects uav1 - uav
			  package1 package2 package3 package4 package5 - package
			  location1 location2 location3 location4 location5 warehouse - location
	)

	(:init

		(is-warehouse warehouse)

		(empty uav1)
		(at-uav uav1 warehouse)
		(at-package package1 location1)
		(at-package package2 location2)
		(at-package package3 location3)
		(at-package package4 location4)
		(at-package package5 location5)

		
		(= (time-cost warehouse location1) 3)
		(= (time-cost warehouse location2) 2)
		(= (time-cost warehouse location3) 3)
		(= (time-cost warehouse location4) 2)
		(= (time-cost warehouse location5) 1)

		(= (time-cost location1 warehouse) 3)
		(= (time-cost location2 warehouse) 2)
		(= (time-cost location3 warehouse) 3)
		(= (time-cost location4 warehouse) 2)
		(= (time-cost location5 warehouse) 1)

		(= (value package1) 20)
		(= (value package2) 20)
		(= (value package3) 30)
		(= (value package4) 25)
		(= (value package5) 58)

		(= (total-value) 0)
		(= (total-duration) 0)
	)

	(:goal (and
		(> (total-value) 60)
		)
	)

	(:metric minimize (total-duration))
)