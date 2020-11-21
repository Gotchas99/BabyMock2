"
I hold the context of the whole test execution, including the mock objects and the expectations defined on them. I can create mock objects add expectations and verify them after the test was executed. However, a convenient syntax wrapper should be used to access to my functionalities. See the Syntax package for more information.
"
Class {
	#name : #BabyMock,
	#superclass : #Object,
	#instVars : [
		'dispatcher',
		'visualizedObject',
		'mockery',
		'errorTranslator',
		'testResult',
		'testListener'
	],
	#category : #'BabyMock2-Core'
}

{ #category : #'instance creation' }
BabyMock class >> forSUnit [
	^ self new setErrorTranslator: BMSUnitErrorTranslator
]

{ #category : #'expectation collector' }
BabyMock >> addExpectation: anExpectation [
	dispatcher addExpectation: anExpectation
]

{ #category : #verification }
BabyMock >> assertSatisfied [
	[ dispatcher assertSatisfied ]
		on: BMExpectationError 
		do: [ :ex | errorTranslator translateError: ex ]
]

{ #category : #mockery }
BabyMock >> createMockNamed: nameString [
	| mock |
	mock := mockery newMockNamed: nameString.
	testResult addMock: mock.
	^ mock

]

{ #category : #mockery }
BabyMock >> createStatesNamed: stateName initialState: initialStateSymbol [
	| state |
	state := BMState name: stateName startsAs: initialStateSymbol.
	state announcer when: BMStateChange send: #addInteraction: to: testResult.
	^ state
]

{ #category : #private }
BabyMock >> ensureCanBeVisualized: anObjectUnderTest [
	visualizedObject 
		ifNotNil: [ Error signal: 'Visual model already enabled' ].
	
	anObjectUnderTest ifNil: 
		[ BMMockError signal: 'Object under test is nil' ].
	
	(anObjectUnderTest isKindOf: TestCase)
		ifTrue: [ BMMockError signal: 'Invalid argument. Expected the object under test.' ].
		
	(anObjectUnderTest isKindOf: BMMockIdentity)
		ifTrue: [ BMMockError signal: 'Invalid argument. Expected the object under test.' ]
]

{ #category : #private }
BabyMock >> objectUnderTestReceived: aBMRequest [
	(aBMRequest isDebuggerGenerated not 
		and: [aBMRequest matchesSender: testResult testCase]) 
			ifTrue: [testResult addInteraction: aBMRequest]
]

{ #category : #private }
BabyMock >> objectUnderTestResponded: aBMResponse [
	(aBMResponse isDebuggerGenerated not 
		and: [aBMResponse matchesReceiver: testResult testCase]) 
			ifTrue: [testResult addInteraction: aBMResponse]
]

{ #category : #initialization }
BabyMock >> setErrorTranslator: anErrorTranslator [
	errorTranslator := anErrorTranslator.
	testResult := BMTestResult new.	
	testListener := BMNullTestListener.
	dispatcher := BMMessageDispatcher new.
	mockery := BMMockery messageDispatcher: dispatcher errorTranslator: anErrorTranslator.
	dispatcher announcer 	
		"XXX override sender/receiver because it may be messageForwarder"
		when: BMRequest do: [:i | i senderObject: testResult objectUnderTest. testResult addInteraction: i];
		when: BMResponse do: [:i | i receiverObject: testResult objectUnderTest. testResult addInteraction: i ] ;
		when: BMUnsatisfiedExpectation do: [:i | i senderObject: testResult objectUnderTest. testResult addInteraction: i ].		
	^ self		
]

{ #category : #private }
BabyMock >> testCaseEnded: aBoolean [
	| description |
	testResult passed: aBoolean.	
	description := BMTextDescription new.
	dispatcher describeTo: description.
	testResult description: description.				
	testListener 
		testOf: visualizedObject 
		finished: testResult
]

{ #category : #private }
BabyMock >> testCaseStarted: aBabyMock2TestCase [
	testResult testCase: aBabyMock2TestCase
]

{ #category : #mockery }
BabyMock >> visualizeObjectUnderTest: anObject [
	| interceptor |
	self ensureCanBeVisualized: anObject.	
	testListener := BMSpecVisualizer.
	interceptor := BMMessageForwarder new.
	interceptor announcer when: BMRequest send: #objectUnderTestReceived: to: self.
	interceptor announcer when: BMResponse send: #objectUnderTestResponded: to: self.
	visualizedObject := BMMessageProxy replaceWithProxy: anObject withInterceptor: interceptor.	
	testResult objectUnderTest: visualizedObject.
]
