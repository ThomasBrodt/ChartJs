"
I represent a Radar chart, also called Kiviat
"
Class {
	#name : #ChartRadar,
	#superclass : #ChartType,
	#category : #'ChartJs-Core-Types'
}

{ #category : #accessing }
ChartRadar class >> dataFunction [
	^ 'points'
]

{ #category : #accessing }
ChartRadar class >> eventsCode [
	^ 'getPointsAtEvent(evt)'
]

{ #category : #testing }
ChartRadar class >> hasStyleSheetForValuesIn: aDataSet [
	^ false
]

{ #category : #testing }
ChartRadar class >> isMultiDataSet [
	^ true
]

{ #category : #accessing }
ChartRadar class >> typeName [
	^ 'radar'
]
