"
I represent a pie chart
"
Class {
	#name : #ChartPie,
	#superclass : #ChartType,
	#category : #'ChartJs-Core-Types'
}

{ #category : #accessing }
ChartPie class >> dataFunction [
	^ 'segments'
]

{ #category : #accessing }
ChartPie class >> eventsCode [
	^ 'getSegmentsAtEvent(evt)'
]

{ #category : #accessing }
ChartPie class >> forChartJS [
	^ 'Pie'
]

{ #category : #testing }
ChartPie class >> isFor1DValues [
	^ true
]

{ #category : #testing }
ChartPie class >> isMultiDataSet [
	^ true
]

{ #category : #accessing }
ChartPie class >> typeName [
	^ 'pie'
]
