Class {
	#name : #BMMockTest,
	#superclass : #TestCase,
	#instVars : [
		'mock',
		'babyMock',
		'protocol'
	],
	#category : #'BabyMock2-Core-Tests'
}

{ #category : #private }
BMMockTest >> assertException: exception hasDescription: aString [
	self assert: (exception description includesSubstring: aString caseSensitive: false).
]

{ #category : #private }
BMMockTest >> checkIdentity: a with: b [
	self assert: a = a.
	self assert: a == a.
	self assert: a ~= b.
	self assert: b ~= a.
	self assert: b == b.
	self assert: a ~= 5.
	self assert: 3 ~= b.
	self assert: a hash = a hash.
	self assert: a hash ~= b hash.
	self assert: a = a yourself.
	self assert: a yourself = a.
	self assert: a yourself = a yourself.
	self assert: a yourself ~= b yourself
]

{ #category : #running }
BMMockTest >> setUp [
	babyMock := BabyMock forSUnit.
	protocol := BMCascadingProtocol babyMock: babyMock.
	mock := protocol mock: 'testMock'.
]

{ #category : #'tests - min max' }
BMMockTest >> testAboveMinMaxCausesFailure [
	protocol describe
		atLeast: 1 atMost: 3 times: mock recv: #msg.
	self should: [ 4 timesRepeat: [ mock msg ] ] raise: BMTestFailure.
]

{ #category : #'tests - ignoring' }
BMMockTest >> testAnythingCanBeCombinedWithArgs [
	protocol describe
		allow: mock recv:  Anything; with: 1 and: 2; => 3.
	self assert: (mock a: 1 b: 2) equals: 3.
	self assert: (mock x: 1 y: 2) equals: 3.
	self should: [ mock a: 1 b: 3 ] raise: BMTestFailure.
	self should: [ mock a: 3 b: 2 ] raise: BMTestFailure.
	self should: [ mock a: 1 ] raise: BMTestFailure.
	self should: [ mock b: 2 ] raise: BMTestFailure.
	self should: [ mock a: 1 b: 2 c: 3 ] raise: BMTestFailure.
	self should: [ mock a ] raise: BMTestFailure.	
	self should: [ mock + 3 ] raise: BMTestFailure.
	babyMock assertSatisfied.
	
	
]

{ #category : #'tests - object messages' }
BMMockTest >> testAsOrderdCollection [
        | items |
        protocol describe
                once: mock recv: #foo; => nil.
        items := mock asOrderedCollection.
        items first foo.
]

{ #category : #'tests - min max' }
BMMockTest >> testBelowMinMaxCausesFailure [
	protocol describe
		atLeast: 2 atMost: 3 times: mock recv: #msg.
	mock msg.
	self should: [ babyMock assertSatisfied ] raise: BMTestFailure.
]

{ #category : #'tests - min max' }
BMMockTest >> testBetweenMinMaxCausesNoFailure [
	protocol describe
		atLeast: 2 atMost: 4 times: mock recv: #msg.
	3 timesRepeat: [ mock msg ].
	babyMock assertSatisfied.
]

{ #category : #'tests - answer' }
BMMockTest >> testBlockActionReceivesArguments [
	| a b |
	protocol describe
		once: mock recv: #a:b:; 
		=> [ :x :y | a := x. b := y ].
	mock a: 5 b: 9.
	self assert: a equals: 5.
	self assert: b equals: 9.	
]

{ #category : #'tests - answer' }
BMMockTest >> testBlockActionReceivesOptionalArguments [
	| a |
	protocol describe
		once: mock recv: #a:b:; 
		=> [ :x | a := x ].
	mock a: 6 b: 'any'.
	self assert: a equals: 6.

]

{ #category : #'tests - object messages' }
BMMockTest >> testConsumesObjectMessages [
	self assert: mock class equals: BMMockIdentity.
]

{ #category : #'tests - multiple mocks' }
BMMockTest >> testDispatchBetweenTwoMocks [
	| mock1 mock2 |
	mock1 := protocol mock: 'mock1'.
	mock2 := protocol mock: 'mock2'.
		
	protocol describe
		allow: mock1 recv: #stub; => 1;
		once: mock1 recv: #once; => 'a';
		allow: mock2 recv: #stub; => 2;	
		once: mock2 recv: #once; => 'b'.
	self assert: mock1 stub equals: 1.
	self assert: mock2 stub equals: 2.	
	self assert: mock2 once equals: 'b'.	
	self assert: mock1 once equals: 'a'.	
	babyMock assertSatisfied.
]

{ #category : #'tests - special dispatch' }
BMMockTest >> testDispatchesToTheSecondMethodAfterTheFirstInvoked [
	protocol describe
		once: mock recv: #msg; => 1;
		once: mock recv: #msg; => 2.
	self assert: mock msg equals: 1.
	self assert: mock msg equals: 2.
]

{ #category : #'tests - special dispatch' }
BMMockTest >> testDispatchesToTheSecondMethodAfterTheFirstInvokedInAState [
	| state |
	state := BMState name: 'state' startsAs: #first.	
	protocol describe
		allow: mock recv: #msg; => 1; 
			when: state is: #first; then: state is: #second;
		allow: mock recv: #msg; => 2; 
			when: state is: #second.	
	self assert: mock msg equals: 1.
	self assert: mock msg equals: 2.
]

{ #category : #'tests - does not receive' }
BMMockTest >> testDoesNotReceiveBinaryMessageShouldTriggerError [
	protocol describe
		once: mock recv: #*.
	self should: 
		[ babyMock assertSatisfied ] 
	raise: BMTestFailure withExceptionDo: [:ex | 
		self 
			assertException: ex 
			hasDescription: 'expected once, never received testMock *' ]
]

{ #category : #'tests - does not receive' }
BMMockTest >> testDoesNotReceiveKeywordMessageShouldTriggerError [
	protocol describe
		once: mock recv: #keyword:.
	self should: [ 
		babyMock assertSatisfied. 
	] raise: BMTestFailure withExceptionDo: [:ex |
		self 
			assertException: ex 
			hasDescription: 'expected once, never received testMock keyword:' ]
]

{ #category : #'tests - does not receive' }
BMMockTest >> testDoesNotReceiveUnaryMessageShouldTriggerError [
	protocol describe
		once: mock recv: #msg.
	self should: [ 
		babyMock assertSatisfied. 
	] raise: BMTestFailure withExceptionDo: [:ex |
		self 
			assertException: ex 
			hasDescription: 'expected once, never received testMock msg' ]
]

{ #category : #'tests - stubbing' }
BMMockTest >> testDoesNotReportsProblemNoMessageReceived [
	protocol describe
		allow: mock recv: #get; => 'testval';
		allow: mock recv: #x:y:; => 'testval'.
	babyMock assertSatisfied.
]

{ #category : #'tests - ignoring' }
BMMockTest >> testIgnoreMock [
	protocol describe
		ignore: mock.
	mock
		asd;
		+ 3;
		atKey: 1 putVal: 3.
]

{ #category : #'tests - ignoring' }
BMMockTest >> testIgnoredMockCanAnswersResult [
	protocol describe
		allow: mock recv:  Anything; => 88.
	self assert: mock asdf equals: 88.
	babyMock assertSatisfied.
	
]

{ #category : #'tests - ignoring' }
BMMockTest >> testIgnoredMockCanReceiveAnything [
	protocol describe
		allow: mock recv:  Anything.
	mock 
		asdf;
		asdf;
		a: 1 b: 2;
		+ 3.
	babyMock assertSatisfied.	
]

{ #category : #'tests - ignoring' }
BMMockTest >> testItsOkNotToReceiveAnythingWithIgnoredMock [
	protocol describe
		allow: mock recv:  Anything.
	babyMock assertSatisfied.
	
]

{ #category : #'tests - multiple protocol desc' }
BMMockTest >> testMergesProtocolDescriptions [
	protocol describe
		once: mock recv: #msg1; => 1.
	protocol describe
		once: mock recv: #msg2; => 2.		
			
	self assert: mock msg1 equals: 1.
	self assert: mock msg2 equals: 2.				
	babyMock assertSatisfied.	
]

{ #category : #'tests - min max' }
BMMockTest >> testMinMaxCausesNoFailureWhenMaximumReached [
	protocol describe
		atLeast: 2 atMost: 3 times: mock recv: #msg.
	3 timesRepeat: [ mock msg ].
	babyMock assertSatisfied.
]

{ #category : #'tests - min max' }
BMMockTest >> testMinMaxCausesNoFailureWhenMinimumReached [
	protocol describe
		atLeast: 2 atMost: 3 times: mock recv: #msg.
	2 timesRepeat: [ mock msg ].
	babyMock assertSatisfied.
]

{ #category : #'tests - object messages' }
BMMockTest >> testMissingObjectMessage [
	protocol describe
		once: mock recv: #class.
	self should: [ babyMock assertSatisfied ] raise: BMTestFailure.
]

{ #category : #'tests - ignoring' }
BMMockTest >> testMixingAnyArgumentWithAnySelector [
	protocol describe
		allow: mock recv: Anything; 
		with: 1 and: Anything and: 2; 
		=> 34.		
	self assert: (mock as: 1 df: 'something' gh: 2) equals: 34.
	babyMock assertSatisfied.
	
]

{ #category : #'tests - args' }
BMMockTest >> testMixingAnyArgumentWithExactArgument [
	protocol describe
		allow: mock recv: #a:b:c:; 
			with: 1 and: Anything and: 2;
			=> 20.
	self assert: (mock a: 1 b: 'any123' c: 2) equals: 20.
	

]

{ #category : #'tests - mock properties' }
BMMockTest >> testMockClass [
	mock := protocol mock: 'nameOfMock'.	
	self assert: mock class equals: BMMockIdentity.
	self assert: mock asString equals: 'nameOfMock'.
]

{ #category : #'tests - object messages' }
BMMockTest >> testMockingObjectMessages [
	protocol describe
		once: mock recv: #class; => 'stubbed'.		
	self assert: mock class equals: 'stubbed'.
]

{ #category : #'tests - validation' }
BMMockTest >> testNameMustBeUnique [
	protocol mock: 'same'.	
	self should: [ protocol mock: 'same' ] raise: BMMockError.
]

{ #category : #'tests - multiple mocks' }
BMMockTest >> testOneSatisfiedOneUnsatisfied [
	| mock1 mock2 |
	mock1 := protocol mock: 'mock1'.
	mock2 := protocol mock: 'mock2'.
		
	protocol describe
		once: mock1 recv: #once;
		once: mock2 recv: #once.
	mock2 once.

	self should: [ 
		babyMock assertSatisfied. 
	] raise: BMTestFailure withExceptionDo: [:ex |
		self assert: (ex description includesSubstring: 'mock1').
	]
]

{ #category : #'tests - send with reflection' }
BMMockTest >> testPerformMessageReflection [
	protocol describe
		once: mock recv: #msg; => 23.
	self assert: (mock perform: #msg) equals: 23.
	babyMock assertSatisfied.
]

{ #category : #'tests - maximum' }
BMMockTest >> testReceivedAsManyTimesAsMaximumCausesNoFailure [
	protocol describe
		atMost: 2 times:  mock recv: #msg.
	2 timesRepeat: [ mock msg ].
	babyMock assertSatisfied.
	
]

{ #category : #'tests - minumum' }
BMMockTest >> testReceivedAsManyTimesAsMinimumCausesNoFailure [
	protocol describe
		atLeast: 2 times: mock recv: #msg.
	2 timesRepeat: [ mock msg ].
	babyMock assertSatisfied.
]

{ #category : #'tests - exactly' }
BMMockTest >> testReceivedExactlyAsManyTimesAsExpectedCausesNoFailure [
	protocol describe
		twice: mock recv: #msg.
	2 timesRepeat: [ mock msg ].
	babyMock assertSatisfied.
	
]

{ #category : #'tests - exactly' }
BMMockTest >> testReceivedLessThanExpectedCausesFailure [
	protocol describe
		exactly: 3 times: mock recv: #msg.
	2 timesRepeat: [ mock msg ].
	self should: [ babyMock assertSatisfied ] raise: BMTestFailure.
	
]

{ #category : #'tests - maximum' }
BMMockTest >> testReceivedLessThanMaximumButMoreThanOnceCausesNoFailure [
	protocol describe
		atMost: 5 times:  mock recv: #msg.
	3 timesRepeat: [ mock msg ].
	babyMock assertSatisfied.
	
]

{ #category : #'tests - minumum' }
BMMockTest >> testReceivedLessThanMinimumCausesFailure [
	protocol describe
		atLeast: 2 times: mock recv: #msg.
	mock msg.
	self 
		should: [ babyMock assertSatisfied ] 
		raise: BMTestFailure 
		withExceptionDo: 
			[:ex | self deny: (ex description includesSubstring: 'at most' caseSensitive: false) ]
]

{ #category : #'tests - exactly' }
BMMockTest >> testReceivedMoreThanExpectedCausesFailure [
	protocol describe
		twice: mock recv: #msg.
	self should: [ 3 timesRepeat: [ mock msg ] ] raise: BMTestFailure.
	
]

{ #category : #'tests - maximum' }
BMMockTest >> testReceivedMoreThanMaximumCausesFailure [
	protocol describe
		atMost: 2 times:  mock recv: #msg.
	self should: [ 3 timesRepeat: [ mock msg ] ] raise: BMTestFailure.	
]

{ #category : #'tests - minumum' }
BMMockTest >> testReceivedMoreThanMinimumCausesNoFailure [
	protocol describe
		atLeast: 2 times: mock recv: #msg.
	10 timesRepeat: [ mock msg ].
	babyMock assertSatisfied.
]

{ #category : #'tests - maximum' }
BMMockTest >> testReceivedNeverExpectedMaximumTwiceCausesFailure [
	protocol describe
		atMost: 2 times:  mock recv: #msg.
	self should: [ babyMock assertSatisfied ] raise: BMTestFailure.	
	
]

{ #category : #'tests - receive as expected' }
BMMockTest >> testReceivesBinaryMessageAsExpected [
	protocol describe
		once: mock recv: #+; with: 5.
	mock + 5.
	babyMock assertSatisfied.
]

{ #category : #'tests - does not receive' }
BMMockTest >> testReceivesExpectedMessageButWithDifferentArguments [
	protocol describe
		once: mock recv: #x:y:; with: 5 and: 6.
	self should: [ 
		mock x: 5 y: 8 
	] raise: BMTestFailure withExceptionDo: [:ex |
		self 
			assertException: ex 
			hasDescription: 'expected once, never received testMock x:y:'.
		self 
			assertException: ex 
			hasDescription: '2. argument mismatched: 8, wanted: 6']
]

{ #category : #'tests - receive as expected' }
BMMockTest >> testReceivesKeywordMessageAsExpected [
	protocol describe
		once: mock recv: #keyword:.
	mock keyword: 'anyarg'.
	babyMock assertSatisfied.
]

{ #category : #'tests - does not receive' }
BMMockTest >> testReceivesKeywordMessageInsteadOfUnary [
	protocol describe
		once: mock recv: #arg.
	self should: [ mock arg: 1 ] raise: BMTestFailure.
]

{ #category : #'tests - receive as expected' }
BMMockTest >> testReceivesKeywordMessageWithArgsAsExpected [
	protocol describe
		once: mock recv: #x:y: ; with: 1 and: 2.
	mock x: 1 y: 2.
	babyMock assertSatisfied.
]

{ #category : #'tests - cardinality' }
BMMockTest >> testReceivesOnceExpectedNever [
	protocol describe
		never: mock recv: #msg.
	self should: [ mock msg ] raise: BMTestFailure.
	
]

{ #category : #'tests - cardinality' }
BMMockTest >> testReceivesTwiceExpectedOnce [
	protocol describe
		once: mock recv: #msg.
	mock msg.	
	self should: [ mock msg ] raise: BMTestFailure.
	
]

{ #category : #'tests - receive as expected' }
BMMockTest >> testReceivesUnaryMessageAsExpected [
	protocol describe
		once: mock recv: #msg.
	mock msg.
	babyMock assertSatisfied.
]

{ #category : #'tests - does not receive' }
BMMockTest >> testReceivesUnaryMessageInsteadOfKeyword [
	protocol describe
		once: mock recv: #arg:.
	self should: [ mock arg ] raise: BMTestFailure.
]

{ #category : #'tests - cardinality' }
BMMockTest >> testReceivesWithDifferentArgsMustBeAllowed [
	protocol describe
		never: mock recv: #get: ; with: 'forbidden';
		allow: mock recv: #get: ; with: 'allowed'. 
	mock get: 'allowed'.
	babyMock assertSatisfied. 
]

{ #category : #'tests - answer' }
BMMockTest >> testReturnsAnswerForBinaryMessage [
	protocol describe
		once: mock recv: #*; with: 3; => 42.
	self assert: 42 equals: mock * 3.
]

{ #category : #'tests - answer' }
BMMockTest >> testReturnsAnswerForKeywordMessage [
	protocol describe
		once: mock recv: #get:; with: 'key'; => 42.
	self assert: 42 equals: (mock get: 'key').
]

{ #category : #'tests - answer' }
BMMockTest >> testReturnsAnswerForUnaryMessage [
	protocol describe
		once: mock recv: #get;  => 42.
	self assert: 42 equals: mock get.
]

{ #category : #'tests - answer' }
BMMockTest >> testReturnsAnswersNilByDefault [
	protocol describe
		once: mock recv: #get.
	self assert: nil equals: mock get.
]

{ #category : #'tests - stubbing' }
BMMockTest >> testReturnsStubbedValue [
	protocol describe
		allow: mock recv: #get; => 'testval'.
	self assert: 'testval' equals: mock get.
]

{ #category : #'tests - identity' }
BMMockTest >> testSchizophrenia [
	self 
		checkIdentity: (protocol mock: 'A') 
		with: (protocol mock: 'B').
	self 
		checkIdentity: (BMMockIdentity named: 'A' proxy: nil expectationCollector: nil) 
		with: (BMMockIdentity named: 'B' proxy: nil expectationCollector: nil).
]

{ #category : #'tests - send with reflection' }
BMMockTest >> testSendMessageReflection [
	| msg |
	msg := Message selector: #msg.
	protocol describe
		once: mock recv: #msg; => 2.
	self assert: (msg sendTo: mock) equals: 2.
	babyMock assertSatisfied.
]

{ #category : #'tests - identity' }
BMMockTest >> testSendingMessageToMockStoredInSet [
	| set |
	set := Set with: mock.
	protocol describe
		once: mock recv: #msg.
	set do: [ :each | each msg ].	
	babyMock assertSatisfied.
]

{ #category : #'tests - args' }
BMMockTest >> testShouldDifferentiateMessageByArguments [
	protocol describe
		allow: mock recv: #get: ; with: 1; => 1;
		allow: mock recv: #get: ; with: 2; => 2;
		allow: mock recv: #a:b: ; with: 1 and: 2; => 3.
	self assert: (mock get: 1) equals: 1.
	self assert: (mock get: 2) equals: 2.
	self assert: (mock a: 1 b: 2) equals: 3.
	

]

{ #category : #'tests - mixed args' }
BMMockTest >> testShouldSupportMixedArgs [
	protocol describe
		allow: mock recv: #a:b:c: ; 
		with: [:a | a = 'a'] and: 'b' and: [:c | c = 'c']; => 'val1'.
	self assert: (mock a: 'a' b: 'b' c: 'c') equals: 'val1'.
		
	protocol describe
		allow: mock recv: #a:b:c:d: ; 
		with: 'a' and: [:b | b = 'b'] and: 'c' and: [:d | d = 'd']; => 'val2'.
	self assert: (mock a: 'a' b: 'b' c: 'c' d: 'd') equals: 'val2'.
]

{ #category : #'tests - state' }
BMMockTest >> testSignalsErrorWhenItIsNotInTheCorrectState [
	| state |
	state := protocol states: #stateName startsAs: #init.		
	protocol describe
		once: mock recv: #msg; when: state is: #incorrectState.
	self 
		should: [ mock msg ] 
		raise: BMTestFailure 
		withExceptionDo: [ :ex |
			self assertException: ex hasDescription: 'when stateName is incorrectState'. 
			self assertException: ex hasDescription: 'stateName mismatched: init, wanted: incorrectState']	

]

{ #category : #'tests - state' }
BMMockTest >> testStaysInTheCurrentStateWhenTransitionFailed [
	| state |
	state := protocol states: #stateName startsAs: #init.		
	protocol describe
		once: mock recv: #msg; 
		when: state is: #incorrect; then: state is: #received.
	self 
		should: [ mock msg ] 
		raise: BMTestFailure 
		withExceptionDo: [ :ex |
			self assertException: ex hasDescription: 'stateName mismatched: init, wanted: incorrect' ].
	self assert: (state equals: #init).
	

]

{ #category : #'tests - identity' }
BMMockTest >> testStoringInCollections [
	| insideMock outsideMock collection set dictionary |
	insideMock := protocol mock: 'inside'.
	outsideMock := protocol mock: 'outside'.				
	collection := OrderedCollection with: insideMock.
	set := Set with: insideMock.
	dictionary := { insideMock -> outsideMock } asDictionary.
	
	self assert: (collection includes: insideMock).
	self deny: (collection includes: outsideMock).
	
	self assert: (set includes: insideMock).
	self deny: (set includes: outsideMock).
	
	self assert: (dictionary at: insideMock) equals: outsideMock.
]

{ #category : #'tests - answer' }
BMMockTest >> testSupportsBlockAnswerAsValue [
	protocol describe
		once: mock recv: #getBlock; => [ [ ] ].
	self assert: mock getBlock class equals: BlockClosure .
]

{ #category : #'tests - answer' }
BMMockTest >> testSupportsBlockAnswers [    
	| a b |
	a := 0. b := 0.
	protocol describe
		once: mock recv: #changeA; => [ a := 42 ];
		allow: mock recv: #changeB; => [ b := 24 ].
	mock changeA. 
	mock changeB.
	self assert: 42 equals: a. 
	self assert: 24 equals: b.
]

{ #category : #'tests - args' }
BMMockTest >> testSupportsExactArguments [
	protocol describe
		allow: mock recv: #a: ; with: 1; => 'val0';
		allow: mock recv: #a:b: ; with: 1 and: 2; => 'val1';
		allow: mock recv: #a:b:c: ; with: 1 and: 2 and: 3; => 'val2';
		allow: mock recv: #a:b:c:d: ; with: 1 and: 2 and: 3 and: 4; => 'val3'.
	self assert: (mock a: 1) equals: 'val0'.
	self assert: (mock a: 1 b: 2) equals: 'val1'.
	self assert: (mock a: 1 b: 2 c: 3) equals: 'val2'.
	self assert: (mock a: 1 b: 2 c: 3 d: 4) equals: 'val3'.
]

{ #category : #'tests - answer' }
BMMockTest >> testSupportsExceptionSignal [
	protocol describe
		once: mock recv: #sig; signals: Error.
	self should: [ mock sig ] raise: Error.
]

{ #category : #'tests - answer' }
BMMockTest >> testThaAtStubSupportsConsecutiveAnswers [
	protocol describe
		allow: mock recv: #get; 
			=> 1;
			=> 2;
			=> 3.
	self assert: 1 equals: mock get.
	self assert: 2 equals: mock get.
	self assert: 3 equals: mock get.
]

{ #category : #'tests - answer' }
BMMockTest >> testThatAMockKeepsRepeatingDefaultValue [
	protocol describe
		exactly: 2 times: mock recv: #get.
	self assert: nil equals: mock get.
	self assert: nil equals: mock get.
]

{ #category : #'tests - answer' }
BMMockTest >> testThatAMockSupportsConsecutiveAnswers [
	protocol describe
		exactly: 3 times: mock recv: #get;
			=> 1;
			=> 2;
			=> 3.
	self assert: 1 equals: mock get.
	self assert: 2 equals: mock get.
	self assert: 3 equals: mock get.
]

{ #category : #'tests - answer' }
BMMockTest >> testThatAStubKeepsRepeatingDefaultValue [
	protocol describe
		allow: mock recv: #get.
	self assert: nil equals: mock get.
	self assert: nil equals: mock get.
]

{ #category : #'tests - answer' }
BMMockTest >> testThatAStubSupportsMixsingDifferentConsecutiveActions [
	| s |
	protocol describe
		allow: mock recv: #get;
			signals: Error;
			=> [s := 42];
			=> 1.
	self should: [ mock get ] raise: Error.													
	mock get.
	self assert: s equals: 42.
	self assert: 1 equals: mock get.
]

{ #category : #'tests - answer' }
BMMockTest >> testThatItKeepsRepeatingMockedValue [
	protocol describe
		twice: mock recv: #get; => 42.
	self assert: 42 equals: mock get.
	self assert: 42 equals: mock get.
]

{ #category : #'tests - answer' }
BMMockTest >> testThatItKeepsRepeatingStubbedValue [
	protocol describe
		allow: mock recv: #get; => 42.
	self assert: 42 equals: mock get.
	self assert: 42 equals: mock get.
]

{ #category : #'tests - cardinality' }
BMMockTest >> testThatUnexpectedMessageCausesFailure [
	self should: [ mock unexpected ] raise: BMTestFailure.
]

{ #category : #'tests - state' }
BMMockTest >> testTransitionFromOneStateToAnOther [
	| state |
	state := protocol states: #stateName startsAs: #init.	
	protocol describe
		once: mock recv: #msg1; then: state is: #receivedFirstMsg;
		once: mock recv: #msg2; 
			when: state is: #receivedFirstMsg; 
			then: state is: #receivedSecondMsg.
			
	self assert: (state equals: #init).
	
	mock msg1.
	self assert: (state equals: #receivedFirstMsg).
	
	mock msg2.	
	self assert: (state equals: #receivedSecondMsg).
	

]

{ #category : #'tests - state' }
BMMockTest >> testTransitionFromOneStateToAnOtherWithAnswer [
	| state |
	state := protocol states: #stateName startsAs: #init.
	protocol describe
		once: mock recv: #msg1; 
			=> 1; 
			then: state is: #receivedFirstMsg;
		once: mock recv: #msg2; 
			=> 2; 
			when: state is: #receivedFirstMsg; 
			then: state is: #receivedSecondMsg.
			
	self assert: (state equals: #init).	
	self assert: mock msg1 equals: 1.
	self assert: (state equals: #receivedFirstMsg).	
	self assert: mock msg2 equals: 2.	
	self assert: (state equals: #receivedSecondMsg).
	

]

{ #category : #'tests - object messages' }
BMMockTest >> testUnexpectedObjectMessage [
	protocol describe
		once: mock recv: #isKindOf:; with: 'x'; => 1;
		allow: mock recv: #isKindOf:; with: 'y'; => 3.
	self assert: (mock isKindOf: #x) equals: 1.
	3 timesRepeat: [ self assert: (mock isKindOf: #y) equals: 3 ].
	babyMock assertSatisfied.
	self should: [ mock isKindOf: #x ] raise: BMTestFailure.
]

{ #category : #'tests - validation' }
BMMockTest >> testVisualModeArgumentValidation [
	self should: [ protocol visualize: self ] raise: BMMockError.
	self should: [ protocol visualize: mock ] raise: BMMockError.	
]
