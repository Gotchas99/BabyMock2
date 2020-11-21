Class {
	#name : #BMBoxLayoutTest,
	#superclass : #BabyMock2TestCase,
	#instVars : [
		'box',
		'morph1',
		'container',
		'morph2',
		'morph3'
	],
	#category : #'BabyMock2-GUI-Tests'
}

{ #category : #private }
BMBoxLayoutTest >> allows: mock toReceive: aSymbol [
	protocol describe
		allow: mock recv: aSymbol
]

{ #category : #running }
BMBoxLayoutTest >> setUp [
	morph1 := protocol mock: 'morph1'.
	morph2 := protocol mock: 'morph2'.	
	morph3 := protocol mock: 'morph3'.			
	container := Morph new.
	box := BMBoxLayout new.
	protocol visualize: box.	
]

{ #category : #tests }
BMBoxLayoutTest >> testThatItPlacesManyMorphs [
	container extent: 90@200; left: 20; top: 40.
	box add: morph1; add: morph2; add: morph3.
	{morph1. morph2. morph3} do: [:each |  self allows: each toReceive: #extent:].
	protocol describe
		once: morph1 recv: #center: ; with: (20+15)@(40+100);
		once: morph2 recv: #center: ; with: (20+45)@(40+100);	
		once: morph3 recv: #center: ; with: (20+75)@(40+100).			
	box layout: container.
]

{ #category : #tests }
BMBoxLayoutTest >> testThatItPlacesOneMorphAtTheCenter [
	container extent: 100@200; left: 30; top: 40.
	box add: morph1.
	protocol describe
		allow: morph1 recv: #extent:;
		once: morph1 recv: #center: ; with: (50+30)@(100+40).
	box layout: container.
]

{ #category : #tests }
BMBoxLayoutTest >> testThatStretchesManyMorphs [
	container extent: 120@300; left: 0; top: 0.
	box add: morph1; add: morph2; add: morph3; padding: 10@20.
	{morph1. morph2. morph3} do: [:each |  self allows: each toReceive: #center:].	
	protocol describe
		once: morph1 recv: #extent: ; with: 30@280;
		once: morph2 recv: #extent: ; with: 30@280;
		once: morph3 recv: #extent: ; with: 30@280.
	box layout: container.
]

{ #category : #tests }
BMBoxLayoutTest >> testThatStretchesOneMorph [
	container extent: 200@300; left: 0; top: 0.
	box add: morph1; padding: 10@20.
	protocol describe
		allow: morph1 recv: #center:;
		once: morph1 recv: #extent: ; with: 190@280.
	box layout: container.
]
