"
A matcher that checks the selector part of a message.
"
Class {
	#name : #BMSelectorMatcher,
	#superclass : #BMMatcher,
	#instVars : [
		'selector'
	],
	#category : #'BabyMock2-Core'
}

{ #category : #'instance creation' }
BMSelectorMatcher class >> selector: aSymbol [ 
	^ self new
		setSymbol: aSymbol
]

{ #category : #'self describing' }
BMSelectorMatcher >> describeTo: aBMDescription [ 
	aBMDescription appendSelector: selector
]

{ #category : #'method name matcher' }
BMSelectorMatcher >> matchesArgumentNumber: aNumber [
	^ aNumber = (self selectorArgumentCount: selector)
]

{ #category : #'method name matcher' }
BMSelectorMatcher >> matchesSelector: aSymbol [ 
	^ selector = aSymbol
]

{ #category : #private }
BMSelectorMatcher >> selectorArgumentCount: aSelector [
	aSelector isUnary ifTrue: [ ^ 0 ].
	aSelector isBinary ifTrue: [ ^ 1 ].
	aSelector isKeyword ifTrue: [ ^ aSelector asString count: [:c | c = $: ] ].
	Error signal: 'Invalid selector ', aSelector asString.
]

{ #category : #'initialize-release' }
BMSelectorMatcher >> setSymbol: aSymbol [ 
	selector := aSymbol.
	^ self
]
