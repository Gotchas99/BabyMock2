Class {
	#name : #BMAnySelectorMatcherTest,
	#superclass : #BMMatcherTest,
	#instVars : [
		'methodName'
	],
	#category : #'BabyMock2-Core-Tests'
}

{ #category : #tests }
BMAnySelectorMatcherTest >> testDescribing [
	| matcher |
	matcher := BMAnySelectorMatcher new.
	self assert: (BMDescription asString: matcher) equals: '<any selector>'
]

{ #category : #tests }
BMAnySelectorMatcherTest >> testMatchesToAnythingExceptObjectMessages [
	self assert: (BMAnySelectorMatcher new matchesSelector: #asd).
	self assert: (BMAnySelectorMatcher new matchesArgumentNumber: 10).	
	self deny: (BMAnySelectorMatcher new matchesSelector: #asString).
]
