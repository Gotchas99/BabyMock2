"
I'm the built-in syntax object that can create and configure expectations on mock objects.
"
Class {
	#name : #BMCascadeSyntax,
	#superclass : #Object,
	#instVars : [
		'currentExpectation',
		'expectations'
	],
	#category : #'BabyMock2-Syntax'
}

{ #category : #'instance creation' }
BMCascadeSyntax class >> expectationCollector: expectationCollector [
	^ self new setExpectationCollector: expectationCollector
]

{ #category : #'expectations - response' }
BMCascadeSyntax >> => anObject [	
	currentExpectation addAction: 
		(anObject isBlock
			ifTrue: [ anObject ] 
			ifFalse: [ [anObject] ]).
]

{ #category : #'expectations - cardinality' }
BMCascadeSyntax >> allow: mock recv: aSymbol [ 
	^ self 
		expect: mock 
		toReceive: aSymbol 
		times: BMCardinality anyNumberOfTimes
]

{ #category : #verification }
BMCascadeSyntax >> assertSatisfied [
	expectations assertSatisfied
]

{ #category : #'expectations - cardinality' }
BMCascadeSyntax >> atLeast: minNumber atMost: maxNumber times: mock recv: aSymbol [
	^ self 
		expect: mock 
		toReceive: aSymbol 
		times: (BMCardinality between: minNumber and: maxNumber)

]

{ #category : #'expectations - cardinality' }
BMCascadeSyntax >> atLeast: minNumber times: mock recv: aSymbol [
	^ self 
		expect: mock 
		toReceive: aSymbol 
		times: (BMCardinality atLeast: minNumber)

]

{ #category : #'expectations - cardinality' }
BMCascadeSyntax >> atMost: maxNumber times: mock recv: aSymbol [
	^ self 
		expect: mock 
		toReceive: aSymbol 
		times: (BMCardinality atMost: maxNumber)

]

{ #category : #'reflective operations' }
BMCascadeSyntax >> doesNotUnderstand: aMessage [
	| sender |
	sender := thisContext sender receiver.
	^ (sender respondsTo: aMessage selector) 
		ifTrue: [ aMessage sendTo: sender ]
		ifFalse: [ super doesNotUnderstand: aMessage ]
]

{ #category : #'expectations - cardinality' }
BMCascadeSyntax >> exactly: aNumber times: mock recv: aSymbol [
	^ self 
		expect: mock 
		toReceive: aSymbol 
		times: (BMCardinality exactly: aNumber)

]

{ #category : #private }
BMCascadeSyntax >> expect: aMessageProxy toReceive: aSymbol times: aCardinality [
	currentExpectation := BMExpectation define
		objectMatcher: (BMObjectMatcher sameAs: aMessageProxy);	
		selectorMatcher: aSymbol asBabyMockSelectorMatcher;
		cardinality: aCardinality;
		yourself.
	expectations addExpectation: currentExpectation.	
	^ self
]

{ #category : #'expectations - cardinality' }
BMCascadeSyntax >> ignore: mock [
	^ self 
		expect: mock 
		toReceive: Anything 
		times: BMCardinality anyNumberOfTimes
]

{ #category : #'expectations - cardinality' }
BMCascadeSyntax >> never: mock recv: aSymbol [
	^ self 
		expect: mock 
		toReceive: aSymbol 
		times: BMCardinality never
]

{ #category : #'expectations - cardinality' }
BMCascadeSyntax >> once: mock recv: aSymbol [
	^ self 
		expect: mock 
		toReceive: aSymbol 
		times: (BMCardinality exactly: 1)
]

{ #category : #initialization }
BMCascadeSyntax >> setExpectationCollector: expectationCollector [
	expectations := expectationCollector.
	^ self
]

{ #category : #'expectations - response' }
BMCascadeSyntax >> signals: anErrorClass [
	currentExpectation addAction: [anErrorClass signal].
]

{ #category : #'expectations - states' }
BMCascadeSyntax >> then: aBmState is: aSymbol [
	currentExpectation addSideEffect: [ aBmState changeState: aSymbol ].
]

{ #category : #'expectations - cardinality' }
BMCascadeSyntax >> twice: mock recv: aSymbol [
	^ self 
		expect: mock 
		toReceive: aSymbol 
		times: (BMCardinality exactly: 2)
]

{ #category : #'expectations - states' }
BMCascadeSyntax >> when: aBmState is: aSymbol [
	currentExpectation expectedStateIs: aBmState -> aSymbol.
]

{ #category : #'expectations - arguments' }
BMCascadeSyntax >> with: anObject [
	currentExpectation argumentMatcher: anObject asBabyMockArgumentMatcher
]

{ #category : #'expectations - arguments' }
BMCascadeSyntax >> with: anObject1 and: anObject2 [
	| matcher |
	matcher := BMManyArgMatcher withMatchers: { 
		anObject1 asBabyMockArgumentMatcher. 
		anObject2 asBabyMockArgumentMatcher.
	}.
     currentExpectation argumentMatcher: matcher.
]

{ #category : #'expectations - arguments' }
BMCascadeSyntax >> with: anObject1 and: anObject2 and: anObject3 [
	| matcher |
	matcher := BMManyArgMatcher withMatchers: { 
		anObject1 asBabyMockArgumentMatcher. 
		anObject2 asBabyMockArgumentMatcher.
		anObject3 asBabyMockArgumentMatcher.		
	}.
     currentExpectation argumentMatcher: matcher.
]

{ #category : #'expectations - arguments' }
BMCascadeSyntax >> with: anObject1 and: anObject2 and: anObject3 and: anObject4 [
	| matcher |
	matcher := BMManyArgMatcher withMatchers: { 
		anObject1 asBabyMockArgumentMatcher.
		anObject2 asBabyMockArgumentMatcher.
		anObject3 asBabyMockArgumentMatcher.
		anObject4 asBabyMockArgumentMatcher.
	}.
     currentExpectation argumentMatcher: matcher.
]
