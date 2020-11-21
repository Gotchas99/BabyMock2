Class {
	#name : #BMManyArgMatcherTest,
	#superclass : #BMArgMatcherTest,
	#instVars : [
		'matcher'
	],
	#category : #'BabyMock2-Core-Tests'
}

{ #category : #running }
BMManyArgMatcherTest >> setUp [
	matcher := BMManyArgMatcher new.

]

{ #category : #tests }
BMManyArgMatcherTest >> testDescribing [
	matcher 
		addMatcher: (BMSingleArgMatcher argumentIs: 1);
		addMatcher: (BMSingleArgMatcher argumentIs: 2).	
	self assert: (BMDescription asString: matcher) equals: 'with: 1 and: 2'.
]

{ #category : #tests }
BMManyArgMatcherTest >> testThatAsStringConvertsOneArgumentToString [
	matcher addMatcher: (BMSingleArgMatcher argumentIs: 1).
	self assert: 'with: 1' equals: matcher asString.
]

{ #category : #tests }
BMManyArgMatcherTest >> testThatAsStringConvertsTwoArgumentsToString [
	matcher 
		addMatcher: (BMSingleArgMatcher argumentIs: 1);
		addMatcher: (BMSingleArgMatcher argumentIs: 2).	
	self assert: 'with: 1 and: 2' equals: matcher asString.
]

{ #category : #tests }
BMManyArgMatcherTest >> testThatItReturnsFalseForOneNonMatchingArgument [
	matcher addMatcher: (BMSingleArgMatcher argumentIs: 3).		
	self deny: (matcher matches: #(1)).
]

{ #category : #tests }
BMManyArgMatcherTest >> testThatItReturnsFalseIfAnyArgumentDoesNotMatch [
	matcher 
		addMatcher: (BMSingleArgMatcher argumentIs: 1);
		addMatcher: (BMSingleArgMatcher argumentIs: 2).	
	self deny: (matcher matches: #(1 3)).
]

{ #category : #tests }
BMManyArgMatcherTest >> testThatItReturnsFalseWhenArgumentCountDoesNotMatch [
	matcher 
		addMatcher: (BMSingleArgMatcher argumentIs: 1);
		addMatcher: (BMSingleArgMatcher argumentIs: 2).	
	self deny: (matcher matches: #(1)).
]

{ #category : #tests }
BMManyArgMatcherTest >> testThatItReturnsTrueForOneMatchingArgument [
	matcher 
		addMatcher: (BMSingleArgMatcher argumentIs: 1).		
	self assert: (matcher matches: #(1)).
]

{ #category : #tests }
BMManyArgMatcherTest >> testThatItReturnsTrueIfAllArgumentMatched [
	matcher 
		addMatcher: (BMSingleArgMatcher argumentIs: 1);
		addMatcher: (BMSingleArgMatcher argumentIs: 2).	
	self assert: (matcher matches: #(1 2)).
]
