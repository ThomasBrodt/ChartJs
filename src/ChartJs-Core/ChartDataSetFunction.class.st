"
I am a dataSet based on a block. I will compute y values by providing x values to this block
"
Class {
	#name : #ChartDataSetFunction,
	#superclass : #ChartDataSet,
	#instVars : [
		'function',
		'argument'
	],
	#category : #'ChartJs-Core-Model'
}

{ #category : #'instance creation' }
ChartDataSetFunction class >> function: aBlock [
	^ self new
		function: aBlock;
		yourself
]

{ #category : #'instance creation' }
ChartDataSetFunction class >> function: aBlockClosure argument: anArg [
	^ (self function: aBlockClosure)
		argument: anArg;
		yourself
]

{ #category : #'instance creation' }
ChartDataSetFunction class >> function: aBlockClosure color: aColor [
	^ (self function: aBlockClosure)
		color: aColor;
		yourself
]

{ #category : #accessing }
ChartDataSetFunction >> argument [
	^ argument
]

{ #category : #accessing }
ChartDataSetFunction >> argument: anObject [
	argument := anObject
]

{ #category : #accessing }
ChartDataSetFunction >> atIndex: anIndex forValue: aValue [
	^ self function value: aValue
]

{ #category : #style }
ChartDataSetFunction >> color: aColor [ 
	self styleSheet globalSetColor: aColor.
]

{ #category : #accessing }
ChartDataSetFunction >> function [
	^ function
]

{ #category : #accessing }
ChartDataSetFunction >> function: anObject [
	function := anObject
]

{ #category : #'as yet unclassified' }
ChartDataSetFunction >> neoJsonDataOn: aWriter [

	aWriter writeKey: #data value: (self function value: self argument)
]

{ #category : #'as yet unclassified' }
ChartDataSetFunction >> neoJsonOn: writer [
	
	writer
		writeMapStreamingDo: [ :jsonMapWriter | 
			jsonMapWriter writeKey: #label value: self name.
			self neoJsonDataOn: jsonMapWriter.
			self neoJsonStyleSheetOn: jsonMapWriter.
			self neoJsonOptionsOn: jsonMapWriter]
		
	
]
