"
An announcement that represents either an expected or an unexpeted message send.
"
Class {
	#name : #BMRequest,
	#superclass : #BMInteraction,
	#category : #'BabyMock2-Core'
}

{ #category : #'instance creation' }
BMRequest class >> from: aMethodContext to: anObject message: aMessage [ 
	^ self new
		setSender: aMethodContext receiver
		receiver: anObject
		payload: aMessage
]

{ #category : #converting }
BMRequest >> asText [
	| text |
	text := BMTextDescription new.
	text appendMessage: payload.
	^ text asText
]

{ #category : #testing }
BMRequest >> isDebuggerGenerated [
	^ self debuggerGeneratedSelectors includes: payload selector
]

{ #category : #initialization }
BMRequest >> setSender: senderObject receiver: receiverObject payload: aMessage [
	sender := senderObject.
	receiver := receiverObject.	
	payload := aMessage.
	^ self
]
