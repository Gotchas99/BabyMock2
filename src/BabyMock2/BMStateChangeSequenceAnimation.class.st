"
State change animation specifically for displaying state change on a sequence diagram.
"
Class {
	#name : #BMStateChangeSequenceAnimation,
	#superclass : #BMStateChangeAnimation,
	#instVars : [
		'index'
	],
	#category : #'BabyMock2-GUI'
}

{ #category : #'instance creation' }
BMStateChangeSequenceAnimation class >> stateChange: aBmStateChange ofObject: anObjectMorph index: aNumber [
	^ self new 
		setStateChange: aBmStateChange
		object: anObjectMorph
		index: aNumber
]

{ #category : #abstract }
BMStateChangeSequenceAnimation >> location: anObjectMorph [
	self center: (objectMorph getSlot: index) - (self height / 2)
]

{ #category : #abstract }
BMStateChangeSequenceAnimation >> postEndAnimation: isSelected [
	self visible: true
]

{ #category : #'initialize-release' }
BMStateChangeSequenceAnimation >> setStateChange: aBmStateChange object: anObjectMorph index: aNumber [
	stateChange := aBmStateChange.
	objectMorph := anObjectMorph.
	index := aNumber.
	^ self
]
