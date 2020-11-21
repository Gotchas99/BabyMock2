"
Simple matcher which always returns true.
"
Class {
	#name : #BMAnyArgMatcher,
	#superclass : #BMArgMatcher,
	#category : #'BabyMock2-Core'
}

{ #category : #matching }
BMAnyArgMatcher >> argumentCount [
	^ -1
]

{ #category : #'self describing' }
BMAnyArgMatcher >> describeMismatch: aBMDescription arguments: argumentsArray [
	aBMDescription 
		appendText: 'argument matched: ';
		appendArgument: argumentsArray
]

{ #category : #'self describing' }
BMAnyArgMatcher >> describeTo: aBMDescription [ 
	aBMDescription appendArgument: '<any>'
]

{ #category : #matching }
BMAnyArgMatcher >> matches: anything [
	^ true.
]
