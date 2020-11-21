"
An SUnit specific exception that indicates expectation failure.
"
Class {
	#name : #BMTestFailure,
	#superclass : #TestFailure,
	#category : #'BabyMock2-Core'
}

{ #category : #printing }
BMTestFailure >> printOn: aStream [
	aStream nextPutAll: self messageText.
]
