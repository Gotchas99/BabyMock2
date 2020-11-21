Class {
	#name : #BMMessageMatcherTest,
	#superclass : #BMMatcherTest,
	#instVars : [
		'binarySel',
		'unarySel',
		'oneArgSel',
		'twoArgSel',
		'oneArgMatcher',
		'twoArgsMatcher'
	],
	#category : #'BabyMock2-Core-Tests'
}

{ #category : #running }
BMMessageMatcherTest >> setUp [
	binarySel := BMSelectorMatcher selector: #*.
	unarySel :=  BMSelectorMatcher selector: #unary.
	oneArgSel := BMSelectorMatcher selector: #a:.
	twoArgSel := BMSelectorMatcher selector: #a:b:.	
	oneArgMatcher := BMBlockArgMatcher fromBlock: [:any | true].
	twoArgsMatcher := BMBlockArgMatcher fromBlock: [:any1 :any2 | true].
]

{ #category : #tests }
BMMessageMatcherTest >> testDescribing [
	| matcher |
	matcher := BMMessageMatcher new
			selectorMatcher: (BMSelectorMatcher selector: #a:b:);
			argumentMatcher: (BMManyArgMatcher new
				addMatcher: 3 asBabyMockArgumentMatcher;
				addMatcher: 4 asBabyMockArgumentMatcher;
				yourself).
	self assert: (BMDescription asString: matcher) equals: 'a:b: with: 3 and: 4'.
]

{ #category : #tests }
BMMessageMatcherTest >> testThatAsStringReturnsBinarySelectorWithMatcher [
	| str |	
	str := BMMessageMatcher new
			selectorMatcher: binarySel;
			argumentMatcher: (BMSingleArgMatcher argumentIs: 3);
			printString.
	self assert: str equals: '* 3'.
]

{ #category : #tests }
BMMessageMatcherTest >> testThatAsStringReturnsKeywordSelectorWithMatcher [
	| str |	
	str := BMMessageMatcher new
			selectorMatcher: oneArgSel;
			argumentMatcher: (BMSingleArgMatcher argumentIs: 3);
			printString.
	self assert: str equals: 'a: 3'.
]

{ #category : #tests }
BMMessageMatcherTest >> testThatAsStringReturnsUnarySelector [
	| str |
	str := BMMessageMatcher new
			selectorMatcher: unarySel;
			printString.
	self assert: str equals: 'unary'.
]

{ #category : #tests }
BMMessageMatcherTest >> testThatAsStringReturnsUnknownIfSelectorAndMatcherWasNotSet [
	self 
		assert: 'unknown' 
		equals: BMMessageMatcher new printString.
]

{ #category : #tests }
BMMessageMatcherTest >> testThatItAcceptsTwoArgsMatcherWithTwoArgsSelector [	
	BMMessageMatcher new
		selectorMatcher: twoArgSel;
		argumentMatcher: twoArgsMatcher.
		
	BMMessageMatcher new
		argumentMatcher: twoArgsMatcher;
		selectorMatcher: twoArgSel.
]

{ #category : #tests }
BMMessageMatcherTest >> testThatItDoesAllowToUseBinaryMessageWithOneMatcher [
	BMMessageMatcher new
		selectorMatcher: binarySel;
		argumentMatcher: oneArgMatcher.
		
	BMMessageMatcher new
		argumentMatcher: oneArgMatcher;
		selectorMatcher: binarySel.
]

{ #category : #tests }
BMMessageMatcherTest >> testThatItDoesNotAllowToUseBinaryMessageWithMoreThanOneArgMatcher [
	self should: 
		[ BMMessageMatcher new
			selectorMatcher: binarySel; 
			argumentMatcher: twoArgsMatcher ] raise: BMMockError.
	
	self should: 
		[ BMMessageMatcher new
			argumentMatcher: twoArgsMatcher; 
			selectorMatcher: binarySel ] raise: BMMockError.
]

{ #category : #tests }
BMMessageMatcherTest >> testThatItDoesNotAllowToUseUnaryMessageWithArgumentMatcher [
	self should: 
		[ BMMessageMatcher new
			selectorMatcher: unarySel;
		 	argumentMatcher: oneArgMatcher ] raise: BMMockError.
		
	self should: 
		[ BMMessageMatcher new
			argumentMatcher: oneArgMatcher;
			 selectorMatcher: unarySel ] raise: BMMockError.
]

{ #category : #tests }
BMMessageMatcherTest >> testThatItSignalsErrorForOneArgSelectorAndTwoArgsMatcher [
	self should: 
		[ BMMessageMatcher new
			selectorMatcher: oneArgSel;
			argumentMatcher: twoArgsMatcher ] raise: BMMockError.
	
	self should: 
		[ BMMessageMatcher new
			argumentMatcher: twoArgsMatcher;
			selectorMatcher: oneArgSel ] raise: BMMockError.
]

{ #category : #tests }
BMMessageMatcherTest >> testThatItSignalsErrorForTwoArgSelectorAndOneArgMatcher [
	self should: 
		[ BMMessageMatcher new
			selectorMatcher: twoArgSel;
			argumentMatcher: oneArgMatcher ] raise: BMMockError.
		
	self should: 
		[ BMMessageMatcher new
			argumentMatcher: oneArgMatcher;
			selectorMatcher: twoArgSel ] raise: BMMockError.	
]
