"
Reports TestFailures for SUnit
"
Class {
	#name : #BMSUnitErrorTranslator,
	#superclass : #Object,
	#category : #'BabyMock2-Core'
}

{ #category : #'error translator' }
BMSUnitErrorTranslator class >> translateError: anError [
	BMTestFailure signal: anError messageText.
]
