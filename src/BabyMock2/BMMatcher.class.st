"
This is a dummy base class for grouping various matchers.
"
Class {
	#name : #BMMatcher,
	#superclass : #Object,
	#category : #'BabyMock2-Core'
}

{ #category : #'self describing' }
BMMatcher >> describeTo: aBMDescription [ 
	self subclassResponsibility
]

{ #category : #printing }
BMMatcher >> printOn: aStream [
	aStream nextPutAll: (BMDescription asString: self)
]
