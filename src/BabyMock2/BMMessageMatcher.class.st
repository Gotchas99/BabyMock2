"
A MessageMatcher checks whether the selector and the argument parts of the message match.
"
Class {
	#name : #BMMessageMatcher,
	#superclass : #BMMatcher,
	#instVars : [
		'argumentMatcher',
		'hasArgumentMatcher',
		'selectorMatcher'
	],
	#category : #'BabyMock2-Core'
}

{ #category : #accessing }
BMMessageMatcher >> argumentMatcher [
	^ argumentMatcher

]

{ #category : #accessing }
BMMessageMatcher >> argumentMatcher: anArgumentMatcher [ 		
	self ensureMethodNameMatchesTo: anArgumentMatcher.			
	argumentMatcher := anArgumentMatcher.
	hasArgumentMatcher := true.
]

{ #category : #'self describing' }
BMMessageMatcher >> describeMismatch: aBMDescription arguments: argumentsArray [
	argumentMatcher describeMismatch: aBMDescription arguments: argumentsArray
]

{ #category : #'self describing' }
BMMessageMatcher >> describeTo: aBMDescription [ 
	self hasMethodName
		ifFalse: 
			[ aBMDescription appendSelector: #unknown.
			^ self ].				
	selectorMatcher describeTo: aBMDescription.
	hasArgumentMatcher 
		ifTrue:
			[ aBMDescription appendText: ' '.
			argumentMatcher describeTo: aBMDescription ]
]

{ #category : #private }
BMMessageMatcher >> ensureArgumentCountMatchesTo: aBmMethodName [ 
	(hasArgumentMatcher and: 
		[ (aBmMethodName matchesArgumentNumber: argumentMatcher argumentCount) not ])
			ifTrue: 
				[ ^ BMMockError signal: 'Selector argument count and matcher argument count mismatch' ]
]

{ #category : #private }
BMMessageMatcher >> ensureMethodNameMatchesTo: anArgumentMatcher [ 		
	(self hasMethodName and: 
		[ (selectorMatcher matchesArgumentNumber: anArgumentMatcher argumentCount) not ])
			ifTrue: 
				[ ^ BMMockError signal: 'Selector argument count and matcher argument count mismatch' ]
]

{ #category : #private }
BMMessageMatcher >> hasMethodName [
	^ selectorMatcher notNil
]

{ #category : #initialization }
BMMessageMatcher >> initialize [
	super initialize.
	selectorMatcher := nil.
	argumentMatcher := BMAnyArgMatcher new.
	hasArgumentMatcher := false.
]

{ #category : #matching }
BMMessageMatcher >> matchesMessage: aMessage [ 
	^ (selectorMatcher matchesSelector: aMessage selector) 
		and: [ argumentMatcher matches: aMessage arguments ]
]

{ #category : #accessing }
BMMessageMatcher >> selectorMatcher [
	^ selectorMatcher
]

{ #category : #accessing }
BMMessageMatcher >> selectorMatcher: aBMSelectorMatcher [
	self ensureArgumentCountMatchesTo: aBMSelectorMatcher.
	selectorMatcher := aBMSelectorMatcher.
]
