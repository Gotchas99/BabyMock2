Class {
	#name : #BMShoppingCartTest,
	#superclass : #BabyMock2TestCase,
	#instVars : [
		'cart',
		'creditCard',
		'priceCatalog',
		'discountCalculator',
		'cartState'
	],
	#category : #'BabyMock2-Examples'
}

{ #category : #private }
BMShoppingCartTest >> discountFor: totalPrice is: discountPrice [
	protocol describe
		allow: discountCalculator recv: #calculateDiscount:; 
			with: totalPrice; 
			=> discountPrice.
]

{ #category : #private }
BMShoppingCartTest >> noDiscount [
	protocol describe
		allow: discountCalculator recv: #calculateDiscount:; => 0
]

{ #category : #private }
BMShoppingCartTest >> prices: priceAssociations [
	priceAssociations do: [ :each |
		protocol describe
			allow: priceCatalog recv: #priceOf:; with: each key;
				=> each value
	]
]

{ #category : #running }
BMShoppingCartTest >> setUp [
	creditCard := protocol mock: 'creditCard'.
	priceCatalog := protocol mock: 'priceCatalog'.
	discountCalculator := protocol mock: 'discountCalculator'.
	cartState := protocol states: 'shopping cart state' startsAs: #firstSale.
	
	cart := BMShoppingCart 
		payment: creditCard 
		priceCatalog: priceCatalog 
		discountCalculator: discountCalculator.
		
	protocol visualize: cart.
]

{ #category : #tests }
BMShoppingCartTest >> testChargingCardAfterBuyingManyProducts [
	protocol describe		
		prices: {#sku1 -> 10. #sku2 -> 30. #sku3 -> 50}; noDiscount;
		once: creditCard recv: #charge:; with: 90.
	cart 
		addSKU: #sku1;
		addSKU: #sku2;
		addSKU: #sku3;
		checkout.
]

{ #category : #tests }
BMShoppingCartTest >> testChargingCardAfterBuyingOneProduct [
	protocol describe		
		prices: {#sku1 -> 80}; noDiscount;
		once: creditCard recv: #charge:; with: 80.
	cart addSKU: #sku1.
	cart checkout.
]

{ #category : #tests }
BMShoppingCartTest >> testChargingCardWithDiscount [
	protocol describe
		prices: {#sku1 -> 20. #sku2 -> 30};
		discountFor: 50 is: 10;
		once: creditCard recv: #charge:; with: 40.		
	cart addSKU: #sku1.
	cart addSKU: #sku2.	
	cart checkout.
	

]

{ #category : #tests }
BMShoppingCartTest >> testDoesNotChargeWhenItIsEmpty [
	protocol describe
		never: creditCard recv: #charge:.
	cart checkout.


]

{ #category : #tests }
BMShoppingCartTest >> testUnloadsItselfAfterCheckout [
	protocol describe
		prices: {#sku1 -> 10. #sku2 -> 30}; noDiscount;
		once: creditCard recv: #charge:; with: 10; 
		when: cartState is: #firstSale; then: cartState is: #secondSale;
		once: creditCard recv: #charge:; with: 30;	
		when: cartState is: #secondSale.	
	cart addSKU: #sku1.
	cart checkout.	
	cart addSKU: #sku2.
	cart checkout.
]
