"
Arrow used by the collaboration diagram.
"
Class {
	#name : #BMCollaborationArrow,
	#superclass : #BMInteractionArrow,
	#instVars : [
		'index'
	],
	#category : #'BabyMock2-GUI'
}

{ #category : #'instance creation' }
BMCollaborationArrow class >> send: aBMInteraction from: aSenderMorph to: aReceiverMorph color: aColor [
	^ self new
		setInteraction: aBMInteraction
		senderMorph: aSenderMorph
		receiverMorph: aReceiverMorph
		color: aColor
]

{ #category : #private }
BMCollaborationArrow >> calculateControlPoint [ 
	| split normal midPoint |
	split := receiverObjectMorph center - senderObjectMorph center / 2.
	normal := split normal negated.
	midPoint := senderObjectMorph center + split.
	^ self controlDistance * normal + midPoint.		
]

{ #category : #abstract }
BMCollaborationArrow >> calculateIndex [
	self subclassResponsibility 
]

{ #category : #abstract }
BMCollaborationArrow >> controlDistance [
	self subclassResponsibility 
]

{ #category : #drawing }
BMCollaborationArrow >> drawOn: aCanvas [	
	self bounds: curve boundingBox. "XXX"
	curve
		drawOn: aCanvas 
		viaPoint: self calculateControlPoint
		upTo: animationProgress 
		whenPassedHalfWay: [ :halfWayPoint | selected ifTrue: [ self showLabel: halfWayPoint ] ].

]

{ #category : #initialization }
BMCollaborationArrow >> setInteraction: aBMInteraction senderMorph: senderMorph receiverMorph: receiverMorph color: aColor [ 
	interaction := aBMInteraction.
	senderObjectMorph := senderMorph.
	receiverObjectMorph := receiverMorph.
	self addLabel: interaction asText help: interaction asString.			
	self calculateIndex.
	curve := BMBezier2Arrow 
		fromMorph: senderObjectMorph 
		viaPoint: self calculateControlPoint
		toMorph: receiverObjectMorph 
		color: aColor.	
	^ self
]
