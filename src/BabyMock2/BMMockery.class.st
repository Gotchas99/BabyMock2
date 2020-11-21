"
The mockery creates mock objects with a message listener attached to them. A mock object is a proxy that has a separate identity defined by an other object.
"
Class {
	#name : #BMMockery,
	#superclass : #Object,
	#instVars : [
		'dispatcher',
		'mocks',
		'errorTranslator'
	],
	#category : #'BabyMock2-Core'
}

{ #category : #'instance creation' }
BMMockery class >> messageDispatcher: messageDispatcher errorTranslator: anErrorTranslator [
	^ self new 
		setMessageDispatcher: messageDispatcher
		errorTranslator: anErrorTranslator
]

{ #category : #private }
BMMockery >> dispatchMessage: aMessage from: sourceMethodCtx to: aBmMessageProxy [
	^  [ dispatcher 
			mock: aBmMessageProxy 
			received: aMessage 
			from: sourceMethodCtx ]		
		on: BMExpectationError 
		do: [ :ex | errorTranslator translateError: ex ]
	

]

{ #category : #private }
BMMockery >> findMockByProxy: aBmMessageProxy [
	| nameMockAssoc |
	nameMockAssoc := mocks 
		detect: [ :each | each value == aBmMessageProxy ]
		ifNone: [ self error: 'Something went wrong. Could not find mock.' ].
	^ nameMockAssoc key
]

{ #category : #initialization }
BMMockery >> initialize [
	super initialize.
	mocks := IdentitySet new.
]

{ #category : #'message interceptor' }
BMMockery >> messageIntercepted: aMessage source: sourceMethodCtx destination: aBmMessageProxy [
	aMessage selector = #babyMockIdentity
		ifTrue: [ ^ self findMockByProxy: aBmMessageProxy ].
	^ aMessage selector = #perform:withArguments:
		ifTrue: 
			[ | performMessage |
			performMessage := Message 
				selector: aMessage arguments first 
				arguments: aMessage arguments second.
			self dispatchMessage: performMessage from: sourceMethodCtx to: aBmMessageProxy ]
		ifFalse: 
			[ self dispatchMessage: aMessage from: sourceMethodCtx to: aBmMessageProxy ]

]

{ #category : #private }
BMMockery >> mockNameMustBeUnique: mockName [
	mocks 
		detect: [ :each | each key mockName = mockName ]
		ifFound: [ BMMockError signal: mockName printString, ' has already created' ].
]

{ #category : #'instance creation' }
BMMockery >> newMockNamed: nameString [
	| proxy mockIdentity |
	self mockNameMustBeUnique: nameString.
	proxy := BMMessageProxy withInterceptor: self.
	mockIdentity := BMMockIdentity 
		named: nameString 
		proxy: proxy 
		expectationCollector: dispatcher.
	mocks add: (mockIdentity -> proxy).
	^ proxy
]

{ #category : #initialization }
BMMockery >> setMessageDispatcher: aMessageDispatcher errorTranslator: anErrorTranslator [
	dispatcher := aMessageDispatcher.
	errorTranslator := anErrorTranslator.
	^ self
]
