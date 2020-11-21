"
Matches to any selector.
"
Class {
	#name : #BMAnySelectorMatcher,
	#superclass : #BMMatcher,
	#category : #'BabyMock2-Core'
}

{ #category : #'self describing' }
BMAnySelectorMatcher >> describeTo: aBMDescription [ 
	aBMDescription appendSelector: '<any selector>'
]

{ #category : #'method name matcher' }
BMAnySelectorMatcher >> matchesArgumentNumber: aNumber [
	^ true
]

{ #category : #'method name matcher' }
BMAnySelectorMatcher >> matchesSelector: aSymbol [ 
	^ (Object new respondsTo: aSymbol) not
]
