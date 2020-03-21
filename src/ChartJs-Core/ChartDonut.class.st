"
I represent a homer donut chart
"
Class {
	#name : #ChartDonut,
	#superclass : #ChartType,
	#category : #'ChartJs-Core-Types'
}

{ #category : #accessing }
ChartDonut class >> dataFunction [
	^ 'segments'
]

{ #category : #accessing }
ChartDonut class >> eventsCode [
	^ 'getSegmentsAtEvent(evt)'
]

{ #category : #accessing }
ChartDonut class >> forChartJS [
	^ 'Doughnut'
]

{ #category : #ChartJs }
ChartDonut class >> isFor1DValues [
	^ true
]

{ #category : #accessing }
ChartDonut class >> typeName [
	^ 'doughnut'
]
