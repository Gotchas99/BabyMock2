"
I decide what to do with a message received by a mock object. I select then invoke the matching expectation if any and report announcements about the message sends and responses. In case of no matching expectation I will report an unexpected message. I can be tested to determine whether any expectation was unsatisfied.
"
Class {
	#name : #BMMessageDispatcher,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'expectations',
		'lastUnexpected'
	],
	#category : #'BabyMock2-Core'
}

{ #category : #'expectation collector' }
BMMessageDispatcher >> addExpectation: anExpectation [
	expectations add: anExpectation
]

{ #category : #announcements }
BMMessageDispatcher >> announcer [
	^ announcer
]

{ #category : #verification }
BMMessageDispatcher >> assertSatisfied [
	| description |
	description := BMTextDescription new.
	expectations reject: #satisfied thenDo: 
		[ :each | 
		announcer announce: (BMUnsatisfiedExpectation expectation: each).
		each describeTo: description.
		description 
			appendText: '. ';
			newLine].
	description hasDescription 
		ifTrue: [ BMExpectationError signal: description asText asString ]
]

{ #category : #'self describing' }
BMMessageDispatcher >> describeTo: aDescription [ 
	^ lastUnexpected 
		ifNil: 
			[ expectations 
				do: [ :each | each describeTo: aDescription ]
				separatedBy: 
					[ aDescription 
						appendText: '.'; 
						newLine ] ]
		ifNotNil: 
			[ self 
				describeUnexpectedMessage: lastUnexpected first 
				from: lastUnexpected second 
				to: aDescription ]

]

{ #category : #private }
BMMessageDispatcher >> describeUnexpectedMessage: aMessage from: aMessageProxy [
	| description |
	description := BMTextDescription new.
	self describeUnexpectedMessage: aMessage from: aMessageProxy to: description.
	^ description asText asString
]

{ #category : #private }
BMMessageDispatcher >> describeUnexpectedMessage: aMessage from: aMessageProxy to: aDescription [
	aDescription
		appendText: 'Unexpected message ';
		appendReceiver: aMessageProxy asString;
		space;
		appendMessage: aMessage.
	expectations do: 
		[ :each | each 			
			describeMismatch: aDescription
			message: aMessage 
			from: aMessageProxy ].
]

{ #category : #'expectation collector' }
BMMessageDispatcher >> expectationsOn: anObject [
	^ expectations select: [ :each | each matchesObject: anObject ].
]

{ #category : #'initialize-release' }
BMMessageDispatcher >> initialize [ 
	super initialize.
	announcer := Announcer new.
	expectations := OrderedCollection new.
]

{ #category : #private }
BMMessageDispatcher >> isObjectMessage: aMessage neverExpectedFrom: aMessageProxy [
	^ (Object new respondsTo: aMessage selector)
		and: [ expectations noneSatisfy: 
				[ :each | each 
					hasMessage: aMessage 
					fromObject: aMessageProxy ] ]
]

{ #category : #private }
BMMessageDispatcher >> matched: anExpectation message: aMessage from: senderObject toMock: aMessageProxy [	
	[ | answer |	
		answer := anExpectation invoke: aMessage arguments.
		self mock: aMessageProxy replied: answer toMessage: aMessage from: senderObject.
		anExpectation sideEffect.
		^ answer 
	] on: Exception do: 
		[ :ex | 
		self mock: aMessageProxy repliedException: ex toMessage: aMessage from: senderObject.			
		ex pass ]
]

{ #category : #'mock message interceptor' }
BMMessageDispatcher >> mock: aMessageProxy received: aMessage from: aMethodContext [
	^ expectations
		detect: 
			[ :each | each matchesMessage: aMessage fromObject: aMessageProxy ]
		ifFound: 
			[ :expectation | 
			self
				matched: expectation
				message: aMessage
				from: aMethodContext sender
				toMock: aMessageProxy ]
		ifNone: 
			[ self 
				mock: aMessageProxy 
				receivedUnexpected: aMessage 
				from: aMethodContext ]
]

{ #category : #private }
BMMessageDispatcher >> mock: aMessageProxy receivedUnexpected: aMessage from: aMethodContext [
	^ (self isObjectMessage: aMessage neverExpectedFrom: aMessageProxy)
		ifTrue: 
			[ aMessage sendTo: aMessageProxy babyMockIdentity ]
		ifFalse: 
			[ lastUnexpected := {aMessage. aMessageProxy}.	"TODO extract"
			announcer announce: (BMUnexpectedMessage 
				from: aMethodContext sender 
				to: aMessageProxy 
				message: aMessage).
			BMExpectationError signal: (self 
				describeUnexpectedMessage: aMessage 
				from: aMessageProxy) ]
]

{ #category : #private }
BMMessageDispatcher >> mock: aMessageProxy replied: answer toMessage: aMessage from: aMethodContext [
	announcer announce: 
		(BMExpectedMessage 
			from: aMethodContext 
			to: aMessageProxy
			message: aMessage).
	answer	ifNotNil:
		[ announcer announce: 
			(BMMessageAnswer 
				from: aMessageProxy
				to: aMethodContext 
				response: answer
				inReplyTo: aMessage) ]			
]

{ #category : #private }
BMMessageDispatcher >> mock: aMessageProxy repliedException: anException toMessage: aMessage from: aMethodContext [
	announcer announce: 
		(BMExpectedMessage 
			from: aMethodContext 
			to: aMessageProxy 
			message: aMessage).
	announcer announce: 
		(BMMessageException 
			from: aMessageProxy
			to: aMethodContext
			response: anException
			inReplyTo: aMessage).
]
