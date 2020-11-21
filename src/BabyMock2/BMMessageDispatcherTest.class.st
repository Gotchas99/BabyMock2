Class {
	#name : #BMMessageDispatcherTest,
	#superclass : #BabyMock2TestCase,
	#instVars : [
		'subscriber',
		'dispatcher',
		'mock'
	],
	#category : #'BabyMock2-Core-Tests'
}

{ #category : #private }
BMMessageDispatcherTest >> answerInteraction: anObject [ 
	^ [:matchingArg | 		
			matchingArg class = BMMessageAnswer and: [
			(matchingArg matchesSender: mock) and: [
			(matchingArg matchesReceiver: self) and: [
			matchingArg payload = anObject ]]]]

]

{ #category : #private }
BMMessageDispatcherTest >> exceptionInteraction: exceptionClass [
	^ [:matchingArg | 
			matchingArg class = BMMessageException and: [
			(matchingArg matchesSender: mock) and: [
			(matchingArg matchesReceiver: self) and: [
			matchingArg payload class = exceptionClass]]]]

]

{ #category : #private }
BMMessageDispatcherTest >> expect: aSymbol [
	| expectation |	
	expectation := BMExpectation define
		cardinality: (BMCardinality exactly: 1);
		selectorMatcher: (BMSelectorMatcher selector: aSymbol);
		objectMatcher: (BMObjectMatcher sameAs: mock).
	dispatcher addExpectation: expectation.
	^ expectation
]

{ #category : #private }
BMMessageDispatcherTest >> messageInteraction: aByteSymbol [
	^ [:matchingArg | 
			matchingArg class = BMExpectedMessage and: [
			(matchingArg matchesSender: self) and: [
			(matchingArg matchesReceiver: mock) and: [
			matchingArg payload selector = aByteSymbol]]]]

]

{ #category : #private }
BMMessageDispatcherTest >> missingInteraction: aByteSymbol [
	^ [:matchingArg | 
			matchingArg class = BMUnsatisfiedExpectation and: [
			(matchingArg matchesReceiver: mock) and: [
			matchingArg asString = aByteSymbol]]]

]

{ #category : #private }
BMMessageDispatcherTest >> sendToDispatcher: aMessage [
	dispatcher mock: mock received: aMessage from: thisContext.
]

{ #category : #running }
BMMessageDispatcherTest >> setUp [
	subscriber := protocol mock: 'subscriber'.
	dispatcher := BMMessageDispatcher new.
	mock := BMMockIdentity 
		named: 'targetMock' 
		proxy: nil 
		expectationCollector: nil.
	dispatcher announcer 
		when: BMExpectedMessage send: #message: to: subscriber;
		when: BMMessageAnswer send: #answer: to: subscriber;		
		when: BMUnsatisfiedExpectation send: #missing: to: subscriber;
		when: BMMessageException send: #exception: to: subscriber;
		when: BMUnexpectedMessage send: #unexpected: to: subscriber.										

]

{ #category : #private }
BMMessageDispatcherTest >> stub: aSymbol answer: anObject [
	| expectation |	
	expectation := BMExpectation define
		cardinality: BMCardinality anyNumberOfTimes;
		selectorMatcher: (BMSelectorMatcher selector: aSymbol);
		objectMatcher: (BMObjectMatcher sameAs: mock);
		addAction: [ anObject ].
	dispatcher addExpectation: expectation.
	^ expectation
]

{ #category : #private }
BMMessageDispatcherTest >> stub: aSymbol arg: anObject [
	| expectation |	
	expectation := BMExpectation define
		cardinality: BMCardinality anyNumberOfTimes;
		selectorMatcher: (BMSelectorMatcher selector: aSymbol);
		argumentMatcher: anObject asBabyMockArgumentMatcher;
		objectMatcher: (BMObjectMatcher sameAs: mock).
	dispatcher addExpectation: expectation.
	^ expectation
]

{ #category : #private }
BMMessageDispatcherTest >> stub: aSymbol signal: anExceptionClass [
	| expectation |	
	expectation := BMExpectation define
		cardinality: BMCardinality anyNumberOfTimes;
		selectorMatcher: (BMSelectorMatcher selector: aSymbol);
		objectMatcher: (BMObjectMatcher sameAs: mock);
		addAction: [ anExceptionClass signal ].
	dispatcher addExpectation: expectation.
	^ expectation
]

{ #category : #'test - describing' }
BMMessageDispatcherTest >> testDescribingExpectations [
	| description |
	dispatcher := BMMessageDispatcher new.
	self expect: #mocked.
	self stub: #stubbed answer: 'any'.			
	2 timesRepeat: [ self sendToDispatcher: (Message selector: #stubbed) ].
	description := BMDescription asString: dispatcher.
	
	self assert: (description includesSubstring: 
		'expected once, never received targetMock mocked').		
	self assert: (description includesSubstring: 
		'allowed, already received 2 times targetMock stubbed').	
]

{ #category : #'tests - notification' }
BMMessageDispatcherTest >> testNotifesSubscriberAboutMessagesAndAnswers [
	self stub: #msg answer: 42.
	protocol describe
		once: subscriber recv: #message:; with: (self messageInteraction: #msg);
		once: subscriber recv: #answer:; with: (self answerInteraction: 42).
	self sendToDispatcher: (Message selector: #msg).
]

{ #category : #'tests - notification' }
BMMessageDispatcherTest >> testNotifesSubscriberAboutMissingInteraction [
	self expect: #msg:.
	protocol describe
		once: subscriber recv: #missing:; 
		with: (self missingInteraction: #msg:).
	self should: [dispatcher assertSatisfied] raise: BMExpectationError.
]

{ #category : #'tests - notification' }
BMMessageDispatcherTest >> testNotifesSubscriberAboutMockExceptionThenPropagatesIt [
	self stub: #msg signal: Warning.
	protocol describe
		allow: subscriber recv: #message:;
		once: subscriber recv: #exception:; 
			with: (self exceptionInteraction: Warning).
	self should: [ self sendToDispatcher: (Message selector: #msg) ] raise: Warning.
	
]

{ #category : #'tests - notification' }
BMMessageDispatcherTest >> testNotifesSubscriberAboutMultipleMissingInteraction [
	self expect: #msg1:.
	self expect: #msg2:.	
	protocol describe
		once: subscriber recv: #missing:; with: (self missingInteraction: #msg1:);
		once: subscriber recv: #missing:; with: (self missingInteraction: #msg2:).		
	self should: [dispatcher assertSatisfied] raise: BMExpectationError.
]

{ #category : #'tests - notification' }
BMMessageDispatcherTest >> testNotifesSubscriberAboutUnexpectInteraction [
	protocol describe
		once: subscriber recv: #unexpected:; 
			with: (self unexpectedInteraction: #msg).
			
	self 
		should: [self sendToDispatcher: (Message selector: #msg)]
		raise: BMExpectationError 
]

{ #category : #private }
BMMessageDispatcherTest >> unexpectedInteraction: aByteSymbol [
	^ [ :matchingArg | 
			matchingArg class = BMUnexpectedMessage and: [
			(matchingArg matchesSender: self) and: [
			(matchingArg matchesReceiver: mock) and: [
			matchingArg payload selector = aByteSymbol]]]]

]
