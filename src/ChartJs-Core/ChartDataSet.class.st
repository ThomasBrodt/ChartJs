"
I am an abstract dataSet. All dataSets have a style to display them and must be able to answer a bunch of value for provided objects
"
Class {
	#name : #ChartDataSet,
	#superclass : #Object,
	#instVars : [
		'name',
		'styleSheet',
		'chartType',
		'hasStyleSheetForValues',
		'yAxisID',
		'stack',
		'valueDisplayBlock'
	],
	#category : #'ChartJs-Core-Model'
}

{ #category : #exchange }
ChartDataSet >> atIndex: anIndex forValue: aValue [
	^ self subclassResponsibility 
]

{ #category : #color }
ChartDataSet >> borderedColor: aColor [
	self styleSheet globalSetBorderedColor: aColor
]

{ #category : #accessing }
ChartDataSet >> chartType [
	^ chartType
]

{ #category : #accessing }
ChartDataSet >> chartType: aChartType [
	chartType := aChartType
]

{ #category : #color }
ChartDataSet >> color: aColor [
	self styleSheet globalSetColor: aColor
]

{ #category : #testing }
ChartDataSet >> hasName [
	^ self name notNil
]

{ #category : #accessing }
ChartDataSet >> hasStyleSheetForValues [
	^ hasStyleSheetForValues ifNil: [hasStyleSheetForValues := false]
]

{ #category : #accessing }
ChartDataSet >> hasStyleSheetForValues: aBoolean [
	hasStyleSheetForValues := aBoolean
]

{ #category : #initialization }
ChartDataSet >> initialize [
	super initialize.
	self styleSheet: ChartStyleSheet charDataSetDefault.
	hasStyleSheetForValues := false
]

{ #category : #accessing }
ChartDataSet >> name [
	^ name
]

{ #category : #accessing }
ChartDataSet >> name: anObject [
	name := anObject
]

{ #category : #exchange }
ChartDataSet >> neoJsonChartOptionsOn: writer [
	self chartType optionKeys
		do: [ :e | 
			self styleSheet
				get: e
				ifPresent: [ :val | writer writeKey: e value: val ] ]
]

{ #category : #exchange }
ChartDataSet >> neoJsonDataOn: aJsonMapWriter [
	
	self subclassResponsibility
]

{ #category : #converting }
ChartDataSet >> neoJsonOn: writer [
	
	writer
		writeMapStreamingDo: [ :jsonMapWriter | 
			jsonMapWriter writeKey: #type value: self chartType typeName.
			jsonMapWriter writeKey: #label value: self name.
			self stack ifNotNil: [:str | jsonMapWriter writeKey: #stack value: str].
			self yAxisID ifNotNil: [:id | jsonMapWriter writeKey: #yAxisID value: id].
			self neoJsonDataOn: jsonMapWriter.
			self neoJsonStyleSheetOn: jsonMapWriter.
			self neoJsonOptionsOn: jsonMapWriter]
		
	
]

{ #category : #exchange }
ChartDataSet >> neoJsonOptionsOn: aJsonMapWriter [
]

{ #category : #exchange }
ChartDataSet >> neoJsonStyleSheetOn: aJsonMapWriter [
	styleSheet ifNil: [ ^ self ].
	self chartType styleSheetKeys
		do: [ :e | 
			self styleSheet
				get: e
				ifPresent: [ :val | aJsonMapWriter writeKey: e value: val forChartJs ] ]
]

{ #category : #accessing }
ChartDataSet >> stack [
	
	^ stack
]

{ #category : #accessing }
ChartDataSet >> stack: aString [
	
	stack := aString
]

{ #category : #accessing }
ChartDataSet >> styleSheet [
	^ styleSheet
]

{ #category : #accessing }
ChartDataSet >> styleSheet: anObject [
	styleSheet := anObject
]

{ #category : #accessing }
ChartDataSet >> valueDisplayBlock [
	^ valueDisplayBlock ifNil: [:obj | obj yourself ]
]

{ #category : #accessing }
ChartDataSet >> valueDisplayBlock: aBlockClosure [
	valueDisplayBlock := aBlockClosure 
]

{ #category : #accessing }
ChartDataSet >> yAxisID [

	^yAxisID
]

{ #category : #accessing }
ChartDataSet >> yAxisID: aString [

	yAxisID := aString
]
