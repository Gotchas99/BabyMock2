"
I'm just a null object that can be put in place of a BMStateExpectation.
"
Class {
	#name : #BMNullStateExpectation,
	#superclass : #Object,
	#category : #'BabyMock2-Core'
}

{ #category : #'self describing' }
BMNullStateExpectation class >> describeMismatch: aDescription [
	"do nothing"
]

{ #category : #'self describing' }
BMNullStateExpectation class >> describeTo: aDescription [
	"do nothing"
]

{ #category : #verification }
BMNullStateExpectation class >> satisfied [
	^ true
]
