"
A visual representation of an object in a collaboration diagram.
"
Class {
	#name : #BMCollaborationObject,
	#superclass : #Morph,
	#instVars : [
		'object',
		'numberOfIncomingMessages',
		'caption',
		'box'
	],
	#category : #'BabyMock2-GUI'
}

{ #category : #'instance creation' }
BMCollaborationObject class >> fromObject: anObject [
	^ self new 
		setObject: anObject 
]

{ #category : #private }
BMCollaborationObject >> addBox [
	box := BorderedMorph new.	
	box 
		extent: 28@28;
		useGradientFill;
		borderWidth: 1;
		borderColor: self defaultBorderColor.
	box fillStyle colorRamp: {0.0 -> Color gray . 1.0 -> Color veryLightGray  }.
	box fillStyle radial: true.						
	self addMorphCentered: box.
]

{ #category : #private }
BMCollaborationObject >> addCaption [
	caption := TextMorph new.	
	caption contents: object displayedObjectName.		
	caption center: self center x@(self bottom + 10).
	caption textColor: BMColorScheme receiverColor color.
	self addMorph: caption.

]

{ #category : #accessing }
BMCollaborationObject >> defaultBorderColor [
	^ Color gray
]

{ #category : #accessing }
BMCollaborationObject >> incNumberOfIncomingMessages [
	numberOfIncomingMessages := numberOfIncomingMessages + 1.
]

{ #category : #accessing }
BMCollaborationObject >> numberOfIncomingMessages [
	^ numberOfIncomingMessages
]

{ #category : #actions }
BMCollaborationObject >> onMouseClicked: mousePoint [
	(box containsPoint: mousePoint) ifTrue: [ object browse ]
]

{ #category : #actions }
BMCollaborationObject >> onMouseMoved: mousePoint [
	(box containsPoint: mousePoint)
		ifTrue:
			[ box borderColor: Color green.	
			self showBalloon: object longPrintString ]
		ifFalse:
			[ box borderColor: self defaultBorderColor ]
]

{ #category : #initialization }
BMCollaborationObject >> setObject: anObject [
	object := anObject.
	numberOfIncomingMessages := 0.			
	self color: Color transparent.
	self extent: 28@28.
	self addBox.
	self addCaption.
	
	
]
