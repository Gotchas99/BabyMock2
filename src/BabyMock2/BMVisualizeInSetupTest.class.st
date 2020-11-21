Class {
	#name : #BMVisualizeInSetupTest,
	#superclass : #BMGuiIntegrationTest,
	#category : #'BabyMock2-GUI-Tests'
}

{ #category : #running }
BMVisualizeInSetupTest >> postSetupContext: aBmMockery objectUnderTest: objectUnderTest [
	aBmMockery visualize: objectUnderTest
]

{ #category : #running }
BMVisualizeInSetupTest >> preTestContext: aBmMockery objectUnderTest: objectUnderTest [
]
