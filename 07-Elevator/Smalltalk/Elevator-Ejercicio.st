!classDefinition: #ElevatorEmergency category: #'Elevator-Ejercicio'!
Error subclass: #ElevatorEmergency
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ElevatorEmergency class' category: #'Elevator-Ejercicio'!
ElevatorEmergency class
	instanceVariableNames: ''!

!ElevatorEmergency class methodsFor: 'as yet unclassified' stamp: 'abg 10/4/2017 11:59:51'!
cabinDesinchronized

	^self signal: 'Sensor de cabina desincronizado'.! !

!ElevatorEmergency class methodsFor: 'as yet unclassified' stamp: 'abg 10/4/2017 12:18:35'!
doorDesinchronized

	self signal: 'Sensor de puerta desincronizado'! !


!classDefinition: #ElevatorTest category: #'Elevator-Ejercicio'!
TestCase subclass: #ElevatorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:38'!
test09RequestToGoUpAreEnqueueWhenRequestedWhenCabinIsMoving

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorOpened.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinWaitingForPeople.
	self assert: elevatorController isCabinDoorOpened.! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:39'!
test10CabinDoorStartClosingAfterWaitingForPeople

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorOpened.
	elevatorController waitForPeopleTimedOut.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorClosing.! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:39'!
test11StopsWaitingForPeopleIfCloseDoorIsPressed

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorOpened.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinWaitingForPeople.
	self assert: elevatorController isCabinDoorOpened.

	elevatorController closeCabinDoor.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorClosing.
! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:39'!
test12CloseDoorDoesNothingIfIdle

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController closeCabinDoor.

	self assert: elevatorController isIdle.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpened.! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:40'!
test13CloseDoorDoesNothingWhenCabinIsMoving

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinMoving.
	self assert: elevatorController isCabinDoorClosed.

	elevatorController closeCabinDoor.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinMoving.
	self assert: elevatorController isCabinDoorClosed.! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:40'!
test14CloseDoorDoesNothingWhenOpeningTheDoorToWaitForPeople

	| elevatorController |
	elevatorController := ElevatorController new.
		
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.

	elevatorController closeCabinDoor.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !


!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:42'!
test15ElevatorHasToEnterEmergencyIfStoppedAndOtherFloorSensorTurnsOn

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	self 
		should: [ elevatorController cabinOnFloor:0 ]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de cabina desincronizado' ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:47'!
test16ElevatorHasToEnterEmergencyIfFalling

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	self 
		should: [ elevatorController cabinOnFloor:0 ]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de cabina desincronizado'. ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:47'!
test17ElevatorHasToEnterEmergencyIfJumpsFloors

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:3.
	elevatorController cabinDoorClosed.
	self 
		should: [ elevatorController cabinOnFloor: 3 ]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de cabina desincronizado'. ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:48'!
test18ElevatorHasToEnterEmergencyIfDoorClosesAutomatically
	| elevatorController |
	elevatorController := ElevatorController new.
	
	self 
		should: [ elevatorController cabinDoorClosed.]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de puerta desincronizado' ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:48'!
test19ElevatorHasToEnterEmergencyIfDoorClosedSensorTurnsOnWhenClosed

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	self 
		should: [elevatorController cabinDoorClosed.]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de puerta desincronizado'. ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:49'!
test20ElevatorHasToEnterEmergencyIfDoorClosesWhenOpening
	| elevatorController |
	elevatorController := ElevatorController new.
		
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	self 
		should: [elevatorController cabinDoorClosed.]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de puerta desincronizado'.]! !


!ElevatorTest methodsFor: 'tests 2' stamp: 'HernanWilkinson 7/10/2011 17:35'!
test06DoorKeepsOpenedWhenOpeningIsRequested

	| elevatorController |
	elevatorController := ElevatorController new.
	
	self assert: elevatorController isCabinDoorOpened.
	
	elevatorController openCabinDoor.

	self assert: elevatorController isCabinDoorOpened.! !

!ElevatorTest methodsFor: 'tests 2' stamp: 'HernanWilkinson 6/16/2014 13:24'!
test07DoorMustBeOpenedWhenCabinIsStoppedAndClosingDoors

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor:1.
		
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorClosing.
		
	elevatorController openCabinDoor.
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.
! !

!ElevatorTest methodsFor: 'tests 2' stamp: 'HernanWilkinson 7/10/2011 17:36'!
test08CanNotOpenDoorWhenCabinIsMoving

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinMoving.
	self assert: elevatorController isCabinDoorClosed.

	elevatorController openCabinDoor.
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinMoving.
	self assert: elevatorController isCabinDoorClosed.! !

!ElevatorTest methodsFor: 'tests 2' stamp: 'HernanWilkinson 7/10/2011 17:51'!
test09DoorKeepsOpeneingWhenItIsOpeneing

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.

	elevatorController openCabinDoor.
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !


!ElevatorTest methodsFor: 'tests 5' stamp: 'HernanWilkinson 7/10/2011 17:50'!
test21CabinHasToStopOnTheFloorsOnItsWay
	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinOnFloor:1.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !

!ElevatorTest methodsFor: 'tests 5' stamp: 'HernanWilkinson 7/10/2011 17:50'!
test22ElevatorCompletesAllTheRequests
	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinOnFloor:1.
	elevatorController cabinDoorOpened.
	elevatorController waitForPeopleTimedOut.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:2.
	
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !

!ElevatorTest methodsFor: 'tests 5' stamp: 'HernanWilkinson 7/10/2011 17:50'!
test23CabinHasToStopOnFloorsOnItsWayNoMatterHowTheyWellCalled

	| elevatorController |
	elevatorController := ElevatorController new.
		
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorClosed.
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinOnFloor:1.
		
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !

!ElevatorTest methodsFor: 'tests 5' stamp: 'HernanWilkinson 7/10/2011 17:51'!
test24CabinHasToStopAndWaitForPeopleOnFloorsOnItsWayNoMatterHowTheyWellCalled

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorClosed.
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinOnFloor:1.
	elevatorController cabinDoorOpened.
	elevatorController waitForPeopleTimedOut.
	
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorClosing.! !


!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/10/2011 17:33'!
test01ElevatorStartsIdleWithDoorOpenOnFloorZero

	| elevatorController |
		
	elevatorController := ElevatorController new.
		
	self assert: elevatorController isIdle.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpened.
	self assert: elevatorController cabinFloorNumber = 0
! !

!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/15/2011 17:53'!
test02CabinDoorStartsClosingWhenElevatorGetsCalled

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor: 1.
	
	self deny: elevatorController isIdle.
	self assert: elevatorController isWorking.
	
	self assert: elevatorController isCabinStopped.
	self deny: elevatorController isCabinMoving.
	
	self deny: elevatorController isCabinDoorOpened.
	self deny: elevatorController isCabinDoorOpening.
	self assert: elevatorController isCabinDoorClosing.
	self deny: elevatorController isCabinDoorClosed.! !

!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/15/2011 17:57'!
test03CabinStartsMovingWhenDoorGetsClosed

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	
	self deny: elevatorController isIdle.
	self assert: elevatorController isWorking.

	self deny: elevatorController isCabinStopped.
	self assert: elevatorController isCabinMoving.
	
	self deny: elevatorController isCabinDoorOpened.
	self deny: elevatorController isCabinDoorOpening.
	self deny: elevatorController isCabinDoorClosing.
	self assert: elevatorController isCabinDoorClosed.! !

!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/15/2011 18:00'!
test04CabinStopsAndStartsOpeningDoorWhenGetsToDestination

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor: 1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor: 1.

	self deny: elevatorController isIdle.
	self assert: elevatorController isWorking.
	
	self assert: elevatorController isCabinStopped.
	self deny: elevatorController isCabinMoving.
			
	self deny: elevatorController isCabinDoorOpened.
	self assert: elevatorController isCabinDoorOpening.
	self deny: elevatorController isCabinDoorClosing.
	self deny: elevatorController isCabinDoorClosed.

	self assert: elevatorController cabinFloorNumber = 1
! !

!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/15/2011 18:00'!
test05ElevatorGetsIdleWhenDoorGetOpened

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor: 1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor: 1.
	elevatorController cabinDoorOpened.
		
	self assert: elevatorController isIdle.
	self deny: elevatorController isWorking.
		
	self assert: elevatorController isCabinStopped.
	self deny: elevatorController isCabinMoving.

	self assert: elevatorController isCabinDoorOpened.
	self deny: elevatorController isCabinDoorOpening.
	self deny: elevatorController isCabinDoorClosing.
	self deny: elevatorController isCabinDoorClosed.
		
	self assert: elevatorController cabinFloorNumber = 1! !


!classDefinition: #Cabin category: #'Elevator-Ejercicio'!
Object subclass: #Cabin
	instanceVariableNames: 'cabinState cabinDoor cabinFloorNumber elevator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Cabin methodsFor: 'init' stamp: 'abg 10/12/2017 16:52:55'!
initializeOf: anElevatorController 
	elevator := anElevatorController .
	cabinDoor := CabinDoor of: self.
	cabinFloorNumber := 0.
	self stop.! !


!Cabin methodsFor: 'test' stamp: 'abg 10/10/2017 08:01:34'!
cabinFloorNumber
	^ cabinFloorNumber .! !

!Cabin methodsFor: 'test' stamp: 'abg 10/10/2017 02:57:50'!
isCabinDoorClosed
	^cabinDoor isCabinDoorClosed.! !

!Cabin methodsFor: 'test' stamp: 'abg 10/10/2017 02:57:55'!
isCabinDoorClosing
	^cabinDoor isCabinDoorClosing .! !

!Cabin methodsFor: 'test' stamp: 'abg 10/12/2017 10:39:19'!
isCabinDoorOpened
	^cabinDoor isCabinDoorOpened.! !

!Cabin methodsFor: 'test' stamp: 'abg 10/10/2017 02:58:05'!
isCabinDoorOpening
	^cabinDoor isCabinDoorOpening ! !

!Cabin methodsFor: 'test' stamp: 'abg 10/10/2017 02:26:07'!
isCabinMoving
	^self isCabinStopped not.! !

!Cabin methodsFor: 'test' stamp: 'abg 10/10/2017 02:25:42'!
isCabinStopped
	^cabinState = 'stopped'.! !

!Cabin methodsFor: 'test' stamp: 'abg 10/10/2017 02:28:40'!
isCabinWaitingForPeople
	^ true.! !


!Cabin methodsFor: 'accion' stamp: 'abg 10/12/2017 09:51:47'!
cabinDoorClosed
	cabinDoor cabinDoorClosed.! !

!Cabin methodsFor: 'accion' stamp: 'abg 10/12/2017 13:35:51'!
cabinDoorOpened
	cabinDoor cabinDoorOpened.! !

!Cabin methodsFor: 'accion' stamp: 'abg 10/12/2017 15:08:43'!
closeCabinDoor
	self state closeCabinDoor.! !

!Cabin methodsFor: 'accion' stamp: 'abg 10/12/2017 15:09:06'!
closeCabinDoorIfStopped
	cabinDoor closeCabinDoor.! !

!Cabin methodsFor: 'accion' stamp: 'abg 10/12/2017 10:57:08'!
moving
	cabinState := 'moving'! !

!Cabin methodsFor: 'accion' stamp: 'abg 10/12/2017 16:13:59'!
onFloor: aFloor

	self state onFloor: aFloor.
! !

!Cabin methodsFor: 'accion' stamp: 'abg 10/12/2017 16:52:13'!
onFloorWhenMoving: aFloor
	
	(self cabinFloorNumber + 1) = aFloor ifFalse:[ElevatorEmergency  cabinDesinchronized ] .
	cabinFloorNumber := aFloor .
	self stop.
	cabinDoor openCabinDoorWhenNotOpenned.
	elevator removeThisFloorIfItIsInFloorsToGo: aFloor.
! !

!Cabin methodsFor: 'accion' stamp: 'abg 10/12/2017 12:56:52'!
onFloorWhenStopped

	^ElevatorEmergency cabinDesinchronized.! !

!Cabin methodsFor: 'accion' stamp: 'abg 10/12/2017 15:24:20'!
openCabinDoor
	self state openCabinDoor! !

!Cabin methodsFor: 'accion' stamp: 'abg 10/12/2017 15:25:05'!
openCabinDoorWhenStopped
	cabinDoor openCabinDoor.! !

!Cabin methodsFor: 'accion' stamp: 'abg 10/12/2017 16:49:49'!
stop
	cabinState  := 'stopped'. 
! !


!Cabin methodsFor: 'state' stamp: 'abg 10/12/2017 12:53:44'!
state
   ^CabinState stateFor: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cabin class' category: #'Elevator-Ejercicio'!
Cabin class
	instanceVariableNames: 'anElevator cabinDoor elevator cabinFloorNumber cabinState'!

!Cabin class methodsFor: 'as yet unclassified' stamp: 'abg 10/10/2017 02:04:51'!
of: anElevator
	^self new initializeOf: anElevator.
	! !


!classDefinition: #CabinDoor category: #'Elevator-Ejercicio'!
Object subclass: #CabinDoor
	instanceVariableNames: 'cabinDoorState cabin'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinDoor methodsFor: 'init' stamp: 'abg 10/12/2017 16:53:49'!
initializeOf: aCabin
	cabin := aCabin.
	self cabinDoorOpened.! !


!CabinDoor methodsFor: 'test' stamp: 'abg 10/10/2017 02:24:59'!
isCabinDoorClosed
	^ cabinDoorState = 'closed' .! !

!CabinDoor methodsFor: 'test' stamp: 'abg 10/10/2017 02:24:44'!
isCabinDoorClosing
	^ cabinDoorState = 'closing' .! !

!CabinDoor methodsFor: 'test' stamp: 'abg 10/12/2017 10:39:03'!
isCabinDoorOpened
	^ cabinDoorState = 'open' .! !

!CabinDoor methodsFor: 'test' stamp: 'abg 10/10/2017 02:24:28'!
isCabinDoorOpening
	^ cabinDoorState = 'opening' .! !


!CabinDoor methodsFor: 'state' stamp: 'abg 10/12/2017 10:46:06'!
state
 ^CabinDoorState stateFor: self.! !


!CabinDoor methodsFor: 'accion' stamp: 'abg 10/12/2017 16:15:45'!
cabinDoorClosed
	self state cabinDoorClosed.
	cabin moving.
! !

!CabinDoor methodsFor: 'accion' stamp: 'abg 10/12/2017 10:51:50'!
cabinDoorClosedWhenAlreadyClosed
	^ ElevatorEmergency doorDesinchronized.! !

!CabinDoor methodsFor: 'accion' stamp: 'abg 10/12/2017 10:55:39'!
cabinDoorClosedWhenClosing

	cabinDoorState := 'closed'.! !

!CabinDoor methodsFor: 'accion' stamp: 'abg 10/12/2017 13:36:23'!
cabinDoorOpened
	cabinDoorState := 'open'.! !

!CabinDoor methodsFor: 'accion' stamp: 'abg 10/12/2017 15:13:51'!
closeCabinDoor
	self state closeCabinDoor.
	
	! !

!CabinDoor methodsFor: 'accion' stamp: 'abg 10/12/2017 15:14:13'!
closeCabinDoorWhenNotOpening
	cabinDoorState  := 'closing'.! !

!CabinDoor methodsFor: 'accion' stamp: 'abg 10/12/2017 15:30:13'!
openCabinDoor
	self state openCabinDoor.! !

!CabinDoor methodsFor: 'accion' stamp: 'abg 10/12/2017 15:28:16'!
openCabinDoorWhenNotOpenned
	cabinDoorState := 'opening'.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CabinDoor class' category: #'Elevator-Ejercicio'!
CabinDoor class
	instanceVariableNames: ''!

!CabinDoor class methodsFor: 'as yet unclassified' stamp: 'abg 10/10/2017 02:07:31'!
of: aCabin
	^self new initializeOf: aCabin.! !


!classDefinition: #CabinDoorState category: #'Elevator-Ejercicio'!
Object subclass: #CabinDoorState
	instanceVariableNames: 'cabinDoor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinDoorState methodsFor: 'init' stamp: 'abg 10/12/2017 10:19:07'!
initialize: aCabinDoor
	cabinDoor := aCabinDoor.
	
	! !


!CabinDoorState methodsFor: 'operations' stamp: 'abg 10/12/2017 10:11:54'!
cabinDoorClosed
	self subclassResponsibility ! !

!CabinDoorState methodsFor: 'operations' stamp: 'abg 10/12/2017 10:14:23'!
cabinDoorOpened
	self subclassResponsibility ! !

!CabinDoorState methodsFor: 'operations' stamp: 'abg 10/12/2017 10:15:35'!
closeCabinDoor
	self subclassResponsibility ! !

!CabinDoorState methodsFor: 'operations' stamp: 'abg 10/12/2017 10:17:27'!
openCabinDoor
	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CabinDoorState class' category: #'Elevator-Ejercicio'!
CabinDoorState class
	instanceVariableNames: ''!

!CabinDoorState class methodsFor: 'as yet unclassified' stamp: 'abg 10/12/2017 10:12:58'!
canHandle: aCabinDoor

	self subclassResponsibility ! !

!CabinDoorState class methodsFor: 'as yet unclassified' stamp: 'abg 10/12/2017 10:13:13'!
for: aCabinDoor
	^ self new initialize: aCabinDoor .
! !

!CabinDoorState class methodsFor: 'as yet unclassified' stamp: 'abg 10/12/2017 10:12:49'!
stateFor: aCabinDoor

	^(self subclasses detect: [:aCabinDoorState | aCabinDoorState canHandle: aCabinDoor ]) for: aCabinDoor! !


!classDefinition: #CabinDoorStateClosed category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #CabinDoorStateClosed
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!


!CabinDoorStateClosed methodsFor: 'operations' stamp: 'abg 10/12/2017 10:51:10'!
cabinDoorClosed
	^cabinDoor cabinDoorClosedWhenAlreadyClosed.! !

!CabinDoorStateClosed methodsFor: 'operations' stamp: 'abg 10/12/2017 16:19:16'!
cabinDoorOpened
	! !

!CabinDoorStateClosed methodsFor: 'operations' stamp: 'abg 10/12/2017 15:35:25'!
closeCabinDoor
	! !

!CabinDoorStateClosed methodsFor: 'operations' stamp: 'abg 10/12/2017 15:31:31'!
openCabinDoor
	cabinDoor openCabinDoorWhenNotOpenned .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CabinDoorStateClosed class' category: #'Elevator-Ejercicio'!
CabinDoorStateClosed class
	instanceVariableNames: ''!

!CabinDoorStateClosed class methodsFor: 'as yet unclassified' stamp: 'abg 10/12/2017 10:59:41'!
canHandle: aCabinDoor
	^aCabinDoor isCabinDoorClosed.! !


!classDefinition: #CabinDoorStateClosing category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #CabinDoorStateClosing
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!


!CabinDoorStateClosing methodsFor: 'operations' stamp: 'abg 10/12/2017 10:54:35'!
cabinDoorClosed
	^ cabinDoor cabinDoorClosedWhenClosing.! !

!CabinDoorStateClosing methodsFor: 'operations' stamp: 'abg 10/12/2017 16:19:27'!
cabinDoorOpened
	! !

!CabinDoorStateClosing methodsFor: 'operations' stamp: 'abg 10/12/2017 15:35:31'!
closeCabinDoor
	 ! !

!CabinDoorStateClosing methodsFor: 'operations' stamp: 'abg 10/12/2017 15:33:27'!
openCabinDoor
	cabinDoor openCabinDoorWhenNotOpenned .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CabinDoorStateClosing class' category: #'Elevator-Ejercicio'!
CabinDoorStateClosing class
	instanceVariableNames: ''!

!CabinDoorStateClosing class methodsFor: 'as yet unclassified' stamp: 'abg 10/12/2017 10:59:48'!
canHandle: aCabinDoor

	^aCabinDoor isCabinDoorClosing. ! !


!classDefinition: #CabinDoorStateOpen category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #CabinDoorStateOpen
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!


!CabinDoorStateOpen methodsFor: 'operations' stamp: 'abg 10/12/2017 16:19:48'!
cabinDoorClosed
	! !

!CabinDoorStateOpen methodsFor: 'operations' stamp: 'abg 10/12/2017 16:19:51'!
cabinDoorOpened
	! !

!CabinDoorStateOpen methodsFor: 'operations' stamp: 'abg 10/12/2017 15:14:57'!
closeCabinDoor
	cabinDoor closeCabinDoorWhenNotOpening .! !

!CabinDoorStateOpen methodsFor: 'operations' stamp: 'abg 10/12/2017 15:37:51'!
openCabinDoor
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CabinDoorStateOpen class' category: #'Elevator-Ejercicio'!
CabinDoorStateOpen class
	instanceVariableNames: ''!

!CabinDoorStateOpen class methodsFor: 'as yet unclassified' stamp: 'abg 10/12/2017 10:59:55'!
canHandle: aCabinDoor

	^aCabinDoor isCabinDoorOpened ! !


!classDefinition: #CabinDoorStateOpening category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #CabinDoorStateOpening
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!


!CabinDoorStateOpening methodsFor: 'operations' stamp: 'abg 10/12/2017 16:20:01'!
cabinDoorClosed
	! !

!CabinDoorStateOpening methodsFor: 'operations' stamp: 'abg 10/12/2017 16:20:08'!
cabinDoorOpened
	! !

!CabinDoorStateOpening methodsFor: 'operations' stamp: 'abg 10/12/2017 15:36:22'!
closeCabinDoor
	 ! !

!CabinDoorStateOpening methodsFor: 'operations' stamp: 'abg 10/12/2017 15:36:53'!
openCabinDoor
	 ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CabinDoorStateOpening class' category: #'Elevator-Ejercicio'!
CabinDoorStateOpening class
	instanceVariableNames: ''!

!CabinDoorStateOpening class methodsFor: 'as yet unclassified' stamp: 'abg 10/12/2017 10:59:59'!
canHandle: aCabinDoor

	^aCabinDoor isCabinDoorOpening ! !


!classDefinition: #CabinState category: #'Elevator-Ejercicio'!
Object subclass: #CabinState
	instanceVariableNames: 'cabin'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinState methodsFor: 'init' stamp: 'abg 10/12/2017 12:48:22'!
initialize: aCabin
	cabin:= aCabin.
	
	! !


!CabinState methodsFor: 'operations' stamp: 'abg 10/12/2017 15:09:33'!
closeCabinDoor
	self subclassResponsibility .! !

!CabinState methodsFor: 'operations' stamp: 'abg 10/12/2017 13:13:52'!
onFloor: aFloor
	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CabinState class' category: #'Elevator-Ejercicio'!
CabinState class
	instanceVariableNames: ''!

!CabinState class methodsFor: 'as yet unclassified' stamp: 'abg 10/12/2017 12:51:27'!
canHandle: aCabin

	self subclassResponsibility ! !

!CabinState class methodsFor: 'as yet unclassified' stamp: 'abg 10/12/2017 12:47:14'!
for: aCabin
	^ self new initialize: aCabin.
! !

!CabinState class methodsFor: 'as yet unclassified' stamp: 'abg 10/12/2017 12:47:37'!
stateFor: aCabin

	^(self subclasses detect: [:aCabinState | aCabinState canHandle: aCabin]) for: aCabin.! !


!classDefinition: #CabinStateMoving category: #'Elevator-Ejercicio'!
CabinState subclass: #CabinStateMoving
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinStateMoving methodsFor: 'operations' stamp: 'abg 10/12/2017 15:57:32'!
closeCabinDoor
! !

!CabinStateMoving methodsFor: 'operations' stamp: 'abg 10/12/2017 13:13:13'!
onFloor: aFloor
	^cabin onFloorWhenMoving: aFloor.! !

!CabinStateMoving methodsFor: 'operations' stamp: 'abg 10/12/2017 15:39:03'!
openCabinDoor
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CabinStateMoving class' category: #'Elevator-Ejercicio'!
CabinStateMoving class
	instanceVariableNames: ''!

!CabinStateMoving class methodsFor: 'as yet unclassified' stamp: 'abg 10/12/2017 12:54:57'!
canHandle: aCabin

	^aCabin isCabinMoving.! !


!classDefinition: #CabinStateStopped category: #'Elevator-Ejercicio'!
CabinState subclass: #CabinStateStopped
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinStateStopped methodsFor: 'operations' stamp: 'abg 10/12/2017 15:10:00'!
closeCabinDoor
	cabin closeCabinDoorIfStopped .! !

!CabinStateStopped methodsFor: 'operations' stamp: 'abg 10/12/2017 13:13:41'!
onFloor: aFloor
	^cabin onFloorWhenStopped.! !

!CabinStateStopped methodsFor: 'operations' stamp: 'abg 10/12/2017 15:25:43'!
openCabinDoor
	cabin openCabinDoorWhenStopped .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CabinStateStopped class' category: #'Elevator-Ejercicio'!
CabinStateStopped class
	instanceVariableNames: ''!

!CabinStateStopped class methodsFor: 'as yet unclassified' stamp: 'abg 10/12/2017 12:54:38'!
canHandle: aCabin

	^aCabin isCabinStopped.! !


!classDefinition: #ElevatorController category: #'Elevator-Ejercicio'!
Object subclass: #ElevatorController
	instanceVariableNames: 'state cabin floorsToGo'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorController methodsFor: 'accion' stamp: 'abg 10/12/2017 16:56:02'!
cabinDoorClosed
    floorsToGo isEmpty ifTrue: [ ElevatorEmergency doorDesinchronized].

	^ cabin cabinDoorClosed .
	
! !

!ElevatorController methodsFor: 'accion' stamp: 'abg 10/12/2017 09:49:02'!
cabinDoorClosedWhenThereAreFloorsToGo
	^ cabin cabinDoorClosed.! !

!ElevatorController methodsFor: 'accion' stamp: 'abg 10/12/2017 09:48:34'!
cabinDoorClosedWhenThereAreNotFloorsToGo 
 ^ ElevatorEmergency doorDesinchronized .! !

!ElevatorController methodsFor: 'accion' stamp: 'abg 10/12/2017 16:56:08'!
cabinDoorOpened

	floorsToGo isEmpty ifTrue: [self onStateIdle].
	

	cabin cabinDoorOpened.
	
! !

!ElevatorController methodsFor: 'accion' stamp: 'abg 10/12/2017 16:10:05'!
cabinOnFloor: aFloor
	cabin onFloor: aFloor

! !

!ElevatorController methodsFor: 'accion' stamp: 'abg 10/12/2017 16:10:32'!
closeCabinDoor
	
	self state closeCabinDoor.
	
! !

!ElevatorController methodsFor: 'accion' stamp: 'abg 10/12/2017 15:01:03'!
closeCabinDoorIfElevatorIsWorking
	cabin closeCabinDoor.! !

!ElevatorController methodsFor: 'accion' stamp: 'abg 10/12/2017 16:56:17'!
goUpPushedFromFloor: aFloorNumber
	floorsToGo addLast: aFloorNumber.
	cabin closeCabinDoor .
	self onStateWorking .
	
	! !

!ElevatorController methodsFor: 'accion' stamp: 'abg 10/12/2017 13:31:48'!
onStateIdle
	state := 'idle'.! !

!ElevatorController methodsFor: 'accion' stamp: 'abg 10/12/2017 16:55:53'!
onStateWorking
	state := 'working'.! !

!ElevatorController methodsFor: 'accion' stamp: 'abg 10/12/2017 16:10:45'!
openCabinDoor
	cabin openCabinDoor .
! !

!ElevatorController methodsFor: 'accion' stamp: 'abg 10/12/2017 13:21:20'!
removeThisFloorIfItIsInFloorsToGo: aFloor

	[floorsToGo includes: aFloor ] value
	ifTrue:[floorsToGo remove: aFloor] .! !

!ElevatorController methodsFor: 'accion' stamp: 'abg 10/12/2017 16:10:53'!
waitForPeopleTimedOut
	cabin closeCabinDoor.! !


!ElevatorController methodsFor: 'state' stamp: 'abg 10/12/2017 15:53:25'!
state
	^ElevatorState stateFor: self.! !


!ElevatorController methodsFor: 'test' stamp: 'abg 10/10/2017 08:00:54'!
cabinFloorNumber
	^ cabin cabinFloorNumber .! !

!ElevatorController methodsFor: 'test' stamp: 'abg 10/10/2017 02:57:33'!
isCabinDoorClosed
	^cabin isCabinDoorClosed .! !

!ElevatorController methodsFor: 'test' stamp: 'abg 10/10/2017 02:57:29'!
isCabinDoorClosing
	^cabin isCabinDoorClosing .! !

!ElevatorController methodsFor: 'test' stamp: 'abg 10/10/2017 02:57:24'!
isCabinDoorOpened
	^cabin isCabinDoorOpened.! !

!ElevatorController methodsFor: 'test' stamp: 'abg 10/10/2017 02:57:18'!
isCabinDoorOpening
	^cabin isCabinDoorOpening .! !

!ElevatorController methodsFor: 'test' stamp: 'abg 10/10/2017 02:57:09'!
isCabinMoving
	^cabin isCabinMoving.! !

!ElevatorController methodsFor: 'test' stamp: 'abg 10/10/2017 02:57:04'!
isCabinStopped
	^cabin isCabinStopped.! !

!ElevatorController methodsFor: 'test' stamp: 'abg 10/10/2017 02:57:37'!
isCabinWaitingForPeople
	^cabin isCabinWaitingForPeople.! !

!ElevatorController methodsFor: 'test' stamp: 'abg 10/10/2017 09:30:01'!
isFloorsToGoEmpty
	^ floorsToGo isEmpty.! !

!ElevatorController methodsFor: 'test' stamp: 'abg 10/10/2017 09:30:59'!
isFloorsToGoNotEmpty
	^ floorsToGo notEmpty .! !

!ElevatorController methodsFor: 'test' stamp: 'M 10/2/2017 17:21:48'!
isIdle
	^ state = 'idle'.! !

!ElevatorController methodsFor: 'test' stamp: 'M 10/2/2017 15:54:02'!
isWorking
	^self isIdle  not.! !


!ElevatorController methodsFor: 'init' stamp: 'abg 10/10/2017 09:16:55'!
initialize
	state := 'idle'.
	floorsToGo  := OrderedCollection new.
	cabin := Cabin of: self.
	
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ElevatorController class' category: #'Elevator-Ejercicio'!
ElevatorController class
	instanceVariableNames: ''!

!ElevatorController class methodsFor: 'as yet unclassified' stamp: 'abg 10/10/2017 02:18:35'!
new
	|anElevatorController|
	anElevatorController := super new initialize.
	^anElevatorController ! !


!classDefinition: #ElevatorState category: #'Elevator-Ejercicio'!
Object subclass: #ElevatorState
	instanceVariableNames: 'elevator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorState methodsFor: 'init' stamp: 'abg 10/12/2017 14:48:14'!
initialize: anElevator
	elevator := anElevator.
	
	! !


!ElevatorState methodsFor: 'operations' stamp: 'abg 10/12/2017 15:01:51'!
closeCabinDoor
	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ElevatorState class' category: #'Elevator-Ejercicio'!
ElevatorState class
	instanceVariableNames: ''!

!ElevatorState class methodsFor: 'as yet unclassified' stamp: 'abg 10/12/2017 14:48:14'!
canHandle: anElevator

	self subclassResponsibility ! !

!ElevatorState class methodsFor: 'as yet unclassified' stamp: 'abg 10/12/2017 14:48:14'!
for: anElevator
	^ self new initialize: anElevator .
! !

!ElevatorState class methodsFor: 'as yet unclassified' stamp: 'abg 10/12/2017 14:48:14'!
stateFor: anElevator

	^(self subclasses detect: [:anElevatorFloorsToGoState | anElevatorFloorsToGoState canHandle: anElevator ]) for: anElevator! !


!classDefinition: #ElevatorStateIdle category: #'Elevator-Ejercicio'!
ElevatorState subclass: #ElevatorStateIdle
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorStateIdle methodsFor: 'operations' stamp: 'abg 10/12/2017 15:49:46'!
closeCabinDoor
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ElevatorStateIdle class' category: #'Elevator-Ejercicio'!
ElevatorStateIdle class
	instanceVariableNames: ''!

!ElevatorStateIdle class methodsFor: 'as yet unclassified' stamp: 'abg 10/12/2017 15:55:55'!
canHandle: anElevator

	^anElevator isIdle. ! !


!classDefinition: #ElevatorStateWorking category: #'Elevator-Ejercicio'!
ElevatorState subclass: #ElevatorStateWorking
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorStateWorking methodsFor: 'operations' stamp: 'abg 10/12/2017 15:48:30'!
closeCabinDoor
	elevator closeCabinDoorIfElevatorIsWorking ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ElevatorStateWorking class' category: #'Elevator-Ejercicio'!
ElevatorStateWorking class
	instanceVariableNames: ''!

!ElevatorStateWorking class methodsFor: 'as yet unclassified' stamp: 'abg 10/12/2017 15:55:59'!
canHandle: anElevator

	^anElevator isWorking. ! !
