"
Represents a textual description of formatted text.
"
Class {
	#name : #BMTextDescription,
	#superclass : #BMDescription,
	#instVars : [
		'stream'
	],
	#category : #'BabyMock2-Core'
}

{ #category : #description }
BMTextDescription >> appendArgument: anObject [
	stream
		withAttribute: self colors argumentColor do: [ anObject printOn: stream ]
]

{ #category : #description }
BMTextDescription >> appendMessage: aMessage [
	aMessage selector isKeyword
		ifTrue: [ self highlightKeywordMessage: aMessage ]
		ifFalse: [ self highlightSimpleMessage: aMessage ]
]

{ #category : #description }
BMTextDescription >> appendReceiver: anObject [
	stream
		withAttribute: self colors receiverColor
		do: [ stream nextPutAll: anObject asString ]
]

{ #category : #description }
BMTextDescription >> appendSelector: aSymbol [
	stream
		withAttributes: {TextEmphasis bold. self colors messageColor}
		do: [ stream nextPutAll: aSymbol asString ]
]

{ #category : #description }
BMTextDescription >> appendText: aString [
	stream
		withAttribute: self colors textColor do: [ stream nextPutAll: aString ]
	
]

{ #category : #description }
BMTextDescription >> appendValue: anObject [
	stream
		withAttribute: self colors valueColor do: [ stream nextPutAll: anObject asString ]
]

{ #category : #description }
BMTextDescription >> appendWarning: aString [
	stream
		withAttribute: self colors warningColor do: [ stream nextPutAll: aString ]
	
]

{ #category : #converting }
BMTextDescription >> asText [
	^ stream contents
]

{ #category : #private }
BMTextDescription >> colors [
	^ BMColorScheme 
]

{ #category : #description }
BMTextDescription >> hasDescription [
	^ stream contents size ~= 0
]

{ #category : #private }
BMTextDescription >> highlightKeywordMessage: aMessage [
	aMessage arguments with: aMessage selector keywords
		do: [ :arg :keyword | 
			stream
				withAttributes: {TextEmphasis bold. self colors messageColor} do: [ stream nextPutAll: keyword ];
				space;
				withAttribute: self colors argumentColor do: [ arg printOn: stream ];
				space ].
	stream skip: -1
]

{ #category : #private }
BMTextDescription >> highlightSimpleMessage: aMessage [
	stream
		withAttributes: {TextEmphasis bold. self colors messageColor}
		do: [ stream nextPutAll: aMessage asString ]
]

{ #category : #initialization }
BMTextDescription >> initialize [
	super initialize.
	stream := TextStream on: Text new.
]

{ #category : #description }
BMTextDescription >> newLine [
	stream crlf
]

{ #category : #description }
BMTextDescription >> space [
	stream space
	
]
