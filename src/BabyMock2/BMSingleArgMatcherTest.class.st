Class {
	#name : #BMSingleArgMatcherTest,
	#superclass : #BMArgMatcherTest,
	#category : #'BabyMock2-Core-Tests'
}

{ #category : #tests }
BMSingleArgMatcherTest >> testDescribing [
	| matcher |
	matcher := BMSingleArgMatcher argumentIs: 3.
	self assert: (BMDescription asString: matcher) equals: '3'.
]

{ #category : #tests }
BMSingleArgMatcherTest >> testDescribingMatch [
	| matcher description |
	description := BMTextDescription new.
	matcher := BMSingleArgMatcher argumentIs: 5.
	matcher describeMismatch: description arguments: #(5).
	
	self assert: description asText asString equals: 'argument matched: 5'.
]

{ #category : #tests }
BMSingleArgMatcherTest >> testDescribingMismatch [
	| matcher description |
	description := BMTextDescription new.
	matcher := BMSingleArgMatcher argumentIs: 5.
	matcher describeMismatch: description arguments: #(2).
	
	self assert: description asText asString equals: 'argument mismatched: 2, wanted: 5'.
]

{ #category : #tests }
BMSingleArgMatcherTest >> testThatAsStringReturnsValue [
	self assert: '3' equals: (BMSingleArgMatcher argumentIs: 3) asString.
]

{ #category : #tests }
BMSingleArgMatcherTest >> testThatItReturnsFalseForNonMatchingArgument [
	self deny: ((BMSingleArgMatcher argumentIs: 3) matches: #(4)).
	self deny: ((BMSingleArgMatcher argumentIs: 3) matches: #(3 4))	
]

{ #category : #tests }
BMSingleArgMatcherTest >> testThatItReturnsTrueForMatchingArgument [
	self assert: ((BMSingleArgMatcher argumentIs: 3) matches: #(3))
]
