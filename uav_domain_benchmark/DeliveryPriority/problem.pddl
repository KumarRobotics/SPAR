(define (problem DeliveryOrderPromblem)

	(:domain DeliveryOrderDomain-STRIPS)

	(:objects uav1 - uav
			  package1 package2 package3 - package
			  location1 location2 location3 warehouse - location
	)

	(:init
		(at-uav uav1 warehouse)
		(at-package package1 warehouse)
		(at-package package2 warehouse)
		(at-package package3 warehouse)
		(uav-empty uav1)

		(next package2 package1)
		(next package1 package3)

        (loadable package2)
	)

	(:goal (and
		(at-package package1 location1)
		(at-package package2 location2)
		(at-package package3 location3)
		(at-uav uav1 warehouse)
		)
	)
)