"
A simple calculator for adding and subtracting roman numbers.

It has one collaborator the converter that is used to convert between arabic and roman numbers.
"
Class {
	#name : #BMRomanCalculator,
	#superclass : #Object,
	#instVars : [
		'converter'
	],
	#category : #'BabyMock2-Examples'
}

{ #category : #'instance creation' }
BMRomanCalculator class >> converter: romanConverter [
	^ self new setConverter: romanConverter
	
]

{ #category : #operations }
BMRomanCalculator >> add: romanNumber1 to: romanNumber2 [
	| result |
	result := (converter fromRoman: romanNumber1) + (converter fromRoman: romanNumber2).
	^ converter toRoman: result.
]

{ #category : #initialization }
BMRomanCalculator >> setConverter: romanConverter [
	converter := romanConverter.
	^ self
]

{ #category : #operations }
BMRomanCalculator >> sub: romanNumber2 from: romanNumber1 [	
	| result |	
	result := (converter fromRoman: romanNumber1) - (converter fromRoman: romanNumber2).
	result negative 
		ifTrue: [ Error signal: 'Negative not supported' ].	
	^ converter toRoman: result.
	
]
