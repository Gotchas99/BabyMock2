"
A cash register that accepts barcodes and sends the total price of a sale to the receipt receiver.

It has 2 collaboratos
	- receiptReceiver that receives the total price at the end of the sale
	- productCatalog that translates barcodes to prices.
"
Class {
	#name : #BMCashRegister,
	#superclass : #Object,
	#instVars : [
		'receiptReceiver',
		'productCatalog',
		'totalPrice'
	],
	#category : #'BabyMock2-Examples'
}

{ #category : #'instance creation' }
BMCashRegister class >> receiptReceiver: aReceiptReceiver productCatalog: aProductCatalog [
	^ self new 
		setReceiptReceiver: aReceiptReceiver productCatalog: aProductCatalog
]

{ #category : #'sale event listener' }
BMCashRegister >> barcodeEntered: aBarcodeString [
	totalPrice 
		ifNil: [ totalPrice := productCatalog priceOf: aBarcodeString ] 
		ifNotNil: [ totalPrice := totalPrice + (productCatalog priceOf: aBarcodeString) ]
]

{ #category : #'sale event listener' }
BMCashRegister >> endSale [
	totalPrice ifNotNil: [ receiptReceiver priceCalculated: totalPrice ].
]

{ #category : #'sale event listener' }
BMCashRegister >> newSale [
	totalPrice := nil
]

{ #category : #initialization }
BMCashRegister >> setReceiptReceiver: aReceiptReceiver productCatalog: aProductCatalog [
	receiptReceiver := aReceiptReceiver.
	productCatalog := aProductCatalog.
	^ self
]
