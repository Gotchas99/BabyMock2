"
I'm the built-in syntax object that uses a BabyMock instance for creating mock objects and states. 
"
Class {
	#name : #BMCascadingProtocol,
	#superclass : #Object,
	#instVars : [
		'babyMock'
	],
	#category : #'BabyMock2-Syntax'
}

{ #category : #'instance creation' }
BMCascadingProtocol class >> babyMock: aBabyMock [
	^ self new setBabyMock: aBabyMock
]

{ #category : #'protocol description' }
BMCascadingProtocol >> describe [
	^ BMCascadeSyntax expectationCollector: babyMock
]

{ #category : #'create mocks' }
BMCascadingProtocol >> mock: nameString [
	^ babyMock createMockNamed: nameString
]

{ #category : #initialization }
BMCascadingProtocol >> setBabyMock: aBabyMock [
	babyMock := aBabyMock.
	^ self
]

{ #category : #'create states' }
BMCascadingProtocol >> states: stateName startsAs: initialStateSymbol [
	^ babyMock createStatesNamed: stateName initialState: initialStateSymbol
]

{ #category : #'visual mode' }
BMCascadingProtocol >> visualize: anObjectUnderTest [
	babyMock visualizeObjectUnderTest: anObjectUnderTest
]
