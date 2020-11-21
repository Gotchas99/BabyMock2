"
An announcement that represents an interaction between two objects. It can be related with message sending, response or exception.
"
Class {
	#name : #BMInteraction,
	#superclass : #Announcement,
	#instVars : [
		'sender',
		'receiver',
		'payload'
	],
	#category : #'BabyMock2-Core'
}

{ #category : #'user interface' }
BMInteraction >> addTo: aDisplay [
	self subclassResponsibility 
]

{ #category : #converting }
BMInteraction >> asString [
	^ payload asString 
]

{ #category : #converting }
BMInteraction >> asText [
	self subclassResponsibility 
]

{ #category : #private }
BMInteraction >> debuggerGeneratedSelectors [
	^ #( printStringLimitedTo: )
]

{ #category : #testing }
BMInteraction >> isDebuggerGenerated [
	^ self subclassResponsibility
]

{ #category : #accessing }
BMInteraction >> matchesReceiver: anObject [
	^ anObject = receiver
]

{ #category : #accessing }
BMInteraction >> matchesSender: anObject [
	^ anObject = sender
]

{ #category : #'user interface' }
BMInteraction >> openInBrowser [
	payload inspect
]

{ #category : #private }
BMInteraction >> payload [
	^ payload
]

{ #category : #accessing }
BMInteraction >> receiverObject: anObject [
	"XXX used when we are overriding the receiver sut"
	receiver := anObject
	
]

{ #category : #private }
BMInteraction >> sender [
	^ sender
]

{ #category : #accessing }
BMInteraction >> senderObject: anObject [
	"XXX used when we are overriding the receiver sut"
	sender := anObject
	
]
