Class {
	#name : #BMObjectMatcherTest,
	#superclass : #BMMatcherTest,
	#instVars : [
		'objectMatcher'
	],
	#category : #'BabyMock2-Core-Tests'
}

{ #category : #tests }
BMObjectMatcherTest >> testDescribing [
	objectMatcher := BMObjectMatcher sameAs: 12.
	self assert: (BMDescription asString: objectMatcher) equals: '12'
]

{ #category : #tests }
BMObjectMatcherTest >> testMatches [
	self assert: ((BMObjectMatcher sameAs: 32) matchesObject: 32).
	self deny: ((BMObjectMatcher sameAs: 32) matchesObject: 15).
]
