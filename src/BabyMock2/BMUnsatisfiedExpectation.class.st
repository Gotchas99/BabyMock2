"
This event indicates that a mock was expected to receive a message, but didn't happen
"
Class {
	#name : #BMUnsatisfiedExpectation,
	#superclass : #BMInteraction,
	#category : #'BabyMock2-Core'
}

{ #category : #'instance creation' }
BMUnsatisfiedExpectation class >> expectation: anExpectation [
	^ self new 
		setExpectation: anExpectation
]

{ #category : #'user interface' }
BMUnsatisfiedExpectation >> addTo: aDisplay [
	aDisplay addMissingMessage: self
]

{ #category : #converting }
BMUnsatisfiedExpectation >> asString [
	| text |
	text := BMTextDescription new.
	payload describeMessageTo: text.
	^ text asText asString
]

{ #category : #converting }
BMUnsatisfiedExpectation >> asText [
	| text |
	text := BMTextDescription new.
	payload describeMessageTo: text.
	^ text asText
]

{ #category : #testing }
BMUnsatisfiedExpectation >> isDebuggerGenerated [
	^ false
]

{ #category : #accessing }
BMUnsatisfiedExpectation >> matchesReceiver: anObject [
	^ payload matchesObject: anObject
]

{ #category : #initialization }
BMUnsatisfiedExpectation >> setExpectation: anExpectation [
	payload := anExpectation.
	^ self
]
