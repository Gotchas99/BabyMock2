Class {
	#name : #BMGridLayoutTest,
	#superclass : #BabyMock2TestCase,
	#instVars : [
		'container',
		'grid',
		'morph1',
		'morph2',
		'morph3'
	],
	#category : #'BabyMock2-GUI-Tests'
}

{ #category : #running }
BMGridLayoutTest >> setUp [
	container := Morph new.
	morph1 := protocol mock: 'morphMock1'.
	morph2 := protocol mock: 'morphMock2'.
	morph3 := protocol mock: 'morphMock3'.	
]

{ #category : #running }
BMGridLayoutTest >> tearDown [ 
	container delete.
]

{ #category : #tests }
BMGridLayoutTest >> testFillsCellsBasedOnPreferredOrder [
	grid := BMGridLayout rows: 1 columns: 4.
	grid preferredCells: { 2@0 . 0@0 . }.	
	container extent: 120@30.
	container left: 0; top: 0.
	{ morph1. morph2. morph3 } do: [:each | grid add: each ].
	protocol describe
		once: morph1 recv: #center: ; with: (60 + 15)@15;
		once: morph2 recv: #center: ; with: 15@15;
		once: morph3 recv: #center: ; with: (30 + 15)@15.
	grid layout: container.
]

{ #category : #tests }
BMGridLayoutTest >> testMovesComponents [
	grid := BMGridLayout rows: 3 columns: 3.
	container extent: 120@90.
	container left: 200; top: 300.	
	grid addTo: morph1 row:  1 column: 1.
	grid addTo: morph2 row:  0 column: 2.
	protocol describe
		once: morph1 recv: #center: ; with: (200 + 40 + 20)@(300 + 30 + 15);
		once: morph2 recv: #center: ; with: (200 + 80 + 20)@(300 + 15).
	grid layout: container.
]

{ #category : #tests }
BMGridLayoutTest >> testSignalsExceptionIfNoMoreSpaceLeft [
	grid := BMGridLayout rows: 1 columns: 1.	
	protocol describe
		allow: morph1 recv: #center:.
	grid add: morph1.	
	grid layout: container.
	self should: [ grid add: morph1 ] raise: Error.
]
