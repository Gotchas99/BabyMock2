"
A dummy base class for grouping various argument matchers.
"
Class {
	#name : #BMArgMatcher,
	#superclass : #BMMatcher,
	#category : #'BabyMock2-Core'
}

{ #category : #matching }
BMArgMatcher >> argumentCount [
	self subclassResponsibility 
]

{ #category : #'self describing' }
BMArgMatcher >> describeMismatch: aBMDescription arguments: argumentsArray [
	self subclassResponsibility 
]

{ #category : #matching }
BMArgMatcher >> matches: anArrayOfArgs [
	self subclassResponsibility 
]
