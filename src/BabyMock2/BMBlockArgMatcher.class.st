"
An argument matcher that uses a block predicate to decide whether the given arguments were matched or not.
"
Class {
	#name : #BMBlockArgMatcher,
	#superclass : #BMArgMatcher,
	#instVars : [
		'block'
	],
	#category : #'BabyMock2-Core'
}

{ #category : #'instance creation' }
BMBlockArgMatcher class >> fromBlock: aBlockClosure [
	^ self new setBlock: aBlockClosure
]

{ #category : #matching }
BMBlockArgMatcher >> argumentCount [
	^ block argumentCount
]

{ #category : #'self describing' }
BMBlockArgMatcher >> describeMismatch: description arguments: argumentsArray [
	(self matches: argumentsArray)
		ifTrue: 
			[ description 
				appendText: 'argument matched: ';
				appendArgument: argumentsArray ]
		ifFalse: 
			[ description 
				appendWarning: 'argument mismatched: ';
				appendArgument: argumentsArray;
				appendWarning: ', wanted: '.
			 self describeTo: description ]
]

{ #category : #'self describing' }
BMBlockArgMatcher >> describeTo: aBMDescription [ 
	aBMDescription appendArgument: block.
]

{ #category : #matching }
BMBlockArgMatcher >> matches: args [
	^ (block argumentCount = args size) and: 
		[block valueWithArguments: args].
]

{ #category : #'initialize-release' }
BMBlockArgMatcher >> setBlock: aBlock [
	block := aBlock.
	^ self
]
