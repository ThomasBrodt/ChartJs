"
ChartTreemapOptions is a specialised Options class for the options used in a treemap chart
"
Class {
	#name : #ChartTreemapOptions,
	#superclass : #ChartAbstractOptions,
	#category : #'ChartJs-Core-Model'
}

{ #category : #accessing }
ChartTreemapOptions >> backgroundColor: aString [
	
	self at: #backgroundColor put: aString
]

{ #category : #accessing }
ChartTreemapOptions >> borderColor: aString [
	
	self at: #borderColor put: aString
]

{ #category : #accessing }
ChartTreemapOptions >> borderWidth: aNumber [
	
	self at: #borderWidth put: aNumber
]

{ #category : #accessing }
ChartTreemapOptions >> fontColor: aString [
	
	self at: #fontColor put: aString
]

{ #category : #accessing }
ChartTreemapOptions >> fontFamily: aString [
	
	self at: #fontFamily put: aString
]

{ #category : #accessing }
ChartTreemapOptions >> fontSize: aStringOrNumber [
	
	self at: #fontSize put: aStringOrNumber
]

{ #category : #accessing }
ChartTreemapOptions >> fontStyle: aString [
	
	self at: #fontStyle put: aString
]

{ #category : #accessing }
ChartTreemapOptions >> hoverBackgroundColor: aString [
	
	self at: #hoverBackgroundColor put: aString
]

{ #category : #accessing }
ChartTreemapOptions >> spacing: aNumber [
	
	self at: #spacing put: aNumber
]
