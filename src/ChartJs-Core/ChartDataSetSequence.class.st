"
I am the most basic char data set existing, i just answer a collection of value from my sequence
"
Class {
	#name : #ChartDataSetSequence,
	#superclass : #ChartDataSet,
	#instVars : [
		'sequence',
		'dataValues'
	],
	#category : #'ChartJs-Core-Model'
}

{ #category : #'instance creation' }
ChartDataSetSequence class >> name: aName sequence: aSequence [
	^ self new name: aName;sequence: aSequence; yourself
]

{ #category : #'instance creation' }
ChartDataSetSequence class >> sequence: aSequence [
	^ self new sequence: aSequence; yourself
]

{ #category : #exchange }
ChartDataSetSequence >> atIndex: anInteger forValue: aValue [
	^ self sequence at: anInteger.
]

{ #category : #accessing }
ChartDataSetSequence >> dataValues [
	^ dataValues
]

{ #category : #accessing }
ChartDataSetSequence >> dataValues: aCollection [
	dataValues := aCollection
]

{ #category : #exchange }
ChartDataSetSequence >> neoJsonDataOn: aJsonMapWriter [
	
	aJsonMapWriter writeKey: #data value: sequence
]

{ #category : #exchange }
ChartDataSetSequence >> neoJsonStyleSheetOn: aJsonMapWriter [
	
	self chartType styleSheetKeys
		do: [:e |
			self hasStyleSheetForValues
				ifTrue: [
					| coll |
					coll := self dataValues collect: [:dv | dv styleSheet get: e ifAbsent: [self styleSheet get: e ifAbsent: []]].
					(coll allSatisfy: #notNil)
						ifTrue: [aJsonMapWriter writeKey: e value: (coll collect: #forChartJs)]]
				ifFalse: [self styleSheet get: e ifPresent: [:val | aJsonMapWriter writeKey: e value: val forChartJs]]]
]

{ #category : #accessing }
ChartDataSetSequence >> sequence [
	^ sequence
]

{ #category : #accessing }
ChartDataSetSequence >> sequence: anObject [
	sequence := anObject.
	self updateDataValues
]

{ #category : #accessing }
ChartDataSetSequence >> styleSheet: aStyleSheet [
	super styleSheet: aStyleSheet.
	hasStyleSheetForValues := false
]

{ #category : #accessing }
ChartDataSetSequence >> styleSheets: aCollection [
	hasStyleSheetForValues := true.
	self dataValues
		ifNotNil: [ :coll | 
			coll
				with: aCollection
				do: [ :eachValue :eachStylesheet | eachValue styleSheet: eachStylesheet ] ]
]

{ #category : #private }
ChartDataSetSequence >> updateDataValues [
	dataValues := self sequence collect: [:e | ChartDataValue value: e]
]
