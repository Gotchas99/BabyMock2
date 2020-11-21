"
An interaction diagram specialized for displaying sequence diagram.
"
Class {
	#name : #BMSequenceDiagram,
	#superclass : #BMInteractionDiagram,
	#category : #'BabyMock2-GUI'
}

{ #category : #private }
BMSequenceDiagram >> addAsSequenceMorph: anObject [
	| morph |
	morph := BMSequenceObject fromObject: anObject.
	morph totalSlots: testResult totalInteraction.		
	self addMorph: morph.
	objectMorphs at: anObject put: morph.		
	layout add: morph.
	layout layout: self.
]

{ #category : #private }
BMSequenceDiagram >> addHorizontalArrow: aBMInteraction from: senderMorph to: receiverMorph color: aColor [
	self addAnimatedMoroh: (BMSequenceArrow
		send: aBMInteraction 
		from: senderMorph 
		to: receiverMorph 
		color: aColor 
		index: player size)
]

{ #category : #implemented }
BMSequenceDiagram >> addMessageInteraction: aBMInteraction from: senderMorph to: receiverMorph color: aColor [
	self 
		addHorizontalArrow: aBMInteraction 
		from: senderMorph 
		to: receiverMorph 
		color: aColor
]

{ #category : #implemented }
BMSequenceDiagram >> addMockObject: anObject [
	^ self addAsSequenceMorph: anObject
]

{ #category : #implemented }
BMSequenceDiagram >> addResponseInteraction: aBMInteraction from: senderMorph to: receiverMorph color: aColor [
	self 
		addHorizontalArrow: aBMInteraction 
		from: senderMorph 
		to: receiverMorph 
		color: aColor
]

{ #category : #implemented }
BMSequenceDiagram >> addStateChange: aBmStateChange [
	self addAnimatedMoroh: (BMStateChangeSequenceAnimation 
		stateChange: aBmStateChange 
		ofObject: (objectMorphs at: testResult objectUnderTest)
		index: player size)
]

{ #category : #implemented }
BMSequenceDiagram >> addSutObject: anObject [
	^ self addAsSequenceMorph: anObject
]

{ #category : #implemented }
BMSequenceDiagram >> addTestObject: anObject [
	^ self addAsSequenceMorph: anObject
]

{ #category : #implemented }
BMSequenceDiagram >> newLayout [
	^ BMBoxLayout new
]
