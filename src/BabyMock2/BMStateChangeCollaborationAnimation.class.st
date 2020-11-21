"
State change animation specifically for displaying state change on a collaboration diagram.
"
Class {
	#name : #BMStateChangeCollaborationAnimation,
	#superclass : #BMStateChangeAnimation,
	#category : #'BabyMock2-GUI'
}

{ #category : #'instance creation' }
BMStateChangeCollaborationAnimation class >> stateChange: aBmStateChange ofObject: anObjectMorph [
	^ self new 
		setStateChange: aBmStateChange
		object: anObjectMorph
]

{ #category : #abstract }
BMStateChangeCollaborationAnimation >> location: anObjectMorph [
	^ self center: objectMorph bottomCenter + (0@(self height * 2)).	
]

{ #category : #abstract }
BMStateChangeCollaborationAnimation >> postEndAnimation: isSelected [
	self visible: isSelected
]

{ #category : #'initialize-release' }
BMStateChangeCollaborationAnimation >> setStateChange: aBmStateChange object: anObjectMorph [
	stateChange := aBmStateChange.
	objectMorph := anObjectMorph.
	^ self
]
