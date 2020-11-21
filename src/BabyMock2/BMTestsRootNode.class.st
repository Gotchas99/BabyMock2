"
Represents a test node in a BMTestsTree.
"
Class {
	#name : #BMTestsRootNode,
	#superclass : #Object,
	#instVars : [
		'testName'
	],
	#category : #'BabyMock2-GUI'
}

{ #category : #'instance creation' }
BMTestsRootNode class >> testName: aString [
	^ self new setTestName: aString
]

{ #category : #comparing }
BMTestsRootNode >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ testName = anObject testName
]

{ #category : #comparing }
BMTestsRootNode >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ testName hash
]

{ #category : #gui }
BMTestsRootNode >> icon: icons [
	^ icons byName: #test
]

{ #category : #printing }
BMTestsRootNode >> printOn: aStream [
	aStream nextPutAll: testName
]

{ #category : #initialization }
BMTestsRootNode >> setTestName: aString [
	testName := aString.
	^ self
]

{ #category : #accessing }
BMTestsRootNode >> testName [
	^ testName
]
