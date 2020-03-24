"
I represent a line chart
"
Class {
	#name : #ChartLine,
	#superclass : #ChartType,
	#category : #'ChartJs-Core-Types'
}

{ #category : #accessing }
ChartLine class >> dataFunction [
	^ 'points'
]

{ #category : #accessing }
ChartLine class >> eventsCode [
	^ 'getPointsAtEvent(evt)'
]

{ #category : #testing }
ChartLine class >> hasStyleSheetForValuesIn: aDataSet [
	^ false
]

{ #category : #testing }
ChartLine class >> isMultiDataSet [
	^ true
]

{ #category : #accessing }
ChartLine class >> styleSheetKeys [
	
	^ #(#borderColor #borderWidth #borderDash #lineTension #steppedLine #showLine #pointRadius #pointBorderColor #pointBorderWidth #pointBackgroundColor #pointHoverRadius #pointHoverBorderColor #pointHoverBorderWidth #pointHoverBackgroundColor #pointHitRadius #pointStyle #fill #backgroundColor) "line properties"

	"dot properties"

	"filled area below the line"
]

{ #category : #accessing }
ChartLine class >> typeName [
	^ 'line'
]
