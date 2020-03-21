"
I am the superclass for all chart types
"
Class {
	#name : #ChartType,
	#superclass : #Object,
	#category : #'ChartJs-Core-Types'
}

{ #category : #ChartJs }
ChartType class >> addOptionKey: aKey to: aDictionary for: aDataSet [
	aDataSet styleSheet
		get: aKey
		ifPresent: [:val | aDictionary at: aKey put: val forChartJs]
]

{ #category : #ChartJs }
ChartType class >> addOptionsTo: aDictionary for: aDataSet [
	self optionKeys
		do: [:eachKey |
			self
				addOptionKey: eachKey
				to: aDictionary
				for: aDataSet]
]

{ #category : #ChartJs }
ChartType class >> addStyleSheetKey: aKey to: aDictionary for: aDataSet [

	(self hasStyleSheetForValuesIn: aDataSet)
		ifTrue: [
			| coll |
			coll := aDataSet dataValues
				collect: [:dv | dv styleSheet get: aKey ifAbsent: [aDataSet styleSheet get: aKey ifAbsent: []]].
			(coll allSatisfy: #notNil)
				ifTrue: [aDictionary at: aKey put: (coll collect: #forChartJs)]]
		ifFalse: [
			aDataSet styleSheet
				get: aKey
				ifPresent: [:val | aDictionary at: aKey put: val forChartJs]]
]

{ #category : #ChartJs }
ChartType class >> addStyleSheetTo: aDictionary for: aDataSet [
	self styleSheetKeys
		do: [:eachKey |
			self
				addStyleSheetKey: eachKey
				to: aDictionary
				for: aDataSet]
]

{ #category : #accessing }
ChartType class >> cssClass [
	^ 'chartjs-charttype-', self typeName
]

{ #category : #ChartJs }
ChartType class >> dataFunction [
	^ self subclassResponsibility 
]

{ #category : #ChartJs }
ChartType class >> eventsCode [
	^ self subclassResponsibility 
]

{ #category : #ChartJs }
ChartType class >> forChartJS [
	^ self subclassResponsibility 
]

{ #category : #testing }
ChartType class >> hasStyleSheetForValuesIn: aDataSet [
	^ aDataSet hasStyleSheetForValues
]

{ #category : #testing }
ChartType class >> isFor1DValues [
	^ false
]

{ #category : #testing }
ChartType class >> isMultiDataSet [
	^ false
]

{ #category : #accessing }
ChartType class >> optionKeys [
	^ #()
]

{ #category : #accessing }
ChartType class >> styleSheetKeys [
	^ #(#backgroundColor #borderColor #hoverBackgroundColor #hoverBorderColor)
]

{ #category : #accessing }
ChartType class >> typeName [
	
	^ self subclassResponsibility 
]
