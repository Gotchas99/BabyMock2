"
Represents an interaction related to a return value.
"
Class {
	#name : #BMMessageAnswer,
	#superclass : #BMResponse,
	#category : #'BabyMock2-Core'
}

{ #category : #'user interface' }
BMMessageAnswer >> addTo: aDisplay [
	aDisplay addAnswer: self
]

{ #category : #testing }
BMMessageAnswer >> isDebuggerGenerated [
	^ self debuggerGeneratedSelectors includes: inReplyTo selector
]
