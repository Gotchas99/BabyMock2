"
Arrow used by the collaboration diagram. Represents a message.
"
Class {
	#name : #BMCollaborationMessageArrow,
	#superclass : #BMCollaborationArrow,
	#category : #'BabyMock2-GUI'
}

{ #category : #private }
BMCollaborationMessageArrow >> calculateIndex [
	index := receiverObjectMorph numberOfIncomingMessages.
	receiverObjectMorph incNumberOfIncomingMessages.
]

{ #category : #private }
BMCollaborationMessageArrow >> controlDistance [
	^ index odd  
		ifTrue: [ (index +1) // 2 * 50. ]
		ifFalse: [ (index +1) // 2 * -50 ]


]
