"
Arrow used by the collaboration diagram. Represents a response.
"
Class {
	#name : #BMCollaborationResponseArrow,
	#superclass : #BMCollaborationArrow,
	#category : #'BabyMock2-GUI'
}

{ #category : #private }
BMCollaborationResponseArrow >> calculateIndex [
	index := senderObjectMorph numberOfIncomingMessages - 1.
]

{ #category : #private }
BMCollaborationResponseArrow >> controlDistance [
	^ index odd  
		ifTrue: [ (index +1) // 2 * -50. ]
		ifFalse: [ (index +1) // 2 * 50 ]



]
