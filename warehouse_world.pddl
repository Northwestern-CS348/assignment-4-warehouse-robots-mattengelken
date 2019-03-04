(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )


   (:action moveRobot
      :parameters (?r - robot ?from - location ?to - location)
      :precondition (and
	 	(no-robot ?to)
		(connected ?to ?from)
		(at ?r ?from)
		)
      :effect (and
	 	(at ?r ?to)
		(no-robot ?from)
		)
   )

   (:action moveRobotWithPallette
      :parameters (?r - robot ?p - pallette ?from - location ?to - location)
      :precondition (and
	 	(no-robot ?to)
		(no-pallette ?to)
		(at ?r ?from)
		(at ?p ?from)
		(connected ?from ?to)
		)
      :effect (and
	 	(at ?r ?to)
		(at ?p ?to)
		(has ?r ?p)
		(no-robot ?from)
		(no-pallette ?from)
		)
   )

   (:action moveToPackagingLocation
      :parameters (?p - pallette ?l - location ?s - shipment ?si - saleitem ?o - order)
      :precondition (and
	 	(started ?s)
		(at ?p ?l)
		(contains ?p ?si)
		(orders ?o ?si)
		(packing-at ?s ?l)
		(ships ?s ?o)
		)
      :effect (and
	 	(not (contains ?p ?si))
		(includes ?s ?si)
		)
   )

   (:action completeShipment
      :parameters (?l - location ?s - shipment ?o - order)
      :precondition (and
	 	(started ?s)
		(ships ?s ?o)
		(packing-at ?s ?l)
		)
      :effect (and
	 	(available ?l)
		(complete ?s)
		)
    )

)
