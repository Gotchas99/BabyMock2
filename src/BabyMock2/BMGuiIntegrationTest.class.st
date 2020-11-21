Class {
	#name : #BMGuiIntegrationTest,
	#superclass : #BabyMock2TestCase,
	#instVars : [
		'mock',
		'sut',
		'expectedInteractions'
	],
	#category : #'BabyMock2-GUI-Tests'
}

{ #category : #testing }
BMGuiIntegrationTest class >> isAbstract [ 
	^ self name = #BMGuiIntegrationTest
]

{ #category : #testing }
BMGuiIntegrationTest class >> shouldInheritSelectors [
	^ true
]

{ #category : #private }
BMGuiIntegrationTest >> afterPerformTest [
	"do not check context automatically"
]

{ #category : #private }
BMGuiIntegrationTest >> eventually: aBlockClosure [ 
	| tries |
	tries := 0.
	aBlockClosure whileFalse: [ 
		(Delay forMilliseconds: 100) wait.
		aBlockClosure value.
		tries := tries + 1.
		tries >= 5 ifTrue: [ BMTestFailure signal: 'Timeouted: ', aBlockClosure asString ] ]
]

{ #category : #private }
BMGuiIntegrationTest >> exceptedException: messageString from: senderObjet to: receiverObject withIndex: aNumber [
	^ self matchInteraction: messageString 
				type: BMMessageException
				from: senderObjet 
				to: receiverObject 
				withIndex: aNumber
]

{ #category : #private }
BMGuiIntegrationTest >> expectedAnswer: messageString from: senderObjet to: receiverObject withIndex: aNumber [
	^ self matchInteraction: messageString 
				type: BMMessageAnswer
				from: senderObjet 
				to: receiverObject 
				withIndex: aNumber
]

{ #category : #private }
BMGuiIntegrationTest >> expectedMessage: messageString from: senderObjet to: receiverObject withIndex: aNumber [
	^ self matchInteraction: messageString 
				type: BMExpectedMessage 
				from: senderObjet 
				to: receiverObject 
				withIndex: aNumber
]

{ #category : #private }
BMGuiIntegrationTest >> findDiagram [
	| diag |
	self eventually: [		
		diag := BMSpecVisualizer mainWindow diagrams collaborationDiagram.
		diag notNil ].
	^ diag
]

{ #category : #private }
BMGuiIntegrationTest >> findInteractions [				
	^ self findDiagram submorphs
		select: [:each | each isKindOf: BMInteractionArrow ].	

]

{ #category : #private }
BMGuiIntegrationTest >> matchInteraction: messageString type: aClass from: senderObjet to: receiverObject withIndex: aNumber [
	^ [:interaction :index |
			(interaction isKindOf: aClass) &
			(interaction asString includesSubstring: messageString) &
			(interaction matchesSender: senderObjet) &
			(interaction matchesReceiver: receiverObject) &
			(index = aNumber) ]
]

{ #category : #private }
BMGuiIntegrationTest >> missingMessage: messageString from: senderObjet to: receiverObject withIndex: aNumber [
	^ [:interaction :index |
			(interaction isKindOf: BMUnsatisfiedExpectation) &
			(interaction asString = messageString) &
			(interaction matchesReceiver: receiverObject) &
			(index = aNumber) ]
]

{ #category : #abstract }
BMGuiIntegrationTest >> postSetupContext: aBmMockery objectUnderTest: objectUnderTest [
	^ self subclassResponsibility 
]

{ #category : #abstract }
BMGuiIntegrationTest >> preTestContext: aBmMockery objectUnderTest: objectUnderTest [
	^ self subclassResponsibility 
]

{ #category : #running }
BMGuiIntegrationTest >> setUp [
	BMSpecVisualizer reset.
	expectedInteractions := OrderedCollection new.
	mock := protocol mock: 'mock'.
	sut := BMTestSUT new
		mock: mock;
		yourself.
	self postSetupContext: protocol objectUnderTest: sut.
]

{ #category : #running }
BMGuiIntegrationTest >> tearDown [
	| currentInteraction matched |
	self findInteractions reverseDo: [:each |
		currentInteraction := (each instVarNamed: 'interaction').
		matched := expectedInteractions removeFirst 
				value: currentInteraction value: (each instVarNamed: 'index').	
		matched ifFalse: [ BMTestFailure signal: 'Unmatched interaction: ', currentInteraction asString ] .
	].
	expectedInteractions ifNotEmpty: [ BMTestFailure signal: 'No more interaction should remain' ]
]

{ #category : #tests }
BMGuiIntegrationTest >> testThatItHandlesDirectThanIndirectMockMessages [
	self preTestContext: protocol objectUnderTest: sut.
	expectedInteractions 
		add: (self expectedMessage: 'delegate: #direct' from: self to: sut withIndex: 0);
		add: (self expectedMessage: #direct from: sut to: mock withIndex: 0);
		add: (self expectedMessage: 'delegateThroughIntermediateObject: #indirect' from: self to: sut withIndex: 1);		
		add: (self expectedMessage: #indirect from: sut to: mock withIndex: 1);
		add: (self expectedAnswer: '42' from: mock to: sut withIndex: 1);
		add: (self expectedAnswer: '42' from: sut to: self withIndex: 1).		
	protocol describe
		allow: mock recv: #direct;
		allow: mock recv: #indirect; => 42.
	sut delegate: #direct.
	sut delegateThroughIntermediateObject: #indirect.
]

{ #category : #tests }
BMGuiIntegrationTest >> testThatItHandlesIndirectThanDirectMockMessages [
	self preTestContext: protocol objectUnderTest: sut.
	expectedInteractions 
		add: (self expectedMessage: 'delegateThroughIntermediateObject: #indirect' from: self to: sut withIndex: 0);			
		add: (self expectedMessage: #indirect from: sut to: mock withIndex: 0);
		add: (self expectedAnswer: '42' from: mock to: sut withIndex: 0);
		add: (self expectedAnswer: '42' from: sut to: self withIndex: 0);		
		add: (self expectedMessage: 'delegate: #direct' from: self to: sut withIndex: 1);
		add: (self expectedMessage: #direct from: sut to: mock withIndex: 1).
	protocol describe
		allow: mock recv: #direct;
		allow: mock recv: #indirect; => 42.
	sut delegateThroughIntermediateObject: #indirect.		
	sut delegate: #direct.
]

{ #category : #tests }
BMGuiIntegrationTest >> testThatItIgnoresIndirecSUTMessages [
	self preTestContext: protocol objectUnderTest: sut.
	(Message selector: #testQuery) sendTo: sut.
]

{ #category : #tests }
BMGuiIntegrationTest >> testThatItIncrementsIndexes [
	self preTestContext: protocol objectUnderTest: sut.
	expectedInteractions 
		add: (self expectedMessage: 'delegate: #fromSutToMock' from: self to: sut withIndex: 0);
		add: (self expectedMessage: #fromSutToMock from: sut to: mock withIndex: 0);				
		add: (self expectedAnswer: '42' from: mock to: sut withIndex: 0);										
		add: (self expectedAnswer: '42' from: sut to: self withIndex: 0);
		add: (self expectedMessage: 'delegate: #fromSutToMock' from: self to: sut withIndex: 1);		
		add: (self expectedMessage: #fromSutToMock from: sut to: mock withIndex: 1);
		add: (self expectedAnswer: '42' from: mock to: sut withIndex: 1);					
		add: (self expectedAnswer: '42' from: sut to: self withIndex: 1).							
	protocol describe
		allow: mock recv: #fromSutToMock; => 42.
	sut delegate: #fromSutToMock.
	sut delegate: #fromSutToMock.
]

{ #category : #tests }
BMGuiIntegrationTest >> testThatItShowsMessages [
	self preTestContext: protocol objectUnderTest: sut.
	expectedInteractions 
		add: (self expectedMessage: 'delegate: #fromSutToMock' from: self to: sut withIndex: 0);
		add: (self expectedMessage: #fromSutToMock from: sut to: mock withIndex: 0).
	protocol describe
		allow: mock recv: #fromSutToMock.
	sut delegate: #fromSutToMock.		
]

{ #category : #tests }
BMGuiIntegrationTest >> testThatItShowsMissingInteractions [
	self preTestContext: protocol objectUnderTest: sut.
	protocol describe
		once: mock recv: #fromSutToMock.
	expectedInteractions add: (self missingMessage: 'fromSutToMock' from: sut to: mock withIndex: 0).				
	self should: [ babyMock assertSatisfied ] raise: BMTestFailure.
]

{ #category : #tests }
BMGuiIntegrationTest >> testThatItShowsStateViolation [
	| state |
	self preTestContext: protocol objectUnderTest: sut.
	state := protocol states: #state startsAs: #init.
	protocol describe
		once: mock recv: #fromSutToMock; when: state is: #expected.
	expectedInteractions 
		add: (self expectedMessage: 'delegate: #fromSutToMock' from: self to: sut withIndex: 0);
		add: (self unexpectedInteraction: #fromSutToMock from: sut to: mock withIndex: 0);
		add: (self exceptedException: 'state mismatched: init, wanted: expected' from: sut to: self withIndex: 0).
		
	self should: [ sut delegate: #fromSutToMock ] raise: BMTestFailure.
]

{ #category : #tests }
BMGuiIntegrationTest >> testThatItShowsTooMuchInteractions [
	self preTestContext: protocol objectUnderTest: sut.
	protocol describe
		once: mock recv: #fromSutToMock.
	expectedInteractions 
		add: (self expectedMessage: 'delegate: #fromSutToMock' from: self to: sut withIndex: 0);
		add: (self expectedMessage: #fromSutToMock from: sut to: mock withIndex: 0);		
		add: (self expectedMessage: 'delegate: #fromSutToMock' from: self to: sut withIndex: 1);				
		add: (self unexpectedInteraction: #fromSutToMock from: sut to: mock withIndex: 1);
		add: (self exceptedException: 'expected once, already received 1 times mock fromSutToMock' from: sut to: self withIndex: 1).
		
	sut delegate: #fromSutToMock.
	self should: [ sut delegate: #fromSutToMock ] raise: BMTestFailure.
]

{ #category : #tests }
BMGuiIntegrationTest >> testThatItShowsUnexpectedInteractions [
	self preTestContext: protocol objectUnderTest: sut.
	expectedInteractions 
		add: (self expectedMessage: 'delegate: #fromSutToMock' from: self to: sut withIndex: 0);
		add: (self unexpectedInteraction: #fromSutToMock from: sut to: mock withIndex: 0);
		add: (self exceptedException: 'fromSutToMock' from: sut to: self withIndex: 0).
		
	self should: [ sut delegate: #fromSutToMock ] raise: BMTestFailure.
]

{ #category : #private }
BMGuiIntegrationTest >> unexpectedInteraction: messageString from: senderObjet to: receiverObject withIndex: aNumber [
	^ self matchInteraction: messageString 
				type: BMUnexpectedMessage
				from: senderObjet 
				to: receiverObject 
				withIndex: aNumber
]
