"
I am a chartData that you can provide to any graph. I have a list of xPoints to present and a collection of CharDataSets that defines positions for this xPoints.

I will be used for line, bar, radar and boxplot graph
"
Class {
	#name : #Chart2dData,
	#superclass : #ChartDataAbstract,
	#instVars : [
		'xObjects',
		'dataSets',
		'keyDisplayBlock'
	],
	#category : #'ChartJs-Core-Model'
}

{ #category : #'instance creation' }
Chart2dData class >> pointDataSets: aCollection [
	^ (self new)
		xObjects: (aCollection collect: [:e | e key]);
		dataSets: (aCollection collect: [:anAssociation | ChartDataSetSequence name: anAssociation key sequence: anAssociation value]);
		yourself
]

{ #category : #'instance creation' }
Chart2dData class >> xObjects: aCollectionOfObjects function: aBlock [
	^ self new
		xObjects: aCollectionOfObjects;
		dataSets: (aCollectionOfObjects collect: [:e | ChartDataSetFunction new name: e printString; function: aBlock; argument: e]);
		yourself
]

{ #category : #'instance creation' }
Chart2dData class >> xObjects: aCollectionOfObjects function: aBlockClosure color: aColor [ 
	^ self new
		xObjects: aCollectionOfObjects;
		dataSets: {(ChartDataSetFunction function: aBlockClosure color: aColor)};
		yourself
]

{ #category : #'instance creation' }
Chart2dData class >> xObjects: aCollectionOfObjects multiYObjects: aCollectionOfSequenceableCollectionOfObjectsToMap [
	^ self new
		xObjects: aCollectionOfObjects;
		dataSets:
				(aCollectionOfSequenceableCollectionOfObjectsToMap
						collect: [ :anAssociation | ChartDataSetSequence name: anAssociation key sequence: anAssociation value ]);
		yourself
]

{ #category : #'instance creation' }
Chart2dData class >> xObjects: aCollectionOfObjects yObjects: aSequenceableCollectionOfObjectsToMap [
	^ self new
		xObjects: aCollectionOfObjects;
		dataSets: {(ChartDataSetSequence sequence: aSequenceableCollectionOfObjectsToMap)};
		yourself
]

{ #category : #accessing }
Chart2dData >> addDataSet: aDataSet [
	dataSets add: aDataSet.
	aDataSet chartType ifNil: [aDataSet chartType: self chartType]
]

{ #category : #accessing }
Chart2dData >> addFunction: aFunctionBlock color: aColor [
	self dataSets
		addLast: (ChartDataSetFunction function: aFunctionBlock color: aColor)
]

{ #category : #callback }
Chart2dData >> at: anIndex ifPresent: aBlockClosure [
	^ aBlockClosure
		value: (self xObjects at: anIndex) -> (self dataSets first atIndex: anIndex forValue: (self xObjects at: anIndex))
]

{ #category : #exchange }
Chart2dData >> callBackValues [
	^ self dataSets first sequence
]

{ #category : #chartType }
Chart2dData >> chartType: aChartType [
	self
		assert: aChartType isMultiDataSet
		description: 'Chart accepted: Bar, Line, BoxPlot and Radar'.
	super chartType: aChartType.
	self dataSets
		ifNotNil:
			[ :ds | ds do: [ :e | e chartType ifNotNil: [ e chartType: aChartType ] ] ]
]

{ #category : #accessing }
Chart2dData >> dataSets [
	^ dataSets
]

{ #category : #accessing }
Chart2dData >> dataSets: anObject [
	dataSets := anObject asOrderedCollection.
	dataSets do: [:e | e chartType ifNil: [e chartType: self chartType]]
]

{ #category : #colors }
Chart2dData >> dataSetsBorderedColors: aCollectionOfColors [
	self
		assert: aCollectionOfColors size = self dataSets size
		description: 'The provided collection of colors must have one color per dataset'.
	self dataSets
		doWithIndex:
			[ :aDataSet :anIndex | aDataSet borderedColor: (aCollectionOfColors at: anIndex) ]
]

{ #category : #colors }
Chart2dData >> dataSetsColors: aCollectionOfColors [
	self
		assert: aCollectionOfColors size = self dataSets size
		description: 'The provided collection of colors must have one color per dataset'.
	self dataSets doWithIndex: [ :aDataSet :anIndex | aDataSet color: (aCollectionOfColors at: anIndex) ]
]

{ #category : #presentation }
Chart2dData >> displayKeysAsPercent [
	self keyDisplayBlock: [ :percent | (percent * 100) rounded asString, '%' ]
]

{ #category : #testing }
Chart2dData >> hasData [
	"Not all chartTypes need a xObject collection (e.g. treemap), so either xObject or dataSets can be nil"

	self xObjects
		ifNotNil: [ :x | 
			x isEmpty
				ifFalse: [ ^ true ] ].
	^ self dataSets notNil and: [ self dataSets notEmpty ]
]

{ #category : #testing }
Chart2dData >> hasLegend [
	^ self dataSets anySatisfy: #hasName
]

{ #category : #initialization }
Chart2dData >> initialize [
	super initialize.
	self chartType: ChartLine.
	dataSets := OrderedCollection new
]

{ #category : #accessing }
Chart2dData >> keyDisplayBlock [
	^ keyDisplayBlock ifNil: [ #yourself ]
]

{ #category : #accessing }
Chart2dData >> keyDisplayBlock: anObject [
	keyDisplayBlock := anObject
]

{ #category : #presentation }
Chart2dData >> labelFor: aString [ 
	^ (self keyDisplayBlock value: aString)
]

{ #category : #converting }
Chart2dData >> neoJsonOn: writer [
	writer
		writeMapStreamingDo: [ :jsonMapWriter | 
			xObjects
				ifNotNil: [ jsonMapWriter
						writeKey: #labels
						value: (xObjects collect: [ :aXObject | self labelFor: aXObject ]) ].
			self chartType isMultiDataSet
				ifTrue: [ jsonMapWriter writeKey: #datasets value: self dataSets
					"value: (self dataSets collect: [ :aDataSet | aDataSet neoJsonObjectFor: self xObjects block: self valueDisplayBlock ])" ]
				ifFalse: [ self error: 'Not supported graph type' ] ]
]

{ #category : #accessing }
Chart2dData >> styleSheets: aCollection [
	self dataSets do: [:e | e styleSheets: aCollection]
]

{ #category : #accessing }
Chart2dData >> title [

	^ title isBlock ifTrue: [ title value: self dataSets ] ifFalse: [ title ]
]

{ #category : #accessing }
Chart2dData >> xObjects [
	^ xObjects
]

{ #category : #accessing }
Chart2dData >> xObjects: anObject [
	xObjects := anObject
]
