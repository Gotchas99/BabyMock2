"
A simple shopping cart that calculates the total price of products and charges the credit card with the appropriate price.

It has 3 collaborats:
 - priceCatalog that can translate SKUs to price
 - discountCalculator that calculates discount price based on the total price
 - creditCard that will be charged with the price
"
Class {
	#name : #BMShoppingCart,
	#superclass : #Object,
	#instVars : [
		'creditCard',
		'priceCatalog',
		'discountCalculator',
		'skus'
	],
	#category : #'BabyMock2-Examples'
}

{ #category : #'instance creation' }
BMShoppingCart class >> payment: aCreditCard priceCatalog: aPriceCatalog discountCalculator: aDiscountCalculator [
	^ self new
		setPayment: aCreditCard
		catalog: aPriceCatalog
		discountCalculator: aDiscountCalculator
]

{ #category : #'shopping cart' }
BMShoppingCart >> addSKU: aSymbol [
	self skus add: aSymbol
]

{ #category : #'shopping cart' }
BMShoppingCart >> checkout [
	self skus ifNotEmpty: 
		[ | totalPrice |
		totalPrice := self totalPrice.
		creditCard charge: totalPrice - (self discountPrice: totalPrice).
		self skus removeAll ]
]

{ #category : #private }
BMShoppingCart >> discountPrice: totalPrice [
	^ discountCalculator calculateDiscount: totalPrice
]

{ #category : #initialization }
BMShoppingCart >> setPayment: aCreditCard catalog: aPriceCatalog discountCalculator: aDiscountCalculator [
	creditCard := aCreditCard.
	priceCatalog := aPriceCatalog.
	discountCalculator := aDiscountCalculator.
	^ self
]

{ #category : #private }
BMShoppingCart >> skus [
	^ skus ifNil: [ skus := OrderedCollection new ]
]

{ #category : #private }
BMShoppingCart >> totalPrice [
	^ (self skus collect: [ :each | priceCatalog priceOf: each ]) sum
]
