"
I represent a bubble chart
"
Class {
	#name : #ChartBubble,
	#superclass : #ChartType,
	#category : #'ChartJs-Core-Types'
}

{ #category : #accessing }
ChartBubble class >> dataFunction [
	^ 'points'
]

{ #category : #accessing }
ChartBubble class >> eventsCode [
	^ 'getPointsAtEvent(evt)'
]

{ #category : #testing }
ChartBubble class >> isMultiDataSet [
	^ true
]

{ #category : #accessing }
ChartBubble class >> styleSheetKeys [
	^ #(#backgroundColor #borderColor #hoverBackgroundColor #hoverBorderColor #pointColor #pointBorderColor #pointHoverBackgroundColor #pointHoverBorderColor)
]

{ #category : #accessing }
ChartBubble class >> typeName [
	^ 'bubble'
]
