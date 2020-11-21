"
A model object that holds information about a test execution. It includes the interactions, the participants and the result of the test.
"
Class {
	#name : #BMTestResult,
	#superclass : #Object,
	#instVars : [
		'mocks',
		'interactions',
		'testCase',
		'passed',
		'objectUnderTest',
		'description'
	],
	#category : #'BabyMock2-Core'
}

{ #category : #comparing }
BMTestResult >> = anObject [
	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ self testCaseName = anObject testCaseName
]

{ #category : #accessing }
BMTestResult >> addInteraction: aBMInteraction [
	interactions add: aBMInteraction
]

{ #category : #accessing }
BMTestResult >> addMock: aMock [
	mocks add: aMock.
]

{ #category : #accessing }
BMTestResult >> description [
	^ description
]

{ #category : #accessing }
BMTestResult >> description: aBMDescription [
	description := aBMDescription
]

{ #category : #accessing }
BMTestResult >> eachInteraction: aBlockWithOneArg [
	interactions do: [ :each | aBlockWithOneArg value: each ]
]

{ #category : #accessing }
BMTestResult >> eachMock: aBlockWithOneArg [
	mocks do: [ :mock | aBlockWithOneArg value: mock ]
]

{ #category : #accessing }
BMTestResult >> hasInteraction [
	^ interactions isNotEmpty 
]

{ #category : #comparing }
BMTestResult >> hash [
	^ self testCaseName hash
]

{ #category : #gui }
BMTestResult >> icon: icons [
	^ passed 
		ifTrue: [ icons byName: #testPassed ]
		ifFalse: [ icons byName: #testFailed ]
]

{ #category : #initialization }
BMTestResult >> initialize [ 
	super initialize.
	interactions := OrderedCollection new.
	mocks := OrderedCollection new.
]

{ #category : #accessing }
BMTestResult >> objectUnderTest [
	^ objectUnderTest
]

{ #category : #accessing }
BMTestResult >> objectUnderTest: anObject [
	objectUnderTest := anObject
]

{ #category : #accessing }
BMTestResult >> passed: aBoolean [
	passed := aBoolean
]

{ #category : #printing }
BMTestResult >> printOn: aStream [
	aStream nextPutAll: self testCaseName
	
]

{ #category : #accessing }
BMTestResult >> testCase [
	^ testCase
]

{ #category : #accessing }
BMTestResult >> testCase: aBabyMock2TestCase [
	testCase := aBabyMock2TestCase
]

{ #category : #accessing }
BMTestResult >> testCaseName [
	^ testCase selector asString
]

{ #category : #accessing }
BMTestResult >> testName [
	^ testCase class asString
]

{ #category : #accessing }
BMTestResult >> totalInteraction [
	^ interactions size
]
