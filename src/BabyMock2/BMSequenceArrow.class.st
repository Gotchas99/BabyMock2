"
Represents an arrow between objects used by a sequence diagram.
"
Class {
	#name : #BMSequenceArrow,
	#superclass : #BMInteractionArrow,
	#category : #'BabyMock2-GUI'
}

{ #category : #'instance creation' }
BMSequenceArrow class >> send: aBMInteraction from: aSenderMorph to: aReceiverMorph color: aColor index: aNumber [
	^ self new
		setInteraction: aBMInteraction
		senderMorph: aSenderMorph
		receiverMorph: aReceiverMorph
		color: aColor
		index: aNumber
]

{ #category : #drawing }
BMSequenceArrow >> drawOn: aCanvas [
	self bounds: curve boundingBox. "XXX"
	curve 
		drawOn: aCanvas 
		upTo: animationProgress 
		whenPassedHalfWay: [ :halfWayPoint | self showLabel: halfWayPoint ]
]

{ #category : #initialization }
BMSequenceArrow >> setInteraction: aBMInteraction senderMorph: senderMorph receiverMorph: receiverMorph color: aColor index: aNumber [
	interaction := aBMInteraction.
	senderObjectMorph := senderMorph.
	receiverObjectMorph := receiverMorph.
	self addLabel: interaction asText help: interaction asString.			
	curve := BMHorizontalArrow
		fromMorph: senderMorph
		toMorph: receiverMorph 
		slotNumber: aNumber
		color: aColor.
	^ self
]
