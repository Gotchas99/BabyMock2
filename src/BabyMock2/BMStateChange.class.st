"
An announcement that represents a state change.
"
Class {
	#name : #BMStateChange,
	#superclass : #Announcement,
	#instVars : [
		'stateName',
		'oldState',
		'newState'
	],
	#category : #'BabyMock2-Core'
}

{ #category : #'instance creation' }
BMStateChange class >> name: stateName from: oldStateSymbol to: newStateSymbol [
	^ self new
		setStateName: stateName
		oldState: oldStateSymbol
		newState: newStateSymbol
]

{ #category : #comparing }
BMStateChange >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ stateName = anObject stateName and: [ oldState = anObject oldState and: [ newState = anObject newState ] ]
]

{ #category : #'user interface' }
BMStateChange >> addTo: aDisplay [
	aDisplay addStateChange: self
]

{ #category : #comparing }
BMStateChange >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ stateName hash bitXor: (oldState hash bitXor: newState hash)
]

{ #category : #accessing }
BMStateChange >> newState [
	^ newState
]

{ #category : #accessing }
BMStateChange >> oldState [
	^ oldState
]

{ #category : #printing }
BMStateChange >> printOn: aStream [
	aStream
		nextPutAll: 'State: ';
		print: stateName.
	aStream
		nextPutAll: ' changed from: ';
		print: oldState.
	aStream
		nextPutAll: ' to: ';
		print: newState
]

{ #category : #'initialize-release' }
BMStateChange >> setStateName: stateNameString oldState: oldStateSymbol newState: newStateSmybol [
	stateName := stateNameString.
	oldState := oldStateSymbol.
	newState := newStateSmybol.
	^ self
]

{ #category : #accessing }
BMStateChange >> stateName [
	^ stateName
]
