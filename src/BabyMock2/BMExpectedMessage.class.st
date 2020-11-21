"
An announcement that represents an expected message send.
"
Class {
	#name : #BMExpectedMessage,
	#superclass : #BMRequest,
	#category : #'BabyMock2-Core'
}

{ #category : #'user interface' }
BMExpectedMessage >> addTo: aDisplay [
	aDisplay addMessage: self
]
