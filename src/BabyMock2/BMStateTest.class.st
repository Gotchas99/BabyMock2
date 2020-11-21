Class {
	#name : #BMStateTest,
	#superclass : #BabyMock2TestCase,
	#category : #'BabyMock2-Core-Tests'
}

{ #category : #tests }
BMStateTest >> testAccessingCurrent [
	| state |
	state := BMState name: 'state' startsAs: #init.	
	self assert: state currentState equals: #init.
]

{ #category : #tests }
BMStateTest >> testCheckingState [
	| state |
	state := BMState name: 'state' startsAs: #init.	
	self deny: (state equals: #incorrect).
]

{ #category : #tests }
BMStateTest >> testNotifesAboutStateChange [
	| listener state |
	listener := protocol mock: 'state listener'.
	state := BMState name: 'state' startsAs: #init.
	state announcer when: BMStateChange send: #stateChanged: to: listener.
	
	protocol describe
		once: listener recv: #stateChanged:; with: (BMStateChange name: 'state' from: #init to: #newState).
	state changeState: #newState.
]

{ #category : #tests }
BMStateTest >> testTransitionToOtherState [
	| state |
	state := BMState name: 'state' startsAs: #init.		
	self assert: (state equals: #init).
	state changeState: #second.
	self assert: (state equals: #second).
]
