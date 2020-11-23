Class {
	#name : #BaselineOfBabyMock2,
	#superclass : #BaselineOf,
	#category : #BaselineOfBabyMock2
}

{ #category : #baselines }
BaselineOfBabyMock2 >> baseline: spec [
	<baseline>
	spec
		for: #pharo
		do: [ spec
				package: 'BabyMock2';
				group: 'default' with: #('BabyMock2') ] 
]
