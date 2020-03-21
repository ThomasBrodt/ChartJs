"
I represent a chart tree map for the data. Data should be provided by property tree, then data is automatically computed.
"
Class {
	#name : #ChartTreemap,
	#superclass : #ChartType,
	#category : #'ChartJs-Core-Types'
}

{ #category : #testing }
ChartTreemap class >> isMultiDataSet [
	
	^ true
]

{ #category : #accessing }
ChartTreemap class >> typeName [
	
	^ 'treemap'
]
