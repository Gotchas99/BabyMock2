Class {
	#name : #BMRomanCalculatorTest,
	#superclass : #BabyMock2TestCase,
	#instVars : [
		'calculator',
		'converter'
	],
	#category : #'BabyMock2-Examples'
}

{ #category : #running }
BMRomanCalculatorTest >> setUp [
	converter := protocol mock: 'converter'.
	calculator := BMRomanCalculator converter: converter.
	protocol visualize: calculator.
]

{ #category : #tests }
BMRomanCalculatorTest >> testAddsTwoRomanNumbers [
	protocol describe
		allow: converter recv: #fromRoman: ; with: 'III'; 
			=> 3;
		allow: converter recv: #fromRoman: ; with: 'V'; 
			=> 5;
		allow: converter recv: #toRoman: ; with: 8; 
			=> 'VIII'.
	self assert: (calculator add: 'III' to: 'V') equals: 'VIII'.
]

{ #category : #tests }
BMRomanCalculatorTest >> testSubtractDoesNotSupportNegativeResult [
	protocol describe
		allow: converter recv: #fromRoman: ; with: 'X'; 
			=> 10;
		allow: converter recv: #fromRoman: ; with: 'VI'; 
			=> 6;
		allow: converter recv: #toRoman: ; with: 4; 
			=> 'IV'.
	self should: [ calculator sub: 'X' from: 'VI' ] raise: Error.
]

{ #category : #tests }
BMRomanCalculatorTest >> testSubtractTwoRomanNumbers [
	protocol describe
		allow: converter recv: #fromRoman: ; with: 'X'; 
			=> 10;
		allow: converter recv: #fromRoman: ; with: 'VI'; 
			=> 6;
		allow: converter recv: #toRoman: ; with: 4; 
			=> 'IV'.
	self assert: (calculator sub: 'VI' from: 'X') equals: 'IV'.
]
