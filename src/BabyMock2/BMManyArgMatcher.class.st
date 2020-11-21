"
An argument matcher which can handle multiple arguments
"
Class {
	#name : #BMManyArgMatcher,
	#superclass : #BMArgMatcher,
	#instVars : [
		'matchers'
	],
	#category : #'BabyMock2-Core'
}

{ #category : #'instance creation' }
BMManyArgMatcher class >> withMatchers: anArrayOfMatchers [
	| matcher |
	matcher := self new.
	anArrayOfMatchers do: [ :each | matcher addMatcher: each ].
	^ matcher
]

{ #category : #accessing }
BMManyArgMatcher >> addMatcher: anArgumentMatcher [
	matchers add: anArgumentMatcher.
]

{ #category : #matching }
BMManyArgMatcher >> argumentCount [
	^ matchers size
]

{ #category : #'self describing' }
BMManyArgMatcher >> describeMismatch: description arguments: argumentsArray [
	| i |
	(matchers size = argumentsArray size) ifFalse: [ ^ self ].	
	i := 1.
	matchers 
		do:
			[:m | | arg |
			arg := argumentsArray at: i.
			description appendText: i asString, '. '.
			m describeMismatch: description arguments: {arg}.
			i := i + 1 ]
		separatedBy:
			[ description 
				newLine;	
				appendText: '    ']
]

{ #category : #'self describing' }
BMManyArgMatcher >> describeTo: aBMDescription [ 
	aBMDescription appendText:  'with: '.
	matchers 
		do: [ :each | each describeTo: aBMDescription ]
		separatedBy: [ aBMDescription appendText: ' and: ' ]
]

{ #category : #'initialize-release' }
BMManyArgMatcher >> initialize [ 
	super initialize.
	matchers := OrderedCollection new.
]

{ #category : #matching }
BMManyArgMatcher >> matches: argumentsArray [
	| matches |
	(matchers size = argumentsArray size) ifFalse: [ ^ false ].					
	matches := matchers 
		with: argumentsArray 
		collect: [:m :arg | m matches: {arg}].
	^ matches allSatisfy: [ :each | each ] 
]
