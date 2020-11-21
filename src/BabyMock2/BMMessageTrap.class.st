"
Message trap intercepts all, non vm optimized messages. See its parent for more information.
"
Class {
	#name : #BMMessageTrap,
	#superclass : #BMMessageProxy,
	#category : #'BabyMock2-Core'
}

{ #category : #init }
BMMessageTrap class >> initialize [
	superclass := BMMessageProxy.
	format := BMMessageProxy format.
	methodDict := nil.
]
