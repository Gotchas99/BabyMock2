"
A matcher that checks the receiver part of a message send.
"
Class {
	#name : #BMObjectMatcher,
	#superclass : #BMMatcher,
	#instVars : [
		'predicate',
		'object'
	],
	#category : #'BabyMock2-Core'
}

{ #category : #'object matchers' }
BMObjectMatcher class >> sameAs: anObject [
	^ self new		
		setBlock: [ :obj | obj == anObject ]
		object: anObject
]

{ #category : #'self describing' }
BMObjectMatcher >> describeTo: aBMDescription [ 
	aBMDescription appendReceiver: object
]

{ #category : #matching }
BMObjectMatcher >> matchesObject: anObject [
	^ predicate value: anObject
]

{ #category : #initialization }
BMObjectMatcher >> setBlock: aBlock object: anObject [
	predicate := aBlock.
	object := anObject.
	^ self
]
