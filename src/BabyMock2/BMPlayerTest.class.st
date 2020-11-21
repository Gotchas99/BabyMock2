Class {
	#name : #BMPlayerTest,
	#superclass : #BabyMock2TestCase,
	#instVars : [
		'control',
		'animation',
		'nextAnimation',
		'state'
	],
	#category : #'BabyMock2-GUI-Tests'
}

{ #category : #private }
BMPlayerTest >> control: animationArray [
	animationArray do: 
		[:each | 
		protocol describe
			allow: each recv: #animationListener:.
		control addAnimation: each ]
]

{ #category : #running }
BMPlayerTest >> setUp [
	animation := protocol mock: 'animation'.
	nextAnimation := protocol mock: 'next animation'.
	control := BMPlayer new.			
	state := protocol states: 'control state' startsAs: #started.			
	protocol visualize: control.
]

{ #category : #tests }
BMPlayerTest >> testThatItAnimatesAfterStarted [
	self control: { animation }.
	protocol describe
		once: animation recv: #beginAnimation.
	control startAnimation.
	self assert: control animating.
]

{ #category : #tests }
BMPlayerTest >> testThatItAttachesListenerAfterAdding [
	protocol describe
		once: animation recv: #animationListener:; 
		with: [:it | it identityHash = control identityHash].
	control addAnimation: animation.	
]

{ #category : #tests }
BMPlayerTest >> testThatItCanBeRestartedAfterFinished [
	self control: { animation }.
	protocol describe
		twice: animation recv: #beginAnimation;
		allow: animation recv: #endAnimationAndSelect:.
	control 
		startAnimation;
		animationFinished: animation.	
	self deny: control animating.
	
	control 
		startAnimation;
		animationFinished: animation.		
	self deny: control animating.
	
]

{ #category : #tests }
BMPlayerTest >> testThatItCanGoToTheBeginning [
	self control: { animation }.
	protocol describe
		once: animation recv: #beginAnimation; then: state is: #began;
		once: animation recv: #resetAnimation; when: state is: #began.
	control 
		startAnimation;
		goToBeginning.
]

{ #category : #tests }
BMPlayerTest >> testThatItCanGoToTheEnd [
	self control: { animation. nextAnimation }.
	protocol describe
		once: animation recv: #endAnimationAndSelect:; 
			with: false; then: state is: #firstEnded;
		once: nextAnimation recv: #endAnimationAndSelect:; 
			with: true; when: state is: #firstEnded.
	control goToEnd.
]

{ #category : #tests }
BMPlayerTest >> testThatItCanStepForwardAndBackward [
	self control: { animation. nextAnimation }.
	protocol describe
		allow: animation recv: #beginAnimation;
		once: animation recv: #endAnimationAndSelect:; 
			with: false; when: state is: #forwardPressed;
		once: nextAnimation recv: #endAnimationAndSelect:; 
			with: true; when: state is: #forwardPressed;
		once: nextAnimation recv: #resetAnimation; 
			when: state is: #backwardPressed;
		once: animation recv: #endAnimationAndSelect:; 
			with: true; when: state is: #backwardPressed.
	control startAnimation.
	
	state changeState: #forwardPressed.	
	control stepForward.
	
	state changeState: #backwardPressed.	
	control stepBackward.
]

{ #category : #tests }
BMPlayerTest >> testThatItKnowsItsSize [
	self control: { animation. nextAnimation }.
	self assert: control size equals: 2.
]

{ #category : #tests }
BMPlayerTest >> testThatItMovesToTheNextAnimationAfterTheFirstEnded [
	self control: { animation. nextAnimation }.
	protocol describe
		once: animation recv: #beginAnimation;	 
			then: state is: #firstStarted;
		once: animation recv: #endAnimationAndSelect:; 
			with: false; 
			when: state is: #firstStarted; 
			then: state is: #firstEnded;
		once: nextAnimation recv: #beginAnimation; 
			when: state is: #firstEnded.
	control 
		startAnimation;
		animationFinished: animation.
	self assert: control animating.
]

{ #category : #tests }
BMPlayerTest >> testThatItStopsAfterTheLastAnimationEnded [
	self control: { animation }.	
	protocol describe
		allow: animation recv: Anything.
	control 
		startAnimation;
		animationFinished: animation.	
	self deny: control animating.
	
]

{ #category : #tests }
BMPlayerTest >> testThatStartDoesNothingIfNoAnimationWasAdded [
	control startAnimation.
]

{ #category : #tests }
BMPlayerTest >> testToogleAnimationPausesAnimation [
	self control: { animation }.
	protocol describe
		once: animation recv: #beginAnimation;
			when: state is: #started; 
			then: state is: #animating;
		once: animation recv: #endAnimationAndSelect:; 
			with: true; 
			when: state is: #animating.
	control 
		startAnimation;
		toogleAnimation.
]

{ #category : #tests }
BMPlayerTest >> testToogleAnimationResumeAnimation [
	self control: { animation. nextAnimation }.		
	protocol describe
		allow: animation recv: #beginAnimation;
		once: animation recv: #endAnimationAndSelect:; 
			with: true; 
			then: state is: #paused;
		once: animation recv: #endAnimationAndSelect:; 
			with: false; 
			then: state is: #paused;
		once: nextAnimation recv: #beginAnimation; 
			when: state is: #paused.
	control 
		startAnimation;
		toogleAnimation;
		toogleAnimation.	
]
