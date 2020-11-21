"
A visual representation of an object in a sequence diagram.
"
Class {
	#name : #BMSequenceObject,
	#superclass : #Morph,
	#instVars : [
		'totalSlots',
		'object',
		'box',
		'numberOfIncomingMessages',
		'caption'
	],
	#category : #'BabyMock2-GUI'
}

{ #category : #'instance creation' }
BMSequenceObject class >> fromObject: anObject [
	^ self new setObject: anObject
]

{ #category : #private }
BMSequenceObject >> addBox [
	box := BorderedMorph new.
	box
		hResizing: #spaceFill; 
		borderColor: self defaultBorderColor;
		height: 28;
		borderWidth: 1;
		useGradientFill.	
	box fillStyle colorRamp: {0.0 -> Color gray . 1.0 -> Color veryLightGray }.
	box fillStyle radial: true.					
	self addMorph: box.					

]

{ #category : #private }
BMSequenceObject >> addCaption [	
	caption := TextMorph new.
	caption 
		contentsWrapped: object displayedObjectName;
		textColor: BMColorScheme receiverColor color.
	box addMorph: caption.
]

{ #category : #private }
BMSequenceObject >> defaultBorderColor [
	^ Color gray
]

{ #category : #drawing }
BMSequenceObject >> drawOn: aCanvas [		
	aCanvas line: box center to: (box center x)@self bottom width: 3 color: Color darkGray.	
	caption width: (box width min: (caption textStyle defaultFont widthOfString: caption contents)).
	caption center: box center.
]

{ #category : #accessing }
BMSequenceObject >> getSlot: slotNumber [
	^ self messageLine topLeft x@(self messageLine topLeft y + (self messageLine height / totalSlots * slotNumber)) .
]

{ #category : #accessing }
BMSequenceObject >> incNumberOfIncomingMessages [
	numberOfIncomingMessages := numberOfIncomingMessages + 1
]

{ #category : #private }
BMSequenceObject >> messageLine [
	| msgTop yOffset |
	yOffset := (2 * box height) + 8.
	msgTop := self top + yOffset.
	^ self center x@msgTop extent: 0@(self height - yOffset).
]

{ #category : #accessing }
BMSequenceObject >> numberOfIncomingMessages [
	^ numberOfIncomingMessages
]

{ #category : #actions }
BMSequenceObject >> onMouseClicked: mousePoint [
	(box containsPoint: mousePoint) ifTrue: [ object browse ]
]

{ #category : #actions }
BMSequenceObject >> onMouseMoved: mousePoint [
	(box containsPoint: mousePoint)
		ifTrue: 
			[ box borderColor: Color green.
			self showBalloon: object longPrintString ]
		ifFalse: 
			[ box borderColor: self defaultBorderColor ]
]

{ #category : #initialization }
BMSequenceObject >> setObject: anObject [
	object := anObject.
	totalSlots := 10.	
	numberOfIncomingMessages := 0.
	self layoutPolicy: TableLayout new.
	self listDirection: #topToBottom.		
	self addBox.
	self addCaption.
]

{ #category : #accessing }
BMSequenceObject >> totalSlots: aNumber [
	totalSlots := aNumber.
]
