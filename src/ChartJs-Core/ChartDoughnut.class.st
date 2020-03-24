"
I represent a homer donut chart
"
Class {
	#name : #ChartDoughnut,
	#superclass : #ChartType,
	#category : #'ChartJs-Core-Types'
}

{ #category : #accessing }
ChartDoughnut class >> dataFunction [
	^ 'segments'
]

{ #category : #accessing }
ChartDoughnut class >> eventsCode [
	^ 'getSegmentsAtEvent(evt)'
]

{ #category : #ChartJs }
ChartDoughnut class >> isFor1DValues [
	^ true
]

{ #category : #testing }
ChartDoughnut class >> isMultiDataSet [
	^ true
]

{ #category : #accessing }
ChartDoughnut class >> typeName [
	^ 'doughnut'
]
