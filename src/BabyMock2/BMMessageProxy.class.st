"
This uses the technique described by the following paper to create proxy objects.

""Efficient Proxies in Smalltalk"" (IWST 2011), Mariano Martinez Peck, Noury Bouraqadi, Marcus Denker, Stéphane Ducasse, and Luc Fabresse. 
"
Class {
	#name : #BMMessageProxy,
	#superclass : #Object,
	#instVars : [
		'targetObject',
		'interceptor'
	],
	#category : #'BabyMock2-Core'
}

{ #category : #'instance creation' }
BMMessageProxy class >> proxyFor: anObject withInterceptor: aMessageInterceptor [
	| proxy |
	proxy := BMMessageProxy new 
					onObject: anObject 
					withInterceptor: aMessageInterceptor.
	BMMessageTrap initialize.
	BMMessageTrap adoptInstance: proxy.
	^ proxy
]

{ #category : #'instance creation' }
BMMessageProxy class >> replaceWithProxy: anObjectBecomingProxy withInterceptor: aMessageInterceptor [
	| proxyBecomingObject |
	proxyBecomingObject := BMMessageProxy new 
					onObject: anObjectBecomingProxy 
					withInterceptor: aMessageInterceptor.
	proxyBecomingObject become: anObjectBecomingProxy.
	anObjectBecomingProxy targetObject: proxyBecomingObject. "set the target object again because of the become"
	BMMessageTrap initialize.
	BMMessageTrap adoptInstance: anObjectBecomingProxy.
	^ proxyBecomingObject.
]

{ #category : #'instance creation' }
BMMessageProxy class >> withInterceptor: aMessageInterceptor [
	| proxy |
	proxy := BMMessageProxy new.
	proxy onObject: proxy withInterceptor: aMessageInterceptor.
	BMMessageTrap initialize.
	BMMessageTrap adoptInstance: proxy.
	^ proxy
]

{ #category : #proxying }
BMMessageProxy >> cannotInterpret: aMessage [
	^ interceptor messageIntercepted: aMessage source: thisContext sender destination: targetObject


]

{ #category : #'initialize-release' }
BMMessageProxy >> onObject: aTargetObject withInterceptor: aMessageInterceptor [
	targetObject := aTargetObject.
	interceptor := aMessageInterceptor
]

{ #category : #'initialize-release' }
BMMessageProxy >> targetObject: aTargetObject [
	targetObject := aTargetObject
]
