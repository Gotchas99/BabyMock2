"
A tree representation of test cases.

"
Class {
	#name : #BMTestsTree,
	#superclass : #ComposableModel,
	#instVars : [
		'tests',
		'tree',
		'testSelectionBlock'
	],
	#category : #'BabyMock2-GUI'
}

{ #category : #specs }
BMTestsTree class >> defaultSpec [	
	^ SpecLayout composed
		add: #tree;
		yourself
]

{ #category : #adding }
BMTestsTree >> addTestResult: aBMTestResult [
	| node |
	node := BMTestsRootNode testName: aBMTestResult testName.
	tests 
		at: node
		ifPresent: 
			[ :testResults | 
			testResults remove: aBMTestResult ifAbsent: [ ].
			testResults add: aBMTestResult ]
		ifAbsent: 
			[ tests 
				at: node
				put: (OrderedCollection with: aBMTestResult) ].		
	tree roots: tests keys.	
]

{ #category : #private }
BMTestsTree >> hasSelectedTestNode [
	^ tree selectedItem notNil and: [ tree selectedItem parentNode notNil ]
]

{ #category : #initialization }
BMTestsTree >> initializePresenter [
	testSelectionBlock := [  ].
	tree whenSelectedItemsChanged: 
		[ self hasSelectedTestNode 
			ifTrue: [ testSelectionBlock value: tree selectedItem content ] ]
]

{ #category : #initialization }
BMTestsTree >> initializeWidgets [
	tests := Dictionary new.
	self instantiateModels: #(tree	TreeModel).	
	tree childrenBlock: 
		[ :anObject | 
		tests 
			at: anObject 
			ifAbsent: [ {  } ] ].		
	tree iconBlock: [ :node | node icon: BMIcons ].
]

{ #category : #accessing }
BMTestsTree >> tree [
	^ tree
]

{ #category : #events }
BMTestsTree >> whenTestSelectedDo: aBlock [
	testSelectionBlock := aBlock
]
