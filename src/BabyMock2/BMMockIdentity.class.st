"
Represents the identity of a mock proxy object. Object messges intercepted by the proxy will be forwarded to this object.
"
Class {
	#name : #BMMockIdentity,
	#superclass : #Object,
	#instVars : [
		'mockName',
		'proxy',
		'expectationCollector'
	],
	#category : #'BabyMock2-Core'
}

{ #category : #'instance creation' }
BMMockIdentity class >> named: aString proxy: aMessageProxy expectationCollector: expectationCollector [
	^ self new 
		setName: aString
		proxy: aMessageProxy
		expectationCollector: expectationCollector
]

{ #category : #comparing }
BMMockIdentity >> = anObject [
	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ self babyMockIdentity == anObject babyMockIdentity
]

{ #category : #converting }
BMMockIdentity >> asOrderedCollection [	
	^ OrderedCollection with: proxy
]

{ #category : #converting }
BMMockIdentity >> asSetElement [
	^ proxy
]

{ #category : #accessing }
BMMockIdentity >> babyMockIdentity [
	^ self
]

{ #category : #browsing }
BMMockIdentity >> browse [
	self expectationsOnMe inspect
]

{ #category : #printing }
BMMockIdentity >> displayedObjectName [
	^ self asString
]

{ #category : #'set implementation' }
BMMockIdentity >> enclosedSetElement [
	^ proxy
]

{ #category : #private }
BMMockIdentity >> expectationsOnMe [
	^ expectationCollector expectationsOn: proxy
]

{ #category : #comparing }
BMMockIdentity >> hash [
	^ self identityHash 
]

{ #category : #printing }
BMMockIdentity >> longPrintOn: aStream [
	self expectationsOnMe 
		do: [ :each | 
			aStream nextPutAll: '- '.
			each printOn: aStream ]
		separatedBy: 
			[ aStream cr ]
]

{ #category : #accessing }
BMMockIdentity >> mockName [
	^ mockName
]

{ #category : #'message performing' }
BMMockIdentity >> perform: aSymbol [
	^ proxy perform: aSymbol withArguments: #()
	

]

{ #category : #'message performing' }
BMMockIdentity >> perform: aSymbol orSendTo: otherTarget [
	^ proxy perform: aSymbol withArguments: #()
]

{ #category : #'message performing' }
BMMockIdentity >> perform: aSymbol with: anObject [ 
	^ proxy perform: aSymbol withArguments: { anObject }
]

{ #category : #'message performing' }
BMMockIdentity >> perform: aSymbol with: firstObject with: secondObject [ 
	^ proxy perform: aSymbol withArguments: { firstObject. secondObject }
]

{ #category : #'message performing' }
BMMockIdentity >> perform: aSymbol with: firstObject with: secondObject with: thirdObject [ 
	^ proxy 
		perform: aSymbol 
		withArguments: { firstObject. secondObject. thirdObject }
]

{ #category : #'message performing' }
BMMockIdentity >> perform: aSymbol withArguments: argArray inSuperclass: lookupClass [
	^ proxy perform: aSymbol withArguments: argArray 
]

{ #category : #'message performing' }
BMMockIdentity >> perform: selector withEnoughArguments: anArray [
	| numArgs args |
	numArgs := selector numArgs.
	anArray size == numArgs
		ifTrue: [ ^ proxy perform: selector withArguments: anArray asArray ].

	args := Array new: numArgs.
	args replaceFrom: 1
		to: (anArray size min: args size)
		with: anArray
		startingAt: 1.

	^ proxy perform: selector withArguments: args
]

{ #category : #printing }
BMMockIdentity >> printOn: aStream [
	aStream nextPutAll: mockName
]

{ #category : #initialization }
BMMockIdentity >> setName: aString proxy: aMessageProxy expectationCollector: anExpectationCollector [
	mockName := aString.
	proxy := aMessageProxy.
	expectationCollector := anExpectationCollector.
	^ self
]
