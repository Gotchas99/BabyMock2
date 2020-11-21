"
A simple grid layout with equally sized cells.
"
Class {
	#name : #BMGridLayout,
	#superclass : #Object,
	#instVars : [
		'morphs',
		'rows',
		'cols',
		'preferredCells'
	],
	#category : #'BabyMock2-GUI'
}

{ #category : #'instance creation' }
BMGridLayout class >> rows: rows columns: columns [
	^ self new rows: rows columns: columns.
]

{ #category : #layout }
BMGridLayout >> add: aMorph [
	| cell |
	preferredCells ifEmpty: [
		(self addToFreeCell: aMorph) ifFalse: [ Error signal: 'no more space in grid'. ]
	] ifNotEmpty: [
		cell := preferredCells removeFirst.
		self addTo: aMorph row: cell y column: cell x.
	]. 
]

{ #category : #layout }
BMGridLayout >> addTo: aMorph row: rowNumber column: colNumber [	
	morphs at: colNumber@rowNumber put: aMorph.
]

{ #category : #private }
BMGridLayout >> addToFreeCell: aMorph [
	0 to: rows -1 do: [:r|
		0 to: cols -1 do: [:c|
			morphs at: c@r ifAbsent: [ 
				self addTo: aMorph row: r column: c. 
				^ true.
			].
		]
	].	
	^ false.
]

{ #category : #'initialize-release' }
BMGridLayout >> initialize [ 
	super initialize.
	morphs := Dictionary new.
	rows := 3. cols := 3.
	preferredCells := OrderedCollection new.
]

{ #category : #layout }
BMGridLayout >> layout: parentMorph [
	| cellWidth cellHeight x y |
	cellWidth := parentMorph width / cols. 
	cellHeight := parentMorph height / rows.							
	0 to: rows -1 do: [:r|
		0 to: cols -1 do: [:c|
			morphs at: c@r ifPresent: [:morph |
				x := parentMorph left + ((cellWidth * c) + (cellWidth /2)).
				y := parentMorph top + ((cellHeight * r) + (cellHeight /2)).
				morph center: x@y.
			]
		]
	]
]

{ #category : #accessing }
BMGridLayout >> preferredCells: anArrayOfPoints [
	preferredCells addAll: anArrayOfPoints.
]

{ #category : #accessing }
BMGridLayout >> rows: rowNumbers columns: columnNumbers [.
	rows := rowNumbers.
	cols := columnNumbers.
]
