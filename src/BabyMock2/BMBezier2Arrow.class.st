"
Calculates the points of a bezier curve with one control point.
"
Class {
	#name : #BMBezier2Arrow,
	#superclass : #Object,
	#instVars : [
		'controlPoint',
		'arrow',
		'color',
		'source',
		'destination'
	],
	#category : #'BabyMock2-GUI'
}

{ #category : #'instance creation' }
BMBezier2Arrow class >> fromMorph: sourceMorph viaPoint: aPoint toMorph: destinationMorph color: aColor [
	^ self new 
		setSenderMorph: sourceMorph 
		controlPoint: aPoint 
		receiverMorph: destinationMorph
		color: aColor
]

{ #category : #'display box access' }
BMBezier2Arrow >> boundingBox [
	| points xs ys |
	points := { source center. destination center. controlPoint }.	
	xs := points collect: #x.
	ys := points collect: #y.	
	^ (xs min @ ys min corner: xs max @ ys max) expandBy: 6
	
]

{ #category : #drawing }
BMBezier2Arrow >> drawOn: aCanvas viaPoint: aPoint upTo: limit whenPassedHalfWay: aBlock [
	| last llast lineSplit canvas |	
	controlPoint := aPoint.	
	canvas := aCanvas asBalloonCanvas aaLevel: 5.
	lineSplit := source center + (destination center - source center /2).
	
	(self valuesUpTo: limit step: 0.1) do: [:current |
		((source containsPoint: current)  or: [destination containsPoint: current ])
			ifFalse: [
				last ifNotNil: [ canvas  line: last to: current width: 1 color: color ].		
				(current onLineFrom: lineSplit to: controlPoint within: 3) 
					ifTrue: [ aBlock value: current ].			
			llast := last.
			last := current.									
		].
	].			
	llast ifNotNil: [ arrow drawArrowOn: canvas at: last from: llast ].
]

{ #category : #initialization }
BMBezier2Arrow >> setSenderMorph: senderMorph controlPoint: aPoint receiverMorph: receiverMorph color: aColor [ 
	source := senderMorph.
	destination := receiverMorph.
	controlPoint := aPoint.
	color := aColor.
	arrow := LineMorph new 
		color: color;
		borderColor: color;
		beSmoothCurve; 
		arrowSpec: 4@4; 
		yourself.	
	^ self
]

{ #category : #calculation }
BMBezier2Arrow >> valueAt: t [
	(t between: 0 and: 1)
		ifTrue: [		
			^ ((1 - t) squared * source center) + (2 * t * (1 - t) * controlPoint) + (t squared * destination center).
		] ifFalse: [				
			Error signal: 't must be in [0..1]'
		]
]

{ #category : #calculation }
BMBezier2Arrow >> valuesUpTo: limit step: step [	
	^ (Interval from: 0 to: limit by: step) collect: [:t | 
		self valueAt: t.
	]
]
