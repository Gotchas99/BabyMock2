"
A simple box layout whith horizontal orientation.
"
Class {
	#name : #BMBoxLayout,
	#superclass : #Object,
	#instVars : [
		'morphs',
		'padding'
	],
	#category : #'BabyMock2-GUI'
}

{ #category : #accessing }
BMBoxLayout >> add: aMorph [ 
	morphs add: aMorph.
]

{ #category : #'initialize-release' }
BMBoxLayout >> initialize [
	super initialize.
	morphs := OrderedCollection new.
	padding := 10@10.
]

{ #category : #layout }
BMBoxLayout >> layout: parentMorph [
	| cellWidth |
	morphs ifEmpty: [ ^ self ].
	cellWidth := parentMorph width / morphs size.	
	morphs doWithIndex: [ :morph :idx | | newExtent newCenter |
		newCenter := (idx -1 * cellWidth + parentMorph left + (cellWidth /2))@(parentMorph top + (parentMorph height /2)).
		newExtent := ((cellWidth - padding x)@(parentMorph height - padding y)) rounded abs.
		morph center: newCenter.		
		morph extent: newExtent ]
]

{ #category : #accessing }
BMBoxLayout >> padding: aPoint [ 
	padding := aPoint.
]
