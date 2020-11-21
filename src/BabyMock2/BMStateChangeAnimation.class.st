"
Animates state change.
"
Class {
	#name : #BMStateChangeAnimation,
	#superclass : #TextMorph,
	#instVars : [
		'stateChange',
		'animationListener',
		'stopwatch',
		'objectMorph'
	],
	#category : #'BabyMock2-GUI'
}

{ #category : #animation }
BMStateChangeAnimation >> animate [		
	stopwatch duration > 1 seconds
		ifTrue: [ self showNewState ].
		
	stopwatch duration > 2 seconds 
		ifTrue: 
			[ self stopSteppingAnimation.
			animationListener animationFinished: self ].
	
	self location: objectMorph.
	self changed.
	
]

{ #category : #animation }
BMStateChangeAnimation >> animationListener: anAnimationListener [
	animationListener := anAnimationListener
]

{ #category : #private }
BMStateChangeAnimation >> animationSelector [
	^ #animate
]

{ #category : #animation }
BMStateChangeAnimation >> beginAnimation [	
	self visible: true.
	self showOldState.
	self startSteppingAnimation.
]

{ #category : #animation }
BMStateChangeAnimation >> endAnimationAndSelect: aBoolean [
	self showNewState.	
	self stopSteppingAnimation.
	self location: objectMorph.
	self postEndAnimation: aBoolean.
]

{ #category : #'initialize-release' }
BMStateChangeAnimation >> initialize [ 
	super initialize.
	self visible: false.
	self borderWidth: 1;
		margins: 1;
		backgroundColor: BMColorScheme backgroundColor;
		borderColor: Color black.
	stopwatch := Stopwatch new.
]

{ #category : #abstract }
BMStateChangeAnimation >> location: anObjectMorph [
	^ self subclassResponsibility 
]

{ #category : #'change reporting' }
BMStateChangeAnimation >> ownerChanged [
	self location: objectMorph.
	^ super ownerChanged
]

{ #category : #abstract }
BMStateChangeAnimation >> postEndAnimation: isSelected [
	^ self subclassResponsibility 
]

{ #category : #animation }
BMStateChangeAnimation >> resetAnimation [
	self stopSteppingAnimation.	
	self visible: false.
	self showOldState.
]

{ #category : #private }
BMStateChangeAnimation >> showNewState [
	| stream | 
	stream := TextStream on: Text new.
	stream 
		withAttribute: BMColorScheme valueColor do: [ stream nextPutAll: stateChange stateName ];		
		withAttribute: BMColorScheme textColor do: [ stream nextPutAll: ' changed from ' ];	
		withAttribute: BMColorScheme valueColor do: [ stream nextPutAll: stateChange oldState ];
		withAttribute: BMColorScheme textColor do: [ stream nextPutAll: ' to ' ];		
		withAttributes: {TextEmphasis underlined. BMColorScheme valueColor} do: [ stream nextPutAll: stateChange newState ].
	self contents: stream contents
]

{ #category : #private }
BMStateChangeAnimation >> showOldState [
	| stream |
	stream := TextStream on: Text new.
	stream 
		withAttribute: BMColorScheme valueColor do: [ stream nextPutAll: stateChange stateName ];		
		withAttribute: BMColorScheme textColor do: [ stream nextPutAll: ' changed from ' ];	
		withAttributes: {BMColorScheme valueColor. TextEmphasis underlined} do: [ stream nextPutAll: stateChange oldState ];
		withAttribute: BMColorScheme textColor do: [ stream nextPutAll: ' to ' ];		
		withAttribute: BMColorScheme valueColor do: [ stream nextPutAll: stateChange newState ].
	self contents: stream contents.
]

{ #category : #private }
BMStateChangeAnimation >> startSteppingAnimation [
	self startSteppingSelector: self animationSelector.
	stopwatch activate.
]

{ #category : #animation }
BMStateChangeAnimation >> stepTime [
	^ 250
]

{ #category : #private }
BMStateChangeAnimation >> stopSteppingAnimation [
	self stopSteppingSelector: self animationSelector.
	stopwatch reset.
]
