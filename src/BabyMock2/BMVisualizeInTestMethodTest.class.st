Class {
	#name : #BMVisualizeInTestMethodTest,
	#superclass : #BMGuiIntegrationTest,
	#category : #'BabyMock2-GUI-Tests'
}

{ #category : #running }
BMVisualizeInTestMethodTest >> postSetupContext: aBmMockery objectUnderTest: objectUnderTest [

]

{ #category : #running }
BMVisualizeInTestMethodTest >> preTestContext: aBmMockery objectUnderTest: objectUnderTest [
	aBmMockery visualize: objectUnderTest
]
