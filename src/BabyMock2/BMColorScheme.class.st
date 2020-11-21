"
Predefined colors for displaying texts.
"
Class {
	#name : #BMColorScheme,
	#superclass : #Object,
	#category : #'BabyMock2-Core'
}

{ #category : #colors }
BMColorScheme class >> argumentColor [
	^ TextColor color: (Color fromHexString: 'AD2BEE')
]

{ #category : #colors }
BMColorScheme class >> backgroundColor [
	^ Color fromHexString: 'F0FFF0'
	
]

{ #category : #colors }
BMColorScheme class >> messageColor [
	^ TextColor color: (Color fromHexString: '445588')
]

{ #category : #colors }
BMColorScheme class >> receiverColor [
	^ TextColor color: (Color fromHexString: '445588')
]

{ #category : #colors }
BMColorScheme class >> textColor [
	^ TextColor color: (Color fromHexString: '2E3E3E')	
]

{ #category : #colors }
BMColorScheme class >> valueColor [
	^ TextColor color: (Color fromHexString: 'AD2BEE')	
]

{ #category : #colors }
BMColorScheme class >> warningColor [
	^ TextColor color: (Color red)
]
