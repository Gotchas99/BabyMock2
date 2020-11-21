"
The main window that will be notified about test execution to display the animation.
"
Class {
	#name : #BMSpecVisualizer,
	#superclass : #ComposableModel,
	#instVars : [
		'tests',
		'diagrams',
		'controls',
		'expectations'
	],
	#classInstVars : [
		'mainWindow'
	],
	#category : #'BabyMock2-GUI'
}

{ #category : #specs }
BMSpecVisualizer class >> defaultSpec [
	^ SpecLayout composed
		newRow: [ :row | 									
			row 
				add: #tests width: 160;
				addSplitter;
				newColumn: [ :col |
					col 
						add: #diagrams;
						addSplitter;
						add: #expectations height: 120;
						add: #controls height: 28]]
]

{ #category : #private }
BMSpecVisualizer class >> doVisualizationOf: aBMTestResult [
	self mainWindow isDisplayed
		ifFalse:	[ self mainWindow openWindow whenClosedDo: [ self reset ] ].
	self mainWindow startVisualization: aBMTestResult.
]

{ #category : #private }
BMSpecVisualizer class >> mainWindow [ 
	^ mainWindow ifNil: [ mainWindow := BMSpecVisualizer new ]
]

{ #category : #private }
BMSpecVisualizer class >> reset [
	mainWindow ifNotNil: [ mainWindow delete ].
	mainWindow := nil.
]

{ #category : #'test listener' }
BMSpecVisualizer class >> testOf: objectUnderTest finished: aBMTestResult [
	(aBMTestResult hasInteraction and: [objectUnderTest notNil])
		ifTrue: [ self visualizeTest: aBMTestResult ]
]

{ #category : #specs }
BMSpecVisualizer class >> title [
	^ 'BabyMock'
]

{ #category : #private }
BMSpecVisualizer class >> visualizeTest: aBMTestResult [
	| block |
	block := [ self doVisualizationOf: aBMTestResult ].
	(ProcessBrowser isUIProcess: Processor activeProcess)
		ifTrue: block
		ifFalse: [ WorldState addDeferredUIMessage: block ]
]

{ #category : #private }
BMSpecVisualizer >> addTestResult: aBMTestResult [
	tests addTestResult: aBMTestResult.
	diagrams testResult: aBMTestResult.
	expectations description: aBMTestResult description asText.        
]

{ #category : #accessing }
BMSpecVisualizer >> controls [
	^ controls
]

{ #category : #accessing }
BMSpecVisualizer >> diagrams [
	^ diagrams
]

{ #category : #accessing }
BMSpecVisualizer >> expectations [
	^ expectations
]

{ #category : #protocol }
BMSpecVisualizer >> initialExtent [
	^ 860@640
]

{ #category : #initialization }
BMSpecVisualizer >> initializePresenter [
	controls 
		whenBeginningPressedDo: [ diagrams selectedDiagram goToBeginning ];
		whenPreviousPressedDo: [ diagrams selectedDiagram stepBackward ];
		whenPlayPressedDo: [ diagrams selectedDiagram playOrPauseAnimation ];
		whenNextPressedDo: [ diagrams selectedDiagram stepForward ];
		whenEndPressedDo: [ diagrams selectedDiagram goToEnd ].		
	tests 
		whenTestSelectedDo: 
			[ :test | 
			diagrams testResult: test. 	
			expectations description: test description asText. 
			self title: (self splitCamel: test testCaseName).
			diagrams selectedDiagram goToEnd ].
]

{ #category : #initialization }
BMSpecVisualizer >> initializeWidgets [ 
	self instantiateModels: #(
		tests				#BMTestsTree
		diagrams 			#BMDiagramTabs
		expectations		#BMDescriptionPane
		controls 			#BMControlButtons).
]

{ #category : #gui }
BMSpecVisualizer >> openWindow [
	^ self openWithSpec
]

{ #category : #private }
BMSpecVisualizer >> splitCamel: camelCaseString [
	| splitted |
	splitted := ' ' join: (camelCaseString piecesCutWhere: [ :current :next | next isUppercase ]).
	^ splitted asLowercase capitalized 
]

{ #category : #gui }
BMSpecVisualizer >> startVisualization: aBMTestResult [
	self addTestResult: aBMTestResult.
	tests tree expandRoots.
	diagrams selectedDiagram playOrPauseAnimation.
]

{ #category : #accessing }
BMSpecVisualizer >> tests [
	^ tests
]
