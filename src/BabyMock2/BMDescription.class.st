"
Defines the interace of the Description, which can be used as a collecting paramter.
"
Class {
	#name : #BMDescription,
	#superclass : #Object,
	#category : #'BabyMock2-Core'
}

{ #category : #converting }
BMDescription class >> asString: selfDescribing [
	| description |
	description := BMTextDescription new.
	selfDescribing describeTo: description.	
	^ description asText asString
]

{ #category : #description }
BMDescription >> appendArgument: anObject [
	self subclassResponsibility 
]

{ #category : #description }
BMDescription >> appendMessage: aString [
	self subclassResponsibility 
]

{ #category : #description }
BMDescription >> appendReceiver: anObject [
	self subclassResponsibility 
]

{ #category : #description }
BMDescription >> appendSelector: aSymbol [
	self subclassResponsibility
]

{ #category : #description }
BMDescription >> appendText: aString [
	self subclassResponsibility 

]

{ #category : #description }
BMDescription >> appendValue: aString [
	self subclassResponsibility 
]

{ #category : #description }
BMDescription >> appendWarning: aString [
	self subclassResponsibility 
]

{ #category : #description }
BMDescription >> hasDescription [
	self subclassResponsibility 
]

{ #category : #description }
BMDescription >> newLine [
	self subclassResponsibility 
]

{ #category : #description }
BMDescription >> space [
	self subclassResponsibility 
]
