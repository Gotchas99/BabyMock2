"
BabyMock2TestCase extends from the SUnit TestCase and makes easier to use BabyMock in an SUnit environment. The BabyMock2TestCase has a instance variable named the protocol which should be used for creating mocks and setting up expectations. After each test, the protocol checks whether the specified expectations were satisfied or not.
"
Class {
	#name : #BabyMock2TestCase,
	#superclass : #TestCase,
	#instVars : [
		'protocol',
		'babyMock'
	],
	#category : #'BabyMock2-Core'
}

{ #category : #private }
BabyMock2TestCase >> afterPerformTest [
	babyMock assertSatisfied
]

{ #category : #'initialize-release' }
BabyMock2TestCase >> initialize [ 
	super initialize. 
	self initializeBabyMock.
]

{ #category : #'initialize-release' }
BabyMock2TestCase >> initializeBabyMock [
	babyMock := BabyMock forSUnit.
	protocol := BMCascadingProtocol babyMock: babyMock.
]

{ #category : #private }
BabyMock2TestCase >> performTest [ 	
	| passed |
	passed := false.
	[ babyMock testCaseStarted: self.
	  super performTest. 
	  self afterPerformTest.
	  passed := true ] 
		ensure: [ babyMock testCaseEnded: passed ]
]

{ #category : #running }
BabyMock2TestCase >> prepareToRunAgain [ 	
	self initializeBabyMock.
	super prepareToRunAgain.
]
