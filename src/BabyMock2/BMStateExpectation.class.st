"
A self-describing object that represents an expected state.
"
Class {
	#name : #BMStateExpectation,
	#superclass : #Object,
	#instVars : [
		'state',
		'expectedStateName'
	],
	#category : #'BabyMock2-Core'
}

{ #category : #'instance creation' }
BMStateExpectation class >> state: aState is: expectedStateName [
	^ self new
		setState: aState
		expectedStateName: expectedStateName
]

{ #category : #'self describing' }
BMStateExpectation >> describeMismatch: aDescription [
	state describeMismatch: aDescription expected: expectedStateName
]

{ #category : #'self describing' }
BMStateExpectation >> describeTo: aDescription [
	aDescription appendText: '; when '.
	state describeTo: aDescription.
	aDescription appendText: ' is '.
	aDescription appendValue: expectedStateName
]

{ #category : #printing }
BMStateExpectation >> printOn: aStream [
	aStream nextPutAll: (BMDescription asString: self)
]

{ #category : #verification }
BMStateExpectation >> satisfied [
	^ state equals: expectedStateName
]

{ #category : #initialization }
BMStateExpectation >> setState: aState expectedStateName: aSymbol [
	state := aState.
	expectedStateName := aSymbol.
	^ self
]
