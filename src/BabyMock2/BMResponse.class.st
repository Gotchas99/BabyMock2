"
An announcement that represents either a return value in response to a message or an exception.
"
Class {
	#name : #BMResponse,
	#superclass : #BMInteraction,
	#instVars : [
		'inReplyTo'
	],
	#category : #'BabyMock2-Core'
}

{ #category : #'instance creation' }
BMResponse class >> from: anObject to: aMethodContext response: anAnswer inReplyTo: aMessage [
	^ self new
		setSender: anObject
		receiver: aMethodContext receiver
		payload: anAnswer
		inReplyTo: aMessage
]

{ #category : #converting }
BMResponse >> asText [
	| text textContent |
	textContent := (self asString findTokens: Character cr) first.	
	textContent size > 50
		ifTrue: [ textContent := (textContent truncateTo: 46), ' ...' ].
	text := Text fromString: textContent.
	text addAttribute: BMColorScheme valueColor.
	^ text
]

{ #category : #initialization }
BMResponse >> setSender: senderObject receiver: receiverObject payload: response inReplyTo: aMessage [
	sender := senderObject.
	receiver := receiverObject.	
	payload := response.
	inReplyTo := aMessage.
	^ self
]
