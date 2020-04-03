"
I am the data set used for the chart type ""treemap""
"
Class {
	#name : #ChartDataSetTree,
	#superclass : #ChartDataSet,
	#instVars : [
		'tree',
		'groups',
		'key',
		'options'
	],
	#category : #'ChartJs-Core-Model'
}

{ #category : #accessing }
ChartDataSetTree >> groups [
	
	^ groups
]

{ #category : #accessing }
ChartDataSetTree >> groups: aCollection [
	
	groups := aCollection
]

{ #category : #accessing }
ChartDataSetTree >> key [
	
	^ key
]

{ #category : #accessing }
ChartDataSetTree >> key: aString [
	
	key := aString
]

{ #category : #exchange }
ChartDataSetTree >> neoJsonDataOn: aJsonMapWriter [
	
	aJsonMapWriter writeKey: #tree value: (tree ifNil: [#()])
]

{ #category : #converting }
ChartDataSetTree >> neoJsonOn: aJsonWriter [
	
	aJsonWriter writeMapStreamingDo: [:aJsonMapWriter |
		aJsonMapWriter writeKey: #key value: (key ifNil: '').
		aJsonMapWriter writeKey:  #groups value: (groups ifNil: #()).
		self neoJsonDataOn: aJsonMapWriter.
		self neoJsonOptionsOn: aJsonMapWriter.
		self neoJsonStyleSheetOn: aJsonMapWriter.
		self neoJsonChartOptionsOn: aJsonMapWriter]
]

{ #category : #exchange }
ChartDataSetTree >> neoJsonOptionsOn: aJsonMapWriter [
	self options keys asArray sort
		do:
			[ :eachKey | aJsonMapWriter writeKey: eachKey value: (options at: eachKey) ]
]

{ #category : #accessing }
ChartDataSetTree >> options [
	
	^ options ifNil: [options := ChartTreemapOptions new]
]

{ #category : #accessing }
ChartDataSetTree >> options: aChartOptions [
	
	options := aChartOptions
]

{ #category : #accessing }
ChartDataSetTree >> optionsAt: aKey put: aValue [
	
	self options at: aKey put: aValue
]

{ #category : #accessing }
ChartDataSetTree >> tree [
	
	^ tree
]

{ #category : #accessing }
ChartDataSetTree >> tree: aCollection [
	
	tree := aCollection
]
