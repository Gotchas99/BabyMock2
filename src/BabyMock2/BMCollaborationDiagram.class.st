"
An interaction diagram specialized for displaying collaboration.
"
Class {
	#name : #BMCollaborationDiagram,
	#superclass : #BMInteractionDiagram,
	#category : #'BabyMock2-GUI'
}

{ #category : #implemented }
BMCollaborationDiagram >> addMessageInteraction: aBMInteraction from: senderMorph to: receiverMorph color: aColor [	
	self addAnimatedMoroh: (BMCollaborationMessageArrow 
		send: aBMInteraction 
		from: senderMorph 
		to: receiverMorph 
		color: aColor)
	

]

{ #category : #implemented }
BMCollaborationDiagram >> addMockObject: aMock [
	| morph |
	morph := BMCollaborationObject fromObject: aMock.
	objectMorphs at: aMock put: morph.	
	self pvtAdd: morph.
]

{ #category : #implemented }
BMCollaborationDiagram >> addResponseInteraction: aBMInteraction from: senderMorph to: receiverMorph color: aColor [
	self addAnimatedMoroh: (BMCollaborationResponseArrow 
		send: aBMInteraction 
		from: senderMorph 
		to: receiverMorph 
		color: aColor)
]

{ #category : #implemented }
BMCollaborationDiagram >> addStateChange: aBmStateChange [
	self addAnimatedMoroh: (BMStateChangeCollaborationAnimation 
		stateChange: aBmStateChange 
		ofObject: (objectMorphs at: testResult objectUnderTest))
]

{ #category : #implemented }
BMCollaborationDiagram >> addSutObject: anObject [
	| morph |
	morph := BMCollaborationObject fromObject: anObject.
	objectMorphs at: anObject put: morph.	
	self pvtAdd: morph row: 1 column: 1.
]

{ #category : #implemented }
BMCollaborationDiagram >> addTestObject: anObject [
	| morph |
	morph := BMCollaborationObject fromObject: anObject.
	objectMorphs at: anObject put: morph.	
	self pvtAdd: morph row: 1 column: 0.
]

{ #category : #implemented }
BMCollaborationDiagram >> newLayout [
	^ (BMGridLayout rows: 3 columns: 3) preferredCells: {2@1 . 2@0 . 2@2 . 1@0 . 1@2}

]

{ #category : #private }
BMCollaborationDiagram >> pvtAdd: anObjectMorph [
	self addMorph: anObjectMorph.
	layout add: anObjectMorph.
	layout layout: self.
]

{ #category : #private }
BMCollaborationDiagram >> pvtAdd: anObjectMorph row: r column: c [
	self addMorph: anObjectMorph.
	layout addTo: anObjectMorph row: r column: c.
	layout layout: self.
]
