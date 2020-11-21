"
BabyMock TimedCached test based on ""Mock Roles, not Objects - jMock"" paper.
"
Class {
	#name : #BMCacheTest,
	#superclass : #BabyMock2TestCase,
	#instVars : [
		'cache',
		'reloadPolicy',
		'clock',
		'objectLoader'
	],
	#category : #'BabyMock2-Examples'
}

{ #category : #running }
BMCacheTest >> setUp [
	objectLoader := protocol mock: 'objectLoader'.
	reloadPolicy := protocol mock: 'reloadPolicy'.
	clock := protocol mock: 'clock'.
	cache := BMCache objectLoader: objectLoader reloadPolicy: reloadPolicy clock: clock.
	protocol visualize: cache.
]

{ #category : #tests }
BMCacheTest >> testLoadsObjectThatIsNotCached [
	protocol describe
		ignore: clock;
		once: objectLoader recv: #load:; with: 'key1'; => 'value1';
		once: objectLoader recv: #load:; with: 'key2'; => 'value2'.
	self assert: (cache lookup: 'key1') equals: 'value1'.
	self assert: (cache lookup: 'key2') equals: 'value2'.
]

{ #category : #tests }
BMCacheTest >> testReloadsCachedObjectAfterTimeout [
	protocol describe
		allow: clock recv: #time;
			=> 'load time';
			=> 'fetch time'; 
			=> 'reload time';
		twice: objectLoader recv: #load:; with: 'key';
			=> 'value'; 
			=> 'new value';
		allow: reloadPolicy recv: #shouldReloadItemLoaded:fetched:; 
			with: 'load time' and: 'fetch time'; 
			=> true.
	self assert: (cache lookup: 'key') equals: 'value'.
	self assert: (cache lookup: 'key') equals: 'new value'.	
]

{ #category : #tests }
BMCacheTest >> testReturnsCachedObjectWithinTimeout [
	protocol describe
		allow: clock recv: #time;
			=> 'load time'; 
			=> 'fetch time';
		once: objectLoader recv: #load:; with: 'key';
			=> 'value';
		allow: reloadPolicy recv: #shouldReloadItemLoaded:fetched:; 
			with: 'load time' and: 'fetch time'; 
			=> false.		
	self assert: (cache lookup: 'key') equals: 'value'.
	self assert: (cache lookup: 'key') equals: 'value'.
]
