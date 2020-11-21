"
Represents a mutable state that reports state transitions as announcements.
"
Class {
	#name : #BMState,
	#superclass : #Object,
	#instVars : [
		'name',
		'current',
		'announcer'
	],
	#category : #'BabyMock2-Core'
}

{ #category : #'instance creation' }
BMState class >> name: nameSymbol startsAs: initialStateSymbol [
	^ self new
		setName: nameSymbol
		initialState: initialStateSymbol
]

{ #category : #accessing }
BMState >> announcer [
	^ announcer
]

{ #category : #'state machine' }
BMState >> changeState: newStateSymbol [ 
	announcer announce: (BMStateChange
		name: name
		from: current		
		to: newStateSymbol).
	current := newStateSymbol.
]

{ #category : #'state machine' }
BMState >> currentState [
	^ current
]

{ #category : #'state machine' }
BMState >> describeMismatch: description expected: expectedStateName [
	current = expectedStateName 
		ifFalse: 
			[ self describeTo: description.
			description 				
				appendWarning: ' mismatched: ';
				appendValue: current;
				appendWarning: ', wanted: ';
				appendValue: expectedStateName ]
]

{ #category : #'self describing' }
BMState >> describeTo: aBMDescription [ 
	aBMDescription appendValue: name
]

{ #category : #'state machine' }
BMState >> equals: aByteSymbol [ 
	^ current = aByteSymbol 
]

{ #category : #'initialize-release' }
BMState >> initialize [
	super initialize.
	announcer := Announcer new.
]

{ #category : #'initialize-release' }
BMState >> setName: nameSymbol initialState: initStateSymbol [
	name := nameSymbol.
	current := initStateSymbol.
]
