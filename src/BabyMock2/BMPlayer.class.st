"
Animates a sequence of animations. After an animation finished it steps to the next one.

"
Class {
	#name : #BMPlayer,
	#superclass : #Object,
	#instVars : [
		'animations',
		'currentAnimationIndex',
		'animating'
	],
	#category : #'BabyMock2-GUI'
}

{ #category : #adding }
BMPlayer >> addAnimation: animation [
	animations add: animation.
	animation animationListener: self.
]

{ #category : #accessing }
BMPlayer >> animating [
	^ animating
]

{ #category : #private }
BMPlayer >> animating: aBoolean [
	animating := aBoolean 
]

{ #category : #'animation listener' }
BMPlayer >> animationFinished: animation [		
	self moveToNextAnimationOrStop
]

{ #category : #private }
BMPlayer >> currentAnimation [
	^ animations at: currentAnimationIndex 
]

{ #category : #player }
BMPlayer >> goToBeginning [
	animations do: #resetAnimation.
	self animating: false.
	currentAnimationIndex := 0.
]

{ #category : #player }
BMPlayer >> goToEnd [
	self animating: false.
	animations do: 
		[ :each | each endAnimationAndSelect: (each == animations last) ].	
	currentAnimationIndex := animations size.
]

{ #category : #private }
BMPlayer >> hasMoreAnimation [ 
	^ currentAnimationIndex < animations size 
]

{ #category : #'initialize-release' }
BMPlayer >> initialize [ 
	super initialize.
	animations := OrderedCollection new.
	currentAnimationIndex := 0.
	self animating: false.
]

{ #category : #private }
BMPlayer >> isLastAnimation [
	^ currentAnimationIndex = animations size
]

{ #category : #private }
BMPlayer >> moveToNextAnimationOrStop [ 	
	self currentAnimation endAnimationAndSelect: self isLastAnimation.
	self hasMoreAnimation
		ifTrue: [ self nextAnimation beginAnimation ]
		ifFalse: [ self animating: false ]
]

{ #category : #private }
BMPlayer >> nextAnimation [ 
	currentAnimationIndex := currentAnimationIndex + 1.
	^ self currentAnimation.

]

{ #category : #private }
BMPlayer >> previousAnimation [ 
	currentAnimationIndex := currentAnimationIndex - 1.
]

{ #category : #accessing }
BMPlayer >> size [
	^ animations size
]

{ #category : #player }
BMPlayer >> startAnimation [
	animations ifEmpty: [ ^ self ].			
	currentAnimationIndex := 1.
	self animating: true.
	self currentAnimation beginAnimation.
]

{ #category : #player }
BMPlayer >> stepBackward [
	self animating: false.
	currentAnimationIndex = 0 ifTrue: [ ^ self ].
			
	self currentAnimation resetAnimation.
	self previousAnimation.
	currentAnimationIndex >= 1
		ifTrue: [ self currentAnimation endAnimationAndSelect: true ].
]

{ #category : #player }
BMPlayer >> stepForward [
	self animating: false.
	currentAnimationIndex >= 1	
		ifTrue: [ self currentAnimation endAnimationAndSelect: self isLastAnimation ].
	self hasMoreAnimation
		ifTrue: [ self nextAnimation endAnimationAndSelect: true ].
]

{ #category : #player }
BMPlayer >> toogleAnimation [
	currentAnimationIndex = 0 
		ifTrue: 
			[ self startAnimation ]
		ifFalse: 
			[ self animating 
				ifTrue: [ self currentAnimation endAnimationAndSelect: true ]
				ifFalse: [ self moveToNextAnimationOrStop ].
			self animating: self animating not ]
		
]
