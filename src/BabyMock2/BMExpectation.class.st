"
Represents an expected or unexpected message send towards a target object. The carinalities, message arguments, receiver, and the answer can be defined separately.
It provides testing messages to determine whether it is appropriate to invoke the expectation. The invocation will return the specifed answer.
"
Class {
	#name : #BMExpectation,
	#superclass : #Object,
	#instVars : [
		'actions',
		'invocationCounter',
		'sideEffects',
		'objectMatcher',
		'cardinality',
		'messageMatcher',
		'stateExpectation'
	],
	#category : #'BabyMock2-Core'
}

{ #category : #'instance creation' }
BMExpectation class >> define [
	^ self new
]

{ #category : #'expectation setup' }
BMExpectation >> addAction: aBlock [
	actions add: aBlock
]

{ #category : #'expectation setup' }
BMExpectation >> addSideEffect: aBlockClosure [ 
	"Add a separate side effect (e.g. state transition) to the method.
	Side effects can be executed by sending the sideEffect message."
	
	sideEffects add: aBlockClosure 
]

{ #category : #private }
BMExpectation >> allowsInvocation [
	^ self allowsMoreInvocation and: [ self allowsInvocationNow ]
]

{ #category : #private }
BMExpectation >> allowsInvocationNow [
	^ stateExpectation satisfied
]

{ #category : #private }
BMExpectation >> allowsMoreInvocation [
	^ cardinality allowsMoreInvocation: invocationCounter
]

{ #category : #private }
BMExpectation >> answerTo: argumentsArray [
	^ self
		ifMultipleActionsLeft: [ self consumeActions: argumentsArray ] 
		ifOneActionLeft: [ self keepRepeatingAction: argumentsArray ] 
		ifNoActionSet: [ self defaultAnswer ]

]

{ #category : #'expectation setup' }
BMExpectation >> argumentMatcher: anArgumentMatcher [
	messageMatcher argumentMatcher: anArgumentMatcher.
]

{ #category : #'expectation setup' }
BMExpectation >> cardinality: aBMCardinality [
	cardinality := aBMCardinality
]

{ #category : #private }
BMExpectation >> consumeActions: argumentsArray [
	^ actions removeFirst valueWithPossibleArgs: argumentsArray
]

{ #category : #private }
BMExpectation >> defaultAnswer [ 
	^ nil
]

{ #category : #private }
BMExpectation >> describeInvocationTo: aDescription [
	invocationCounter = 0
		ifTrue: 
			[ aDescription 
				appendValue: 'never';
				appendText: ' received' ]
		ifFalse: [ 
			aDescription
				appendText: 'already received ';
				appendValue: invocationCounter asString, ' times' ]
]

{ #category : #'self describing' }
BMExpectation >> describeMessageTo: aDescription [
	messageMatcher describeTo: aDescription
]

{ #category : #'self describing' }
BMExpectation >> describeMismatch: aDescription message: aMessage from: anObject [ 
	((objectMatcher matchesObject: anObject)
		and: [ messageMatcher selectorMatcher matchesSelector: aMessage selector ])
		ifTrue:
			[ aDescription
				newLine;
				appendText: ' - '.			
			self describeTo: aDescription.
			aDescription 
				newLine;
				appendText: '    '.
			messageMatcher 
				describeMismatch: aDescription 
				arguments: aMessage arguments.
			stateExpectation satisfied
				ifFalse: 
					[aDescription
						newLine;
						appendText: '    '.
					stateExpectation describeMismatch: aDescription ] ].
]

{ #category : #private }
BMExpectation >> describeObjectTo: aDescription [
	objectMatcher describeTo: aDescription.
]

{ #category : #'self describing' }
BMExpectation >> describeTo: aDescription [
	cardinality describeTo: aDescription.
	aDescription appendText: ', '.	
	self describeInvocationTo: aDescription.
	aDescription appendText: ' '.
	self describeObjectTo: aDescription.
	aDescription appendText: ' '.
	self describeMessageTo: aDescription.
	stateExpectation describeTo: aDescription.
]

{ #category : #'expectation setup' }
BMExpectation >> expectedStateIs: stateStateNameAssociation [
	"Add a prerequisite (state -> #expectedStateName) to the method.
	Prerequisite are evaluated during invoke."
	stateExpectation := BMStateExpectation 
		state: stateStateNameAssociation key
		is: stateStateNameAssociation value.

]

{ #category : #testing }
BMExpectation >> hasMessage: aMessage fromObject: anObject [
	^ (objectMatcher matchesObject: anObject) and: 
		[ (messageMatcher matchesMessage: aMessage) ]
]

{ #category : #private }
BMExpectation >> ifMultipleActionsLeft: multipleActionsBlock ifOneActionLeft: oneActionBlock ifNoActionSet: noActionBlock [
	actions size = 1 
		ifTrue: [ ^ oneActionBlock value ].
	actions 
		ifEmpty: [ ^ noActionBlock value ]
		ifNotEmpty: [ ^ multipleActionsBlock value ].
]

{ #category : #initialization }
BMExpectation >> initialize [
	super initialize.
	actions := OrderedCollection new.
	messageMatcher := BMMessageMatcher new.
	sideEffects := OrderedCollection new.
	stateExpectation := BMNullStateExpectation.
	invocationCounter := 0.
]

{ #category : #invoking }
BMExpectation >> invoke: argumentsArray [
	^ self 
		recordInvocation;
		answerTo: argumentsArray
]

{ #category : #private }
BMExpectation >> keepRepeatingAction: argumentsArray [
	^ actions first valueWithPossibleArgs: argumentsArray
]

{ #category : #testing }
BMExpectation >> matchesMessage: aMessage fromObject: anObject [
	^ (self hasMessage: aMessage fromObject: anObject) 
		and: [ self allowsInvocation ]
]

{ #category : #testing }
BMExpectation >> matchesObject: anObject [
	^ objectMatcher matchesObject: anObject
]

{ #category : #'expectation setup' }
BMExpectation >> objectMatcher: aBMObjectMatcher [
	objectMatcher := aBMObjectMatcher
]

{ #category : #printing }
BMExpectation >> printOn: aStream [
	aStream nextPutAll: (BMDescription asString: self) 
]

{ #category : #private }
BMExpectation >> recordInvocation [
	invocationCounter := invocationCounter + 1.
]

{ #category : #testing }
BMExpectation >> satisfied [
	^ cardinality satisfied: invocationCounter
]

{ #category : #'expectation setup' }
BMExpectation >> selectorMatcher: aBMSelectorMatcher [
	messageMatcher selectorMatcher: aBMSelectorMatcher.
]

{ #category : #invoking }
BMExpectation >> sideEffect [
	^ sideEffects do: #value
]
