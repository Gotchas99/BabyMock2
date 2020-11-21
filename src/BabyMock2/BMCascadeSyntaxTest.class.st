Class {
	#name : #BMCascadeSyntaxTest,
	#superclass : #TestCase,
	#category : #'BabyMock2-Core-Tests'
}

{ #category : #private }
BMCascadeSyntaxTest >> notDefinedBySyntaxButByTest [
	^ 1983
]

{ #category : #tests }
BMCascadeSyntaxTest >> testSendsBackUnknownMessages [
	| syntax |
	syntax := BMCascadeSyntax new.
	self assert: syntax notDefinedBySyntaxButByTest equals: 1983.
]
