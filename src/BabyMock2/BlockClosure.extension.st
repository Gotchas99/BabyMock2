Extension { #name : #BlockClosure }

{ #category : #'*BabyMock2-Core' }
BlockClosure >> asBabyMockArgumentMatcher [
	^ BMBlockArgMatcher fromBlock: self
]
