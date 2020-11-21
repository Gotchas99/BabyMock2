"
Spec model for buttons controlling an animation.
"
Class {
	#name : #BMControlButtons,
	#superclass : #ComposableModel,
	#instVars : [
		'play',
		'next',
		'previous',
		'beginning',
		'end'
	],
	#category : #'BabyMock2-GUI'
}

{ #category : #specs }
BMControlButtons class >> defaultSpec [
	^ SpecRowLayout new
			add: #beginning;
			add: #previous;
			add: #play;
			add: #next;
			add: #end;
			yourself
]

{ #category : #accessing }
BMControlButtons >> beginning [
	^ beginning
]

{ #category : #accessing }
BMControlButtons >> end [
	^ end
]

{ #category : #initialization }
BMControlButtons >> initializeWidgets [ 
	self instantiateModels: #(
	      play   		ButtonModel
	      next        	ButtonModel
		previous     ButtonModel
		beginning	ButtonModel
		end			ButtonModel).
					
	play 		icon: (BMIcons byName: #play); 			help: 'Play/Pause'.
	next 		icon: (BMIcons byName: #stepForward);	help: 'Step forward'.
	previous 	icon: (BMIcons byName: #stepBack);		help: 'Step backward'.
	beginning 	icon: (BMIcons byName: #beginning);		help: 'Go to the beginning'.
	end 		icon: (BMIcons byName: #end);			help: 'Go to the end'.
]

{ #category : #accessing }
BMControlButtons >> next [
	^ next
]

{ #category : #accessing }
BMControlButtons >> play [
	^ play
]

{ #category : #accessing }
BMControlButtons >> previous [
	^ previous
]

{ #category : #events }
BMControlButtons >> whenBeginningPressedDo: aBlock [
	beginning action: aBlock

]

{ #category : #events }
BMControlButtons >> whenEndPressedDo: aBlock [
	end action: aBlock

]

{ #category : #events }
BMControlButtons >> whenNextPressedDo: aBlock [
	next action: aBlock

]

{ #category : #events }
BMControlButtons >> whenPlayPressedDo: aBlock [
	play action: aBlock
]

{ #category : #events }
BMControlButtons >> whenPreviousPressedDo: aBlock [
	previous action: aBlock
]
