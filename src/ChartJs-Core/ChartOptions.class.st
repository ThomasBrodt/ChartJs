"
I represent all the options for a chart (scale, axis color...)
"
Class {
	#name : #ChartOptions,
	#superclass : #ChartAbstractOptions,
	#instVars : [
		'toolTip'
	],
	#category : #'ChartJs-Core-Model'
}

{ #category : #'accessing scales' }
ChartOptions >> addXAxis [
	^ (self scalesAt: #xAxes ifAbsentPut: [OrderedCollection new]) add: ChartAxisOptions new
]

{ #category : #'accessing scales' }
ChartOptions >> addYAxis [
	^ (self scalesAt: #yAxes ifAbsentPut: [OrderedCollection new]) add: ChartAxisOptions new
]

{ #category : #converting }
ChartOptions >> asDictionary [
	| optionDictionary |
	optionDictionary := Dictionary new.
	optionDictionary
		at: #scales
		put:
			{(#xAxes -> self xAxis).
			(#yAxes -> self yAxis)} asDictionary.
	^ optionDictionary
]

{ #category : #accessing }
ChartOptions >> aspectRatio: aNumber [
	self at: #aspectRatio put: aNumber
]

{ #category : #accessing }
ChartOptions >> circumference: aNumber [
	self at: #circumference put: aNumber
]

{ #category : #accessing }
ChartOptions >> cutoutPercentage: aNumber [
	self at: #cutoutPercentage put: aNumber
]

{ #category : #'accessing elements' }
ChartOptions >> elements [
	^ self at: #elements
]

{ #category : #'accessing elements' }
ChartOptions >> elementsAt: aKey at: anElementKey put: aValue [
	(self elementsAt: aKey ifAbsentPut: [Dictionary new]) at: anElementKey put: aValue
]

{ #category : #'accessing elements' }
ChartOptions >> elementsAt: aKey ifAbsentPut: aBlock [
	^ (self at: #elements ifAbsentPut: [Dictionary new]) at: aKey ifAbsentPut: aBlock
]

{ #category : #'accessing elements' }
ChartOptions >> elementsAt: aKey put: aValue [
	(self at: #elements ifAbsentPut: [Dictionary new]) at: aKey put: aValue
]

{ #category : #testing }
ChartOptions >> hasToolTip [
	^ self toolTip notNil
]

{ #category : #'accessing legend' }
ChartOptions >> legendAt: aKey ifAbsentPut: aBlock [
	(self at: #legend ifAbsentPut: [Dictionary new]) at: aKey ifAbsentPut: aBlock
]

{ #category : #'accessing legend' }
ChartOptions >> legendAt: aKey put: aValue [
	(self at: #legend ifAbsentPut: [Dictionary new]) at: aKey put: aValue
]

{ #category : #'accessing legend' }
ChartOptions >> legendDisplay: aBoolean [
	self legendAt: #display put: aBoolean
]

{ #category : #'accessing legend' }
ChartOptions >> legendPosition: aSymbol [
	self legendAt: #position put: aSymbol
]

{ #category : #accessing }
ChartOptions >> maintainAspectRatio: aBoolean [
	self at: #maintainAspectRatio put: aBoolean
]

{ #category : #converting }
ChartOptions >> neoJsonOn: neoJSONWriter [
	neoJSONWriter writeMap: self asDictionary
]

{ #category : #'accessing plugins' }
ChartOptions >> plugins [
	^ self at: #plugins
]

{ #category : #'accessing plugins' }
ChartOptions >> pluginsAt: aKey at: aPluginKey put: aValue [
	(self pluginsAt: aKey ifAbsentPut: [Dictionary new]) at: aPluginKey put: aValue
]

{ #category : #'accessing plugins' }
ChartOptions >> pluginsAt: aKey ifAbsentPut: aBlock [
	^ (self at: #plugins ifAbsentPut: [Dictionary new]) at: aKey ifAbsentPut: aBlock
]

{ #category : #'accessing plugins' }
ChartOptions >> pluginsAt: aKey put: aValue [
	(self at: #plugins ifAbsentPut: [Dictionary new]) at: aKey put: aValue
]

{ #category : #accessing }
ChartOptions >> responsive: aBoolean [
	self at: #responsive put: aBoolean
]

{ #category : #accessing }
ChartOptions >> rotation: aNumber [
	self at: #rotation put: aNumber
]

{ #category : #'accessing scales' }
ChartOptions >> scale [
	^ self at: #scale ifAbsentPut: [ChartAxisOptions new]
]

{ #category : #'accessing scales' }
ChartOptions >> scaleAt: aKey ifAbsentPut: aBlock [
	self scale at: aKey ifAbsentPut: aBlock
]

{ #category : #'accessing scales' }
ChartOptions >> scaleAt: aKey put: aValue [
	self scale at: aKey put: aValue
]

{ #category : #'accessing scales' }
ChartOptions >> scales [
	^ self at: #scales ifAbsentPut: [Dictionary new]
]

{ #category : #'accessing scales' }
ChartOptions >> scalesAt: aKey ifAbsentPut: aBlock [
	^ (self at: #scales ifAbsentPut: [Dictionary new]) at: aKey ifAbsentPut: aBlock
]

{ #category : #'accessing scales' }
ChartOptions >> scalesAt: aKey put: aValue [
	(self at: #scales ifAbsentPut: [Dictionary new]) at: aKey put: aValue
]

{ #category : #'accessing title' }
ChartOptions >> titleAt: aKey put: aValue [
	(self at: #title ifAbsentPut: [Dictionary new]) at: aKey put: aValue
]

{ #category : #'accessing title' }
ChartOptions >> titleDisplay: aBoolean [
	self titleAt: #display put: aBoolean
]

{ #category : #'accessing title' }
ChartOptions >> titlePosition: aSymbol [
	self titleAt: #position put: aSymbol
]

{ #category : #'accessing title' }
ChartOptions >> titleText: aString [
	self titleAt: #text put: aString
]

{ #category : #accessing }
ChartOptions >> toolTip [
	^ toolTip
]

{ #category : #accessing }
ChartOptions >> toolTip: aToolTipBlock [
	self
		assert: (aToolTipBlock isBlock and: [ aToolTipBlock numArgs = 2 ])
		description: 'You must provide a two arguments block'.
	toolTip := aToolTipBlock
]

{ #category : #'accessing tooltips' }
ChartOptions >> tooltipsAt: aKey at: aTooltipKey put: aValue [
	
	(self tooltipsAt: aKey ifAbsentPut: [Dictionary new]) at: aTooltipKey put: aValue
]

{ #category : #'accessing tooltips' }
ChartOptions >> tooltipsAt: aKey ifAbsentPut: aBlock [
	
	^ (self at: #tooltips ifAbsentPut: [Dictionary new]) at: aKey ifAbsentPut: aBlock
]

{ #category : #'accessing tooltips' }
ChartOptions >> tooltipsAt: aKey put: aValue [
	(self at: #tooltips ifAbsentPut: [Dictionary new]) at: aKey put: aValue
]

{ #category : #'accessing scales' }
ChartOptions >> xAxes [
	^ self scales at: #xAxes ifAbsent: []
]

{ #category : #'accessing scales' }
ChartOptions >> xAxes: aCollectionOfChartAxisOptions [
	self scales at: #xAxes put: aCollectionOfChartAxisOptions
]

{ #category : #'accessing scales' }
ChartOptions >> xAxis [
	self xAxes ifNil: [self scalesAt: #xAxes put: (OrderedCollection with: ChartAxisOptions new)].
	^ self xAxes first
]

{ #category : #'accessing scales' }
ChartOptions >> yAxes [
	^ self scales at: #yAxes ifAbsent: []
]

{ #category : #'accessing scales' }
ChartOptions >> yAxes: aCollectionOfChartAxisOptions [
	self scales at: #yAxes put: aCollectionOfChartAxisOptions
]

{ #category : #'accessing scales' }
ChartOptions >> yAxis [
	self yAxes ifNil: [self scalesAt: #yAxes put: (OrderedCollection with: ChartAxisOptions new)].
	^ self yAxes first
]
