"
Spec model for groupping diagrams using a tabbed pane.
"
Class {
	#name : #BMDiagramTabs,
	#superclass : #ComposableModel,
	#instVars : [
		'collaborationDiagram',
		'sequenceDiagram',
		'tabs',
		'selectedDiagram'
	],
	#category : #'BabyMock2-GUI'
}

{ #category : #specs }
BMDiagramTabs class >> defaultSpec [	
	^ SpecLayout composed
		add: #tabs;
		yourself
]

{ #category : #private }
BMDiagramTabs >> collaborationDiagram [
	^ collaborationDiagram "XXX used by GUI test"
]

{ #category : #accessing }
BMDiagramTabs >> collaborationDiagramTab [
	| tab |
	tab := self newTab.
	tab 
		label: 'Collaboration diagram';
		icon: (BMIcons byName: #collaboration);
		closeable: false;
		contents: collaborationDiagram.
	^ tab
]

{ #category : #initialization }
BMDiagramTabs >> initializeWidgets [
	collaborationDiagram := BMCollaborationDiagram new.
	sequenceDiagram := BMSequenceDiagram new.
	self instantiateModels: #(tabs TabManagerModel).				
	tabs whenTabSelected: [ :tab | self tabSelected: tab ].
	self populateTabs.
]

{ #category : #private }
BMDiagramTabs >> populateTabs [
	tabs tabs: {
		self collaborationDiagramTab.
		self sequenceDiagramTab.
	}.
	selectedDiagram := collaborationDiagram.
]

{ #category : #accessing }
BMDiagramTabs >> selectedDiagram [
	^ selectedDiagram 
]

{ #category : #accessing }
BMDiagramTabs >> sequenceDiagramTab [
	| tab |
	tab := self newTab.
	tab 
		label: 'Sequence diagram';
		icon: (BMIcons byName: #sequence);
		closeable: false;		
		contents: sequenceDiagram.
	^ tab
]

{ #category : #private }
BMDiagramTabs >> tabSelected: aTabModel [
	selectedDiagram := aTabModel contents.
	selectedDiagram goToEnd
]

{ #category : #accessing }
BMDiagramTabs >> tabs [
	^ tabs
]

{ #category : #accessing }
BMDiagramTabs >> testResult: aBMTestResult [
	collaborationDiagram testResult: aBMTestResult.
	sequenceDiagram testResult: aBMTestResult.
]
