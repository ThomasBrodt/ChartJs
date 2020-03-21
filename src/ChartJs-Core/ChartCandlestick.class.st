"
I represent a candlestick chart (aka box plot)
"
Class {
	#name : #ChartCandlestick,
	#superclass : #ChartType,
	#category : #'ChartJs-Core-Types'
}

{ #category : #testing }
ChartCandlestick class >> isMultiDataSet [
	^ true
]

{ #category : #accessing }
ChartCandlestick class >> typeName [
	^ 'candlestick'
]
