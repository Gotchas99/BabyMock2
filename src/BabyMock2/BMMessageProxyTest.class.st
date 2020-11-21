Class {
	#name : #BMMessageProxyTest,
	#superclass : #BabyMock2TestCase,
	#instVars : [
		'proxy',
		'targetObject',
		'interceptedMessages'
	],
	#category : #'BabyMock2-Core-Tests'
}

{ #category : #'message interceptor' }
BMMessageProxyTest >> messageIntercepted: aMessage source: sourceMethodCtx destination: aTargetObject [
	interceptedMessages ifNotNil:
		[ interceptedMessages add: {aMessage. sourceMethodCtx.  aTargetObject} ].
	^ aMessage sendTo: aTargetObject
]

{ #category : #running }
BMMessageProxyTest >> setUp [
	targetObject := 'string target'.
	interceptedMessages := OrderedCollection new.
	BMMessageProxy replaceWithProxy: targetObject withInterceptor: self.
]

{ #category : #tests }
BMMessageProxyTest >> testNotifesInterceptorAboutTheMessage [
	targetObject size.
	self assert: #size equals: (interceptedMessages first first selector).
]
