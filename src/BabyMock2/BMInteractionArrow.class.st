"
Represents a message between objects.
"
Class {
	#name : #BMInteractionArrow,
	#superclass : #Morph,
	#instVars : [
		'animationProgress',
		'selected',
		'senderObjectMorph',
		'receiverObjectMorph',
		'curve',
		'interaction',
		'text',
		'animationListener',
		'stopwatch'
	],
	#category : #'BabyMock2-GUI'
}

{ #category : #private }
BMInteractionArrow >> addLabel: aText help: helpString [
	text contents: (self trimText: aText to: 50).
	text contents string = helpString 
		ifFalse: [text setBalloonText: helpString maxLineLength: 600].
	self addMorph: text.
]

{ #category : #animation }
BMInteractionArrow >> animate [
	animationProgress + self animationIncrement <= 1
		ifTrue: 
			[ animationProgress := animationProgress + self animationIncrement ]
		ifFalse: 
			[ self animationTimeElapsed 
				ifTrue: 
					[ self stopSteppingAnimation.
					animationProgress := 1.
					animationListener animationFinished: self ] ].		
	self changed
]

{ #category : #private }
BMInteractionArrow >> animationIncrement [
	^ 0.10
]

{ #category : #animation }
BMInteractionArrow >> animationListener: anAnimationListener [
	animationListener := anAnimationListener
]

{ #category : #private }
BMInteractionArrow >> animationSelector [
	^ #animate
]

{ #category : #private }
BMInteractionArrow >> animationTimeElapsed [
	^ stopwatch duration > 0.9 seconds
]

{ #category : #animation }
BMInteractionArrow >> beginAnimation [
	self selected: true.
	self visible: true.
	animationProgress := 0.
	self startSteppingAnimation.
]

{ #category : #private }
BMInteractionArrow >> createLabel [
	^ TextMorph new
		borderWidth: 1;
		margins: 1;
		backgroundColor: BMColorScheme backgroundColor;
		borderColor: Color black;
		on: #click send: #openInBrowser to: self;
		on: #mouseEnter send: #highlight: to: self;
		on: #mouseLeave send: #nohighlight: to: self;
		yourself
]

{ #category : #abstract }
BMInteractionArrow >> drawOn: aCanvas [
	self subclassResponsibility.
]

{ #category : #animation }
BMInteractionArrow >> endAnimationAndSelect: aBoolean [
	self visible: true.
	self selected: aBoolean.
	animationProgress := 1.
	self stopSteppingAnimation.
]

{ #category : #actions }
BMInteractionArrow >> highlight: anEvent [
	text borderColor: Color green.
]

{ #category : #'initialize-release' }
BMInteractionArrow >> initialize [
	super initialize.
	stopwatch := Stopwatch new.
	animationProgress := 0.
	selected := false.
	text := self createLabel.
	text visible: false.
]

{ #category : #actions }
BMInteractionArrow >> nohighlight: anEvent [
	text borderColor: Color black.
]

{ #category : #actions }
BMInteractionArrow >> openInBrowser [
	interaction openInBrowser 
]

{ #category : #animation }
BMInteractionArrow >> resetAnimation [
	animationProgress := 0.
	self stopSteppingAnimation.	
	self visible: false.
	self selected: false.
]

{ #category : #private }
BMInteractionArrow >> selected: aBoolean [
	selected := aBoolean.
	selected ifFalse: [ text visible: false ].
]

{ #category : #private }
BMInteractionArrow >> showLabel: aPoint [
	text center: aPoint; visible: true
]

{ #category : #private }
BMInteractionArrow >> startSteppingAnimation [
	self startSteppingSelector: self animationSelector.
	stopwatch activate.
]

{ #category : #animation }
BMInteractionArrow >> stepTime [
	^ 37
]

{ #category : #private }
BMInteractionArrow >> stopSteppingAnimation [
	self stopSteppingSelector: self animationSelector.
	stopwatch reset.
]

{ #category : #'as yet unclassified' }
BMInteractionArrow >> trimText: aText to: anInteger [ 
	| trimmed |
	^ aText size > anInteger
		ifTrue: 
			[ trimmed := aText copyFrom: 1 to: anInteger - 4.
			trimmed 
				append: ' ...';
				yourself ]
		ifFalse: 
			[ aText ]
]
