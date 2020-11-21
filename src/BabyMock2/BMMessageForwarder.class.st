"
This object forwards the intercepted messages to the target object and notifies the listener about the message and the result.
"
Class {
	#name : #BMMessageForwarder,
	#superclass : #Object,
	#instVars : [
		'announcer'
	],
	#category : #'BabyMock2-Core'
}

{ #category : #private }
BMMessageForwarder >> announce: anAnnouncement [
	self announcer announce: anAnnouncement 
]

{ #category : #'events-registering' }
BMMessageForwarder >> announcer [
	^ announcer
]

{ #category : #private }
BMMessageForwarder >> forwardMessage: aMessage to: aTargetObject [
	^ aTargetObject perform: aMessage selector withArguments: aMessage arguments.		


]

{ #category : #'initialize-release' }
BMMessageForwarder >> initialize [ 
	super initialize.
	announcer := Announcer new.
]

{ #category : #intercepting }
BMMessageForwarder >> messageIntercepted: aMessage source: sourceMethodCtx destination: aTargetObject [
	| result |
	self announce: (BMExpectedMessage from: sourceMethodCtx to: aTargetObject message: aMessage).
	[ result := self forwardMessage: aMessage to: aTargetObject.
 	(result isNotNil and: [ result ~~ aTargetObject ])
		ifTrue: [ self announce: (BMMessageAnswer 
			from: aTargetObject 
			to: sourceMethodCtx 
			response: result
			inReplyTo: aMessage) ].
	^ result
	] on: Exception do: 
		[ :ex | 
		self announce: (BMMessageException 
			from: aTargetObject 
			to: sourceMethodCtx 
			response: ex
			inReplyTo: aMessage).
		ex pass ]
]
