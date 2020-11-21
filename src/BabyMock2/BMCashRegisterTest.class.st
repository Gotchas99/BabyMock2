Class {
	#name : #BMCashRegisterTest,
	#superclass : #BabyMock2TestCase,
	#instVars : [
		'cashRegister',
		'receiptReceiver',
		'productCatalog',
		'state'
	],
	#category : #'BabyMock2-Examples'
}

{ #category : #private }
BMCashRegisterTest >> productCatalog: skuPriceAssocArray [
	skuPriceAssocArray do: 
		[ :each | 
		protocol describe 
			allow: productCatalog recv: #priceOf:; with: each key; 
			=> each value ]
]

{ #category : #running }
BMCashRegisterTest >> setUp [
	receiptReceiver := protocol mock: 'receiptReceiver'.
	productCatalog := protocol mock: 'productCatalog'.	
	cashRegister := BMCashRegister 
		receiptReceiver: receiptReceiver 
		productCatalog: productCatalog.
	protocol visualize: cashRegister.
	state := protocol states: 'register state' startsAs: #newSale.	
	
]

{ #category : #tests }
BMCashRegisterTest >> testThatItDoesNotReportPriceForEmptySale [
	protocol describe
		never: receiptReceiver recv: #priceCalculated:.		
	cashRegister
		newSale; 
		endSale.
]

{ #category : #tests }
BMCashRegisterTest >> testThatItReportsPriceForOneProduct [
	protocol describe
		productCatalog: { '1234' -> 2500 };	
		once: receiptReceiver recv: #priceCalculated:; with: 2500.				
	cashRegister 
		newSale; 
		barcodeEntered: '1234';
		endSale.
]

{ #category : #tests }
BMCashRegisterTest >> testThatItReportsPriceForTwoProduct [
	protocol describe
		productCatalog: { '1234' -> 2500. '5678' -> 500 };	
		once: receiptReceiver recv: #priceCalculated:; with: 3000.			
	cashRegister 
		newSale; 
		barcodeEntered: '1234';
		barcodeEntered: '5678';					
		endSale.
]

{ #category : #tests }
BMCashRegisterTest >> testThatItResetsPriceAfterEachSale [
	protocol describe
		productCatalog: { '1234' -> 2500. '5678' -> 500 };
		once: receiptReceiver recv: #priceCalculated:; with: 2500; 
		then: state is: #secondSale;
		once: receiptReceiver recv: #priceCalculated:; with: 500; 
		when: state is: #secondSale.		
	cashRegister 
		newSale;
		barcodeEntered: '1234';
		endSale;
		newSale; 
		barcodeEntered: '5678';
		endSale.
]
