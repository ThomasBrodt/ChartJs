"
ChartAbstractOptions is an abstract class for options in chart.js. It defines a dictionary where all settings are managed and then exported as json.
"
Class {
	#name : #ChartAbstractOptions,
	#superclass : #Object,
	#instVars : [
		'dictionary'
	],
	#category : #'ChartJs-Core-Model'
}

{ #category : #accessing }
ChartAbstractOptions >> at: aKey [ 
	^ self at: aKey ifAbsent: []
]

{ #category : #accessing }
ChartAbstractOptions >> at: aFirstKey at: aSecondKey at: aThirdKey put: aValue [
	
	(self at: aFirstKey at: aSecondKey ifAbsentPut: [Dictionary new]) 
		at: aThirdKey put: aValue
]

{ #category : #accessing }
ChartAbstractOptions >> at: aFirstKey at: aSecondKey ifAbsentPut: aBlock [
	^ (self at: aFirstKey ifAbsentPut: [Dictionary new]) 
		at: aSecondKey ifAbsentPut: aBlock
]

{ #category : #accessing }
ChartAbstractOptions >> at: aFirstKey at: aSecondKey put: aValue [
	(self at: aFirstKey ifAbsentPut: [Dictionary new]) 
		at: aSecondKey put: aValue
]

{ #category : #accessing }
ChartAbstractOptions >> at: aKey ifAbsent: aBlock [
	^ dictionary at: aKey ifAbsent: aBlock
]

{ #category : #accessing }
ChartAbstractOptions >> at: aKey ifAbsentPut: aBlock [
	^ dictionary at: aKey ifAbsentPut: aBlock
]

{ #category : #accessing }
ChartAbstractOptions >> at: aKey put: aValue [
	dictionary at: aKey put: aValue
]

{ #category : #'initialize-release' }
ChartAbstractOptions >> initialize [
	super initialize.
	dictionary := Dictionary new
]

{ #category : #private }
ChartAbstractOptions >> keys [
	
	^ dictionary keys
]

{ #category : #private }
ChartAbstractOptions >> keysAndValuesDo: aBlock [

	dictionary keysAndValuesDo: aBlock.
]

{ #category : #converting }
ChartAbstractOptions >> neoJsonOn: writer [
	writer writeMap: dictionary
]
