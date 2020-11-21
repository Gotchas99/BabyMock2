Class {
	#name : #BMSelectorMatcherTest,
	#superclass : #BMMatcherTest,
	#instVars : [
		'selectorMatcher'
	],
	#category : #'BabyMock2-Core-Tests'
}

{ #category : #tests }
BMSelectorMatcherTest >> testDescribing [
	selectorMatcher := BMSelectorMatcher selector: #at:put:.
	self assert: (BMDescription asString: selectorMatcher) equals: 'at:put:'
]

{ #category : #tests }
BMSelectorMatcherTest >> testDoesNotMatchArgumentCount [
	selectorMatcher := BMSelectorMatcher selector: #someName.
	self deny: (selectorMatcher matchesArgumentNumber: 2).	

	selectorMatcher := BMSelectorMatcher selector: #+.
	self deny: (selectorMatcher matchesArgumentNumber: 2).
	
	selectorMatcher := BMSelectorMatcher selector: #a:b:.
	self deny: (selectorMatcher matchesArgumentNumber: 1).
]

{ #category : #tests }
BMSelectorMatcherTest >> testDoesNotMatchSelector [
	selectorMatcher := BMSelectorMatcher selector: #someName.
	self deny: (selectorMatcher matchesSelector: #otherName).
]

{ #category : #tests }
BMSelectorMatcherTest >> testMatchesArgumentCount [
	selectorMatcher := BMSelectorMatcher selector: #someName.
	self assert: (selectorMatcher matchesArgumentNumber: 0).	

	selectorMatcher := BMSelectorMatcher selector: #+.
	self assert: (selectorMatcher matchesArgumentNumber: 1).	
	
	selectorMatcher := BMSelectorMatcher selector: #a:b:.
	self assert: (selectorMatcher matchesArgumentNumber: 2).
]

{ #category : #tests }
BMSelectorMatcherTest >> testMatchesToSelector [
	selectorMatcher := BMSelectorMatcher selector: #someName.
	self assert: (selectorMatcher matchesSelector: #someName).
]
