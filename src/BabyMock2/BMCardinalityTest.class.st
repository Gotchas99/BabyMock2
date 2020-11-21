Class {
	#name : #BMCardinalityTest,
	#superclass : #TestCase,
	#instVars : [
		'cardinality'
	],
	#category : #'BabyMock2-Core-Tests'
}

{ #category : #private }
BMCardinalityTest >> assertSubstring: substring [
	self assert: ((BMDescription asString: cardinality) includesSubstring: substring)
]

{ #category : #tests }
BMCardinalityTest >> testAllowing [
	cardinality := BMCardinality between: 2 and: 3.
	self assert: (cardinality allowsMoreInvocation: 0).
	self assert: (cardinality allowsMoreInvocation: 1).	
	self assert: (cardinality allowsMoreInvocation: 2).	
	self deny: (cardinality allowsMoreInvocation: 3).	
]

{ #category : #tests }
BMCardinalityTest >> testDescription [
	cardinality := BMCardinality exactly: 0.
	self assertSubstring: 'never'.
	
	cardinality := BMCardinality exactly: 1.
	self assertSubstring: 'once'.
	
	cardinality := BMCardinality exactly: 2.
	self assertSubstring: 'twice'.	
	
	cardinality := BMCardinality exactly: 3.
	self assertSubstring: '3 times'.

	cardinality := BMCardinality atLeast: 5.
	self assertSubstring: 'at least 5'.
	
	cardinality := BMCardinality atMost: 3.
	self assertSubstring: 'at most 3'.	

	cardinality := BMCardinality between: 2 and: 3.
	self assertSubstring: 'at least 2 at most 3'.
	
	cardinality := BMCardinality anyNumberOfTimes.
	self assertSubstring: 'allowed'.
]

{ #category : #tests }
BMCardinalityTest >> testSatisfies [
	cardinality := BMCardinality between: 2 and: 3.
	self deny: (cardinality satisfied: 0).
	self deny: (cardinality satisfied: 1).	
	self assert: (cardinality satisfied: 2).		
	self assert: (cardinality satisfied: 3).				
	self deny: (cardinality satisfied: 4).				
]
