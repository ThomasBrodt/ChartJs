"
I represent a candlestick chart (aka box plot)
"
Class {
	#name : #ChartCandlestick,
	#superclass : #ChartType,
	#category : #'ChartJs-Core-Types'
}

{ #category : #accessing }
ChartCandlestick class >> dataFunction [
	^ 'bars'
]

{ #category : #accessing }
ChartCandlestick class >> eventsCode [
	^ 'getBarsAtEvent(evt)'
]

{ #category : #testing }
ChartCandlestick class >> isMultiDataSet [
	^ true
]

{ #category : #accessing }
ChartCandlestick class >> typeName [
	^ 'candlestick'
]
