"
I represent a chart tree map for the data. Data should be provided by property tree, then data is automatically computed.
"
Class {
	#name : #ChartScatter,
	#superclass : #ChartType,
	#category : #'ChartJs-Core-Types'
}

{ #category : #testing }
ChartScatter class >> isMultiDataSet [
	^ true
]

{ #category : #accessing }
ChartScatter class >> styleSheetKeys [
	^ #(#pointColor #pointBorderColor #pointHoverBackgroundColor #pointHoverBorderColor)
]

{ #category : #accessing }
ChartScatter class >> typeName [
	^ 'scatter'
]
