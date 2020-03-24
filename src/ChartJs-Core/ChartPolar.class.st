"
I represent a polar chart
"
Class {
	#name : #ChartPolar,
	#superclass : #ChartType,
	#category : #'ChartJs-Core-Types'
}

{ #category : #accessing }
ChartPolar class >> dataFunction [
	^ 'segments'
]

{ #category : #accessing }
ChartPolar class >> eventsCode [
	^ 'getSegmentsAtEvent(evt)'
]

{ #category : #testing }
ChartPolar class >> isFor1DValues [
	^ true
]

{ #category : #testing }
ChartPolar class >> isMultiDataSet [
	^ true
]

{ #category : #accessing }
ChartPolar class >> typeName [
	^ 'polarArea'
]
