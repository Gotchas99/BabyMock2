"
Spec model for displaying texts.
"
Class {
	#name : #BMDescriptionPane,
	#superclass : #ComposableModel,
	#instVars : [
		'description'
	],
	#category : #'BabyMock2-GUI'
}

{ #category : #specs }
BMDescriptionPane class >> defaultSpec [	
	^ SpecLayout composed
		add: #description;
		yourself
]

{ #category : #accessing }
BMDescriptionPane >> description [
	^ description
]

{ #category : #accessing }
BMDescriptionPane >> description: aText [
	description text: aText.
]

{ #category : #initialization }
BMDescriptionPane >> initializeWidgets [
	self instantiateModels: #(description TextModel).
]
