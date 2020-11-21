Extension { #name : #Object }

{ #category : #'*BabyMock2-Core' }
Object >> asBabyMockArgumentMatcher [
	^  BMSingleArgMatcher argumentIs: self
]

{ #category : #'*BabyMock2-Core' }
Object >> displayedObjectName [
	^ self class asString
]
