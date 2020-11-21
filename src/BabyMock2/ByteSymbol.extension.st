Extension { #name : #ByteSymbol }

{ #category : #'*BabyMock2-Core' }
ByteSymbol >> asBabyMockSelectorMatcher [
	^ BMSelectorMatcher selector: self
]
