"
A timed cache example that caches the loaded objects and reloads them only after it expired.

It had 3 collaborators:
 - objectLoader that is the source for loading the objects
 - reloadPolicy that decides whether something must be reloaded
 - clock that is used to supply the time for the reloadPolicy 
"
Class {
	#name : #BMCache,
	#superclass : #Object,
	#instVars : [
		'cachedValues',
		'reloadPolicy',
		'clock',
		'loadTimes',
		'objectLoader'
	],
	#classInstVars : [
		'cachedValues'
	],
	#category : #'BabyMock2-Examples'
}

{ #category : #'instance creation' }
BMCache class >> objectLoader: objectLoader reloadPolicy: reloadPolicy clock: clock [
	^ BMCache new 
		setObjectLoader: objectLoader 
		reloadPolicy: reloadPolicy 
		clock: clock
]

{ #category : #initialization }
BMCache >> initialize [ 
	super initialize.
	cachedValues := Dictionary new.
	loadTimes := Dictionary new.
]

{ #category : #private }
BMCache >> loadAndCache: aKey [
	| value |
	
	value := cachedValues 
		at: aKey 
		put: (objectLoader load: aKey).		
	loadTimes 
		at: aKey 
		put: clock time.		
	^ value.
]

{ #category : #cache }
BMCache >> lookup: key [
	^ cachedValues
		at: key
		ifPresent: 
			[ :cachedVal | self reloadAt: key orReturn: cachedVal ]
		ifAbsent: 
			[ self loadAndCache: key ]
]

{ #category : #private }
BMCache >> reloadAt: key orReturn: cachedVal [
	^ (self shouldReload: key)
		ifTrue: [ self loadAndCache: key ]
		ifFalse: [ cachedVal ]
]

{ #category : #initialization }
BMCache >> setObjectLoader: anObjectLoader reloadPolicy: aReloadPolicy clock: aClock [
	objectLoader := anObjectLoader.
	reloadPolicy := aReloadPolicy.
	clock := aClock.
	^ self
]

{ #category : #private }
BMCache >> shouldReload: aKey [
	^ reloadPolicy 
		shouldReloadItemLoaded: (loadTimes at: aKey) 
		fetched: clock time
]
