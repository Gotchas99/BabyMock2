"
A simple, animated horizontal arrow with 2 source and target object.
"
Class {
	#name : #BMHorizontalArrow,
	#superclass : #Object,
	#instVars : [
		'color',
		'arrow',
		'senderObjectMorph',
		'receiverObjectMorph',
		'slotNumber'
	],
	#category : #'BabyMock2-GUI'
}

{ #category : #'instance creation' }
BMHorizontalArrow class >> fromMorph: fromMorph toMorph: toMorph slotNumber: aNumber color: aColor [
	^ self new 
		setSenderMorph: fromMorph
		receiverMorph: toMorph
		slotNumber: aNumber
		color: aColor
]

{ #category : #'display box access' }
BMHorizontalArrow >> boundingBox [
	| from to |
	from := self startPoint min: self endPoint.
	to := self startPoint max: self endPoint.	
	^ (from corner: to) expandBy: 6
]

{ #category : #drawing }
BMHorizontalArrow >> drawOn: aCanvas upTo: limit whenPassedHalfWay: aBlock [
	| currentDistance currentEndPoint canvas |
	canvas := aCanvas asBalloonCanvas aaLevel: 5.
		
	currentDistance := self length * limit.
	currentEndPoint := (self startPoint x + currentDistance)@(self startPoint y).

	canvas line: self startPoint to: currentEndPoint width: 1 color: color.
	limit > 0.2 ifTrue: [ arrow drawArrowOn: canvas at: currentEndPoint from: self startPoint ].
	limit > 0.5 ifTrue: [ aBlock value: self midPoint - (0@18) ].
]

{ #category : #private }
BMHorizontalArrow >> endPoint [
	^ receiverObjectMorph getSlot: slotNumber
]

{ #category : #private }
BMHorizontalArrow >> length [
	^ self endPoint x - self startPoint x
]

{ #category : #private }
BMHorizontalArrow >> midPoint [ 
	^ (self startPoint x + (self length / 2))@(self startPoint y).
]

{ #category : #initialization }
BMHorizontalArrow >> setSenderMorph: senderMorph  receiverMorph: receiverMorph slotNumber: aNumber color: aColor [ 
	senderObjectMorph := senderMorph.
	receiverObjectMorph := receiverMorph.
	color := aColor.
	slotNumber := aNumber.
	arrow := LineMorph new 
		color: color;
		borderColor: color;
		beSmoothCurve;
		arrowSpec: 4@4; 
		yourself.	
	^ self
]

{ #category : #private }
BMHorizontalArrow >> startPoint [
	^ senderObjectMorph getSlot: slotNumber
]
