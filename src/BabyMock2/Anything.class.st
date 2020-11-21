"
I can play the role of either an argument or a selector matcher.

E.g.:

protocol describe
	allow: mock recv: Anything; with: 1 and: Anything.
"
Class {
	#name : #Anything,
	#superclass : #Object,
	#category : #'BabyMock2-Syntax'
}

{ #category : #converting }
Anything class >> asBabyMockArgumentMatcher [
	^ BMAnyArgMatcher new
]

{ #category : #converting }
Anything class >> asBabyMockSelectorMatcher [
	^ BMAnySelectorMatcher new
]
