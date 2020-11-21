"
An announcement that represents an unexpected message send.
"
Class {
	#name : #BMUnexpectedMessage,
	#superclass : #BMRequest,
	#category : #'BabyMock2-Core'
}

{ #category : #'user interface' }
BMUnexpectedMessage >> addTo: aDisplay [
	aDisplay addUnexpectedMessage: self
]
