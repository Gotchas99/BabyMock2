Class {
	#name : #BMExpectationTest,
	#superclass : #BabyMock2TestCase,
	#instVars : [
		'exp',
		'sourceObject',
		'state'
	],
	#category : #'BabyMock2-Core-Tests'
}

{ #category : #private }
BMExpectationTest >> assert: aBMExpectation hasDescription: aString [
	self 
		assert: (BMDescription asString: aBMExpectation) 
		equals: aString
]

{ #category : #private }
BMExpectationTest >> binaryExpectationArg: arg [
	^ BMExpectation define
		selectorMatcher: (BMSelectorMatcher selector: #+);
		objectMatcher: (BMObjectMatcher sameAs: sourceObject);
		cardinality: BMCardinality anyNumberOfTimes;
		argumentMatcher: (BMSingleArgMatcher argumentIs: arg);
		yourself
]

{ #category : #private }
BMExpectationTest >> keywordExpectation [
	^ BMExpectation define
		selectorMatcher: (BMSelectorMatcher selector: #at:put:);
		objectMatcher: (BMObjectMatcher sameAs: sourceObject);
		cardinality: BMCardinality anyNumberOfTimes;
		argumentMatcher: (BMManyArgMatcher 
			withMatchers: { 'key' asBabyMockArgumentMatcher. 'value' asBabyMockArgumentMatcher })
		yourself
]

{ #category : #running }
BMExpectationTest >> setUp [
	sourceObject := BMMockIdentity 
		named: 'test' 
		proxy: nil 
		expectationCollector: nil.
	state := BMState name: 'test state' startsAs: #uninitialized.
]

{ #category : #'tests - answer' }
BMExpectationTest >> testAnswer [
	exp := BMExpectation define addAction: [ 42 ].
	self assert: 42 equals: (exp invoke: nil).
]

{ #category : #'tests - describing messages' }
BMExpectationTest >> testDescribeBinary [
	exp := self binaryExpectationArg: 32.
	self 
		assert: (BMDescription asString: exp) 
		equals: 'allowed, never received test + 32'.	
]

{ #category : #'tests - describing messages' }
BMExpectationTest >> testDescribeKeyword [
	exp := self keywordExpectation.		
	self 
		assert: (BMDescription asString: exp) 
		equals: 'allowed, never received test at:put: with: ''key'' and: ''value'''.	
]

{ #category : #'tests - describing mismatch' }
BMExpectationTest >> testDescribeMismatchBinary [
	| description |
	description := BMTextDescription new.
	
	exp := self binaryExpectationArg: 3.
	exp 
		describeMismatch: description 
		message: (Message selector: #+ arguments: {2}) 
		from: sourceObject.
		
	self assert: (description asText asString includesSubstring: 'argument mismatched: 2, wanted: 3').
]

{ #category : #'tests - describing mismatch' }
BMExpectationTest >> testDescribeMismatchKeyword [
	| description |
	description := BMTextDescription new.
	
	exp := self keywordExpectation.		
	exp 
		describeMismatch: description 
		message: (Message selector: #at:put: arguments: {1. 'value'}) 
		from: sourceObject.
		
	self assert: (description asText asString includesSubstring: '1. argument mismatched: 1, wanted: ''key''').
	self assert: (description asText asString includesSubstring: '2. argument matched: ''value''').	
]

{ #category : #'tests - describing cardinality' }
BMExpectationTest >> testDescribeWhenAllowed [
	exp := self unaryExpectationCardinality: BMCardinality anyNumberOfTimes.
	self assert: exp hasDescription: 'allowed, never received test unary'.
]

{ #category : #'tests - describing cardinality' }
BMExpectationTest >> testDescribeWhenExpectedAtLeast [
	exp := self unaryExpectationCardinality: (BMCardinality atLeast: 3).
	3 timesRepeat: [ exp invoke: nil ].
	self assert: exp hasDescription: 'expected at least 3 times, already received 3 times test unary'.	

]

{ #category : #'tests - describing cardinality' }
BMExpectationTest >> testDescribeWhenExpectedAtLeastAtMost [
	exp := self unaryExpectationCardinality: (BMCardinality between: 2 and: 5).		
	3 timesRepeat: [ exp invoke: nil ].
	self assert: exp hasDescription: 'expected at least 2 at most 5 times, already received 3 times test unary'.	

]

{ #category : #'tests - describing cardinality' }
BMExpectationTest >> testDescribeWhenExpectedAtMost [
	exp := self unaryExpectationCardinality: (BMCardinality atMost: 5).
	exp invoke: nil.
	self assert: exp hasDescription: 'expected at least 1 at most 5 times, already received 1 times test unary'.	

]

{ #category : #'tests - describing cardinality' }
BMExpectationTest >> testDescribeWhenExpectedNever [
	exp := self unaryExpectationCardinality: (BMCardinality never).
	self assert: exp hasDescription: 'expected never, never received test unary'.	
]

{ #category : #'tests - describing cardinality' }
BMExpectationTest >> testDescribeWhenExpectedOnce [
	exp := self unaryExpectationCardinality: (BMCardinality exactly: 1).
	exp invoke: nil.
	self assert: exp hasDescription: 'expected once, already received 1 times test unary'.	

]

{ #category : #'tests - describing cardinality' }
BMExpectationTest >> testDescribeWhenExpectedTimes [
	exp := self unaryExpectationCardinality: (BMCardinality exactly: 12).
	12 timesRepeat: [ exp invoke: nil ].
	self assert: exp hasDescription: 'expected 12 times, already received 12 times test unary'.	
]

{ #category : #'tests - sideffects' }
BMExpectationTest >> testDoingSideEffects [
	| coll |
	coll := OrderedCollection new.
	exp := self unaryExpectationCardinality: BMCardinality anyNumberOfTimes.	
	exp 
		addSideEffect: [ coll add: 1 ];
		addSideEffect: [ coll add: 2 ].
	exp sideEffect.
	
	self assert: #(1 2) equals: coll asArray.

]

{ #category : #'tests - describing mismatch' }
BMExpectationTest >> testEmptyDescriptionWhenNoMismatch [
	| description |
	description := BMTextDescription new.
	
	exp := self keywordExpectation.		
	exp 
		describeMismatch: description 
		message: (Message selector: #other:kwmsg: arguments: {'key'. 'value'}) 
		from: sourceObject.
		
	self assert: description asText asString equals: ''.
]

{ #category : #'tests - describing count' }
BMExpectationTest >> testInvocationCount [
	exp := self unaryExpectationCardinality: BMCardinality anyNumberOfTimes.			
	5 timesRepeat: [ exp invoke: nil ].		
	self assert: exp hasDescription: 'allowed, already received 5 times test unary'.	
]

{ #category : #'tests - message matching' }
BMExpectationTest >> testMatchesBinary [
	exp := self binaryExpectationArg: 42.
	self 
		assert: (exp matchesMessage: (Message 
				selector: #+ 
				argument: 42)
			fromObject: sourceObject);
			
		deny: (exp matchesMessage: (Message 
				selector: #+ 
				argument: 17)
			fromObject: sourceObject);
			
		deny: (exp matchesMessage: (Message 
				selector: #* 
				argument: 42)
			fromObject: sourceObject).				
]

{ #category : #'tests - state matching' }
BMExpectationTest >> testMatchesCorrectState [
	exp := self unaryExpectationCardinality: BMCardinality anyNumberOfTimes.
	exp expectedStateIs: state -> #expectedState.
	
	self 
		deny: (exp matchesMessage: (Message selector: #unary) fromObject: sourceObject).
	state changeState: #expectedState.		
	self		
		assert: (exp matchesMessage: (Message selector: #unary) fromObject: sourceObject).		

]

{ #category : #'tests - message matching' }
BMExpectationTest >> testMatchesKeyword [
	exp := self keywordExpectation.
	self 
		assert: (exp matchesMessage: (Message 
				selector: #at:put: 
				arguments: #(key value)) 
			fromObject: sourceObject);
			
		deny: (exp matchesMessage: (Message 
				selector: #at:putOther: 
				arguments: #(key value)) 
			fromObject: sourceObject);
			
		deny: (exp matchesMessage: (Message 
				selector: #at:put: 
				arguments: #(key2 value))
			fromObject: sourceObject);
			
		deny: (exp matchesMessage: (Message 
				selector: #at:put: 
				arguments: #(key value)) 
			fromObject: 'other')							

]

{ #category : #'tests - message matching' }
BMExpectationTest >> testMatchesUnary [
	exp := self unaryExpectationCardinality: BMCardinality anyNumberOfTimes.
	self 
		assert: (exp matchesMessage: (Message selector: #unary) fromObject: sourceObject);		
		deny: (exp matchesMessage: (Message selector: #other) fromObject: sourceObject);
		deny: (exp matchesMessage: (Message selector: #unary) fromObject: 'other').		
]

{ #category : #'tests - cardinality matching' }
BMExpectationTest >> testMatchesWhenAllowed [
	exp := self unaryExpectationCardinality: BMCardinality anyNumberOfTimes.
	10 timesRepeat: 
		[ 
			self assert: 
				(exp 
					matchesMessage: (Message selector: #unary) 
					fromObject: sourceObject).
			exp invoke: nil.
		]					
]

{ #category : #'tests - cardinality matching' }
BMExpectationTest >> testMatchesWhenInvocedLessThanMax [
	exp := self unaryExpectationCardinality: (BMCardinality exactly: 2).
	
	self assert: (exp matchesMessage: (Message selector: #unary) fromObject: sourceObject).	
	exp invoke: nil.
	
	self assert: (exp matchesMessage: (Message selector: #unary) fromObject: sourceObject).	
	exp invoke: nil.
	
	self deny: (exp matchesMessage: (Message selector: #unary) fromObject: sourceObject).

]

{ #category : #'tests - answer' }
BMExpectationTest >> testMultipleAnswer [
	exp := BMExpectation define
		addAction: [ 1 ]; 
		addAction: [ 2 ];
		yourself.
	self assert: (exp invoke: nil) equals: 1.
	self assert: (exp invoke: nil) equals: 2.
	self assert: (exp invoke: nil) equals: 2.
]

{ #category : #'tests - sideffects' }
BMExpectationTest >> testNoSideEffectByDefault [
	exp := self unaryExpectationCardinality: BMCardinality anyNumberOfTimes.
	exp sideEffect.

]

{ #category : #'tests - satisfy' }
BMExpectationTest >> testSatisfyAllow [	
	exp := BMExpectation define
		cardinality: (BMCardinality anyNumberOfTimes).
		
	self assert: exp satisfied.		
	10 timesRepeat: [ exp invoke: nil ].
	self assert: exp satisfied.			
	

]

{ #category : #'tests - satisfy' }
BMExpectationTest >> testSatisfyAtLeast [
	exp := BMExpectation define
		cardinality: (BMCardinality atLeast: 2).		
				
	self deny: exp satisfied.	
	exp invoke: nil.
	self deny: exp satisfied.	
	exp invoke: nil.
	self assert: exp satisfied.	
	exp invoke: nil.
	self assert: exp satisfied.	
]

{ #category : #'tests - satisfy' }
BMExpectationTest >> testSatisfyAtLeastAtMost [
	exp := BMExpectation define
		cardinality: (BMCardinality between: 1 and:  2).		
				
	self deny: exp satisfied.	
	exp invoke: nil.
	self assert: exp satisfied.	
	exp invoke: nil.
	self assert: exp satisfied.	
	exp invoke: nil.
	self deny: exp satisfied.	
]

{ #category : #'tests - satisfy' }
BMExpectationTest >> testSatisfyAtMost [
	exp := BMExpectation define
		cardinality: (BMCardinality atMost: 2).		
				
	self deny: exp satisfied.	
	exp invoke: nil.
	self assert: exp satisfied.	
	exp invoke: nil.
	self assert: exp satisfied.	
	exp invoke: nil.
	self deny: exp satisfied.	
]

{ #category : #'tests - satisfy' }
BMExpectationTest >> testSatisfyExactly [
	exp := BMExpectation define
		cardinality: (BMCardinality exactly: 2).		
				
	self deny: exp satisfied.		
	exp invoke: nil.
	self deny: exp satisfied.		
	exp invoke: nil.
	self assert: exp satisfied.
]

{ #category : #'tests - describing state' }
BMExpectationTest >> testStateDescription [
	exp := self unaryExpectationCardinality: BMCardinality anyNumberOfTimes.
	exp expectedStateIs: state -> #expectedState.
	self assert: exp hasDescription: 'allowed, never received test unary; when test state is expectedState'.
]

{ #category : #'tests - describing state' }
BMExpectationTest >> testStateDescriptionMismatch [
	| description |
	description := BMTextDescription new.
	exp := self unaryExpectationCardinality: BMCardinality anyNumberOfTimes.
	exp expectedStateIs: state -> #expectedState.	
	exp 
		describeMismatch: description 
		message: (Message selector: #unary) 
		from: sourceObject.	
	
	self assert: (description asText asString includesSubstring: 'test state mismatched: uninitialized, wanted: expectedState').
]

{ #category : #private }
BMExpectationTest >> unaryExpectationCardinality: aBMCardinality [
	^ BMExpectation define
		selectorMatcher: (BMSelectorMatcher selector: #unary);
		objectMatcher: (BMObjectMatcher sameAs: sourceObject);
		cardinality: aBMCardinality;
		yourself
]
