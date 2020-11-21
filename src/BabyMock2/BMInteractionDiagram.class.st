"
Abstract class which implements generic functions about displaying interaction diagrams.
"
Class {
	#name : #BMInteractionDiagram,
	#superclass : #BorderedMorph,
	#instVars : [
		'layout',
		'objectMorphs',
		'player',
		'testResult'
	],
	#category : #'BabyMock2-GUI'
}

{ #category : #private }
BMInteractionDiagram >> addAnimatedMoroh: morph [
	player addAnimation: morph.
	self addMorph: morph.
]

{ #category : #'adding interactions' }
BMInteractionDiagram >> addAnswer: aBmInteractionAnswer [
	self visualizeResponse: aBmInteractionAnswer color: Color green darker
]

{ #category : #'adding interactions' }
BMInteractionDiagram >> addException: aBmInteractionException [
	self visualizeResponse: aBmInteractionException color: Color yellow darker
]

{ #category : #'adding interactions' }
BMInteractionDiagram >> addMessage: aBmInteractionMessage [
	self visualizeMessage: aBmInteractionMessage color: Color green darker
]

{ #category : #abstract }
BMInteractionDiagram >> addMessageInteraction: aBMInteraction from: senderMorph to: receiverMorph color: aColor [
	^ self subclassResponsibility 
]

{ #category : #'adding interactions' }
BMInteractionDiagram >> addMissingMessage: aBmMissingInteraction [
	self visualizeMessage: aBmMissingInteraction color: Color veryLightGray
]

{ #category : #abstract }
BMInteractionDiagram >> addMockObject: anObject [
	^ self subclassResponsibility
]

{ #category : #abstract }
BMInteractionDiagram >> addResponseInteraction: aBMInteraction from: senderMorph to: receiverMorph color: aColor [
	^ self subclassResponsibility 

]

{ #category : #abstract }
BMInteractionDiagram >> addStateChange: aBmStateChange [
	self subclassResponsibility 
]

{ #category : #abstract }
BMInteractionDiagram >> addSutObject: anObject [
	^ self subclassResponsibility
]

{ #category : #abstract }
BMInteractionDiagram >> addTestObject: anObject [
	^ self subclassResponsibility
]

{ #category : #'adding interactions' }
BMInteractionDiagram >> addUnexpectedMessage: aBmUnexpectedInteraction [
	self visualizeMessage: aBmUnexpectedInteraction color: Color red
]

{ #category : #'events-processing' }
BMInteractionDiagram >> clickedOnMe: anEvent [
	objectMorphs values 
		detect: [ :each | each containsPoint: anEvent cursorPoint ]
		ifFound: [ :morph | morph onMouseClicked: anEvent cursorPoint ]

]

{ #category : #private }
BMInteractionDiagram >> getReceiverMorph: anInteraction [
	| key |
	key := objectMorphs keys detect: [ :each | anInteraction matchesReceiver: each ].
	^ objectMorphs at: key.
]

{ #category : #private }
BMInteractionDiagram >> getSenderMorph: anInteraction [
	| key |
	key := objectMorphs keys detect: [ :each | anInteraction matchesSender: each ].
	^ objectMorphs at: key.
]

{ #category : #'interaction-diagram' }
BMInteractionDiagram >> goToBeginning [
	player goToBeginning.
	self changed.	
	
]

{ #category : #'interaction-diagram' }
BMInteractionDiagram >> goToEnd [
	player goToEnd.
	self changed.	
	
]

{ #category : #'events-processing' }
BMInteractionDiagram >> handleMouseMove: anEvent [
	objectMorphs values do: 
		[ :each | each onMouseMoved: anEvent cursorPoint ]

]

{ #category : #initialization }
BMInteractionDiagram >> initGui [
	self borderWidth: 0.
	self borderColor: Color black.
	self fillStyle: Color white.

]

{ #category : #initialization }
BMInteractionDiagram >> initialize [
	super initialize.
	self initGui.
	self reset.
	self on: #click send: #clickedOnMe: to: self.	
]

{ #category : #private }
BMInteractionDiagram >> layoutChanged [ 
	super layoutChanged.
	layout ifNotNil: [ layout layout: self ].
]

{ #category : #abstract }
BMInteractionDiagram >> newLayout [
	^ self subclassResponsibility 
]

{ #category : #'interaction-diagram' }
BMInteractionDiagram >> playOrPauseAnimation [
	player toogleAnimation.
	self changed.
]

{ #category : #private }
BMInteractionDiagram >> reset [
	layout := self newLayout.
	player := BMPlayer new.
	objectMorphs := Dictionary new.	
	self removeAllMorphs.
]

{ #category : #'interaction-diagram' }
BMInteractionDiagram >> stepBackward [
	player stepBackward.	
	self changed.		
]

{ #category : #'interaction-diagram' }
BMInteractionDiagram >> stepForward [
	player stepForward.		
	self changed.
]

{ #category : #'adding interactions' }
BMInteractionDiagram >> testResult: aBMTestResult [
	testResult := aBMTestResult.
	self reset.
	self addTestObject: testResult testCase.
	self addSutObject: testResult objectUnderTest.
	testResult eachMock: [ :mock | self addMockObject: mock ].
	testResult eachInteraction: [ :interaction | interaction addTo: self ].																																											
	bounds := self defaultBounds. "XXX for some reason the animation is not visible without this"
]

{ #category : #private }
BMInteractionDiagram >> visualizeMessage: aBMInteraction color: aColor [
	self 
		addMessageInteraction: aBMInteraction
		from: (self getSenderMorph: aBMInteraction)
		to: (self getReceiverMorph: aBMInteraction)
		color: aColor
]

{ #category : #private }
BMInteractionDiagram >> visualizeResponse: aBMInteraction color: aColor [
	self
		addResponseInteraction: aBMInteraction
		from: (self getSenderMorph: aBMInteraction)
		to: (self getReceiverMorph: aBMInteraction)
		color: aColor
]
