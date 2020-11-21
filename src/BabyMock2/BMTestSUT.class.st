"
A simulated object under test
"
Class {
	#name : #BMTestSUT,
	#superclass : #Object,
	#instVars : [
		'mock',
		'name'
	],
	#category : #'BabyMock2-GUI-Tests'
}

{ #category : #accessing }
BMTestSUT >> asString [ 
	^ name
]

{ #category : #accessing }
BMTestSUT >> delegate: aSymbol [
	^ mock perform: aSymbol
]

{ #category : #accessing }
BMTestSUT >> delegateThroughIntermediateObject: aSymbol [
	| intermediate |
	intermediate := BMTestSUT new sutName: 'intermediate'; mock: mock; yourself.
	^ intermediate delegate: aSymbol.
]

{ #category : #'initialize-release' }
BMTestSUT >> initialize [ 
	super initialize.
	name := 'defualt'.
]

{ #category : #accessing }
BMTestSUT >> mock: aBmMock [
	mock := aBmMock
]

{ #category : #accessing }
BMTestSUT >> sutName: aByteString [
	name := aByteString 
]

{ #category : #accessing }
BMTestSUT >> testQuery [
	^ 42
]
