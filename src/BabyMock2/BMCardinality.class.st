"
This class represents an expected quantity, which can be an interval, an exact number or an undefined value. A cardinality can be tested using the satisfied message.
"
Class {
	#name : #BMCardinality,
	#superclass : #Object,
	#instVars : [
		'required',
		'maximum'
	],
	#category : #'BabyMock2-Core'
}

{ #category : #'instance creation' }
BMCardinality class >> anyNumberOfTimes [
	^ self between: 0 and: self maxVal
]

{ #category : #'instance creation' }
BMCardinality class >> atLeast: requiredNumber [
	^ self between: requiredNumber and: self maxVal
]

{ #category : #'instance creation' }
BMCardinality class >> atMost: maxNumber [
	^ self between: 1 and: maxNumber
]

{ #category : #'instance creation' }
BMCardinality class >> between: requiredNumber and: maximumNumber [
	^ self new 
		setRequired: requiredNumber
		maximum: maximumNumber
]

{ #category : #'instance creation' }
BMCardinality class >> exactly: anInteger [ 
	^ self between: anInteger and: anInteger
]

{ #category : #private }
BMCardinality class >> maxVal [
	^ SmallInteger maxVal
]

{ #category : #'instance creation' }
BMCardinality class >> never [
	^ self exactly: 0
]

{ #category : #cardinality }
BMCardinality >> allowsMoreInvocation: anInteger [ 
	^ anInteger < maximum
]

{ #category : #'self describing' }
BMCardinality >> describeTo: aBMDescription [
	(required = 0 and: [ maximum = self class maxVal ])
		ifTrue: [ ^ aBMDescription appendText: 'allowed' ].
	aBMDescription appendText: 'expected '.
	(self exact and: [ required = 0 ])
		ifTrue: [^ aBMDescription appendValue: 'never'].
	(self exact and: [ required = 1 ])
		ifTrue: [^ aBMDescription appendValue: 'once'].
	(self exact and: [ required = 2 ])
		ifTrue: [^ aBMDescription appendValue: 'twice'].
	self exact
		ifTrue: [^ aBMDescription appendValue: required asString, ' times'].
	maximum = self class maxVal
		ifTrue: [^ aBMDescription appendValue: 'at least ' , required asString, ' times'].
	required = 0
		ifTrue: [^ aBMDescription appendValue: 'at most ' , maximum asString, ' times'].
	^ aBMDescription appendValue: 'at least ', required asString , ' at most ' , maximum asString, ' times'
]

{ #category : #private }
BMCardinality >> exact [
	^ required = maximum
]

{ #category : #printing }
BMCardinality >> printOn: aStream [
	aStream nextPutAll: (BMDescription asString: self)
]

{ #category : #cardinality }
BMCardinality >> satisfied: anInteger [ 
	^ anInteger between: required and: maximum
]

{ #category : #initialization }
BMCardinality >> setRequired: requiredNumber maximum: maximumNumber [
	required := requiredNumber.
	maximum := maximumNumber.
	^ self
]
