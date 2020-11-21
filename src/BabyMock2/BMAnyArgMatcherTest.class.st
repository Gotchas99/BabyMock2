Class {
	#name : #BMAnyArgMatcherTest,
	#superclass : #BMArgMatcherTest,
	#category : #'BabyMock2-Core-Tests'
}

{ #category : #tests }
BMAnyArgMatcherTest >> testAlwaysTrue [
	self assert: (BMAnyArgMatcher new matches: 'anything 1 2 3')
]

{ #category : #tests }
BMAnyArgMatcherTest >> testDescribing [
	| matcher |
	matcher := BMAnyArgMatcher new.
	self assert: (BMDescription asString: matcher) equals: '''<any>'''.
]

{ #category : #tests }
BMAnyArgMatcherTest >> testDescribingMismatch [
	| matcher description |
	description := BMTextDescription new.
	matcher := BMAnyArgMatcher new.
	matcher describeMismatch: description arguments: #(2).
	
	self assert: description asText asString equals: 'argument matched: #(2)'.
]
