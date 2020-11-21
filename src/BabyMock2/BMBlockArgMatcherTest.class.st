Class {
	#name : #BMBlockArgMatcherTest,
	#superclass : #BMArgMatcherTest,
	#instVars : [
		'matcher'
	],
	#category : #'BabyMock2-Core-Tests'
}

{ #category : #tests }
BMBlockArgMatcherTest >> testDescribing [
	| block |
	block := [ :x | x = 3 ].
	matcher := BMBlockArgMatcher fromBlock: block.
	self assert: (BMDescription asString: matcher) equals: block asString.
]

{ #category : #tests }
BMBlockArgMatcherTest >> testDescribingMatch [
	| description |
	description := BMTextDescription new.
	matcher := BMBlockArgMatcher  fromBlock: [ :a :b | a = b ].
	matcher describeMismatch: description arguments: #(2 2).
	
	self assert: description asText asString equals: 'argument matched: #(2 2)'.
]

{ #category : #tests }
BMBlockArgMatcherTest >> testDescribingMismatch [
	| description |
	description := BMTextDescription new.
	matcher := BMBlockArgMatcher  fromBlock: [ :a :b | a = b ].
	matcher describeMismatch: description arguments: #(1 2).
	
	self assert: description asText asString equals: 'argument mismatched: #(1 2), wanted: [ :a :b | a = b ]'.
]

{ #category : #tests }
BMBlockArgMatcherTest >> testMatchWithMultipleArgument [
	matcher := BMBlockArgMatcher fromBlock: [:x :y| (x = 1) & (y = 2)].
	self assert: (matcher matches: #(1 2)).
	self deny: (matcher matches: #(2 1)).	
	self deny: (matcher matches: #(1)).
	self deny: (matcher matches: #(1 2 3)).
	
		
]

{ #category : #tests }
BMBlockArgMatcherTest >> testMatchWithSingleArgument [
	matcher := BMBlockArgMatcher fromBlock: [:x| x == 3].
	self assert: (matcher matches: #(3)).
	self deny: (matcher matches: #(1)).
	self deny: (matcher matches: #(1 2)).		
		
]

{ #category : #tests }
BMBlockArgMatcherTest >> testThatAsStringReturnsBlockAsString [
	| block |
	block := [:a | a = 3].
	matcher := BMBlockArgMatcher fromBlock: block.
	self assert: block asString equals: matcher asString.
		
]
