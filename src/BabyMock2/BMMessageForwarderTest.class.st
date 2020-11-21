Class {
	#name : #BMMessageForwarderTest,
	#superclass : #BabyMock2TestCase,
	#instVars : [
		'forwarder',
		'listener',
		'target',
		'testContext',
		'codeContext',
		'msgToBeForwarded'
	],
	#category : #'BabyMock2-Core-Tests'
}

{ #category : #matchers }
BMMessageForwarderTest >> answer: anAnswer [
	^ [: its | 
		(its payload = anAnswer) &
		(its matchesSender: target) & 
		(its matchesReceiver: self) ]
]

{ #category : #private }
BMMessageForwarderTest >> codeContext [
	| ctx |
	ctx := thisContext.
	[ctx receiver isKindOf: BabyMock2TestCase] 
		whileTrue: [ ctx := ctx sender. ].
	^ ctx.
]

{ #category : #matchers }
BMMessageForwarderTest >> message: aMessage [
	^ [: its | 
		(its payload = aMessage) &
		(its matchesSender: self) & 
		(its matchesReceiver: target) ]
]

{ #category : #running }
BMMessageForwarderTest >> setUp [
	msgToBeForwarded := Message selector: #forward: argument: 42.
	testContext := thisContext.
	codeContext := self codeContext.
	target := protocol mock: 'target'.
	listener := protocol mock: 'listener'.
	forwarder := BMMessageForwarder new.
	forwarder announcer
			when: BMExpectedMessage send: #message: to: listener;
			when: BMMessageAnswer send: #answer: to: listener;
			when: BMMessageException send: #exception: to: listener.
]

{ #category : #tests }
BMMessageForwarderTest >> testThatItForwardsMessageAndNotifiesListener [
	protocol describe
		once: listener recv: #message:; with: (self message: msgToBeForwarded);
		once: target recv: #forward:; with: 42; => 'result';
		once: listener recv: #answer:;  with: (self answer: 'result').
	self 
		assert: 'result' 
		equals: (forwarder 
			messageIntercepted: msgToBeForwarded 
			source: testContext 
			destination: target).
]

{ #category : #tests }
BMMessageForwarderTest >> testThatItNotifiesListenerAboutException [	
	protocol describe
		once: listener recv: #message:; with: (self message: msgToBeForwarded);
		once: target recv: #forward:; with: 42; signals: Warning;
		once: listener recv: #exception:; with: self warning.
	self should:
		[ forwarder 
			messageIntercepted: msgToBeForwarded 
			source: testContext 
			destination: target ] raise: Warning.
]

{ #category : #matchers }
BMMessageForwarderTest >> warning [
	^ [ :its |
			(its payload isKindOf: Warning) &
			(its matchesSender: target) & 
			(its matchesReceiver: self) ]
]
