"
Represents an interaction related to an exception.
"
Class {
	#name : #BMMessageException,
	#superclass : #BMResponse,
	#category : #'BabyMock2-Core'
}

{ #category : #'user interface' }
BMMessageException >> addTo: aDisplay [
	aDisplay addException: self
]

{ #category : #testing }
BMMessageException >> isDebuggerGenerated [
	^ (payload isKindOf: Halt) or: [ self debuggerGeneratedSelectors includes: inReplyTo selector ]
]
