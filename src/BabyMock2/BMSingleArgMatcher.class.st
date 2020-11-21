"
An argument matcher that uses a single value to match exactly one argument.
"
Class {
	#name : #BMSingleArgMatcher,
	#superclass : #BMArgMatcher,
	#instVars : [
		'value'
	],
	#category : #'BabyMock2-Core'
}

{ #category : #'instance creation' }
BMSingleArgMatcher class >> argumentIs: aValue [
	^ self new 
		setValue: aValue
]

{ #category : #matching }
BMSingleArgMatcher >> argumentCount [
	^ 1
]

{ #category : #'self describing' }
BMSingleArgMatcher >> describeMismatch: description arguments: argumentsArray [
	(self matches: argumentsArray)
		ifTrue: 
			[ description 
				appendText: 'argument matched: ';
				appendArgument: argumentsArray first ]
		ifFalse: 
			[ description 
				appendWarning: 'argument mismatched: ';
				appendArgument: argumentsArray first;
				appendWarning: ', wanted: '.
			 self describeTo: description ]
]

{ #category : #'self describing' }
BMSingleArgMatcher >> describeTo: aBMDescription [ 
	aBMDescription appendArgument: value
]

{ #category : #matching }
BMSingleArgMatcher >> matches: arguments [
	^ arguments size = 1 and: [ arguments first = value ]
]

{ #category : #'initialize-release' }
BMSingleArgMatcher >> setValue: aValue [ 
	value := aValue.
	^ self.
]
