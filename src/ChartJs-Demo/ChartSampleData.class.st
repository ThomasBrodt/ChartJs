"
ChartSampleData provides access to some data samples used in the chart.js demos
"
Class {
	#name : #ChartSampleData,
	#superclass : #Object,
	#category : #'ChartJs-Demo'
}

{ #category : #'sample data' }
ChartSampleData class >> bubbleData [
	^ Array with: self bubbleData1 with: self bubbleData2
]

{ #category : #'sample data' }
ChartSampleData class >> bubbleData1 [
	^ 'First dataset' -> ((1 to: 8) collect: [:e | ChartDataTriplet fromColor: Color random])
]

{ #category : #'sample data' }
ChartSampleData class >> bubbleData2 [
	^ 'Second dataset' -> ((1 to: 8) collect: [:e | ChartDataTriplet fromColor: Color random])
]

{ #category : #'sample data' }
ChartSampleData class >> bubbleData3 [
	^ 'Third dataset' -> ((1 to: 8) collect: [:e | ChartDataTriplet fromColor: Color random])
]

{ #category : #'sample data' }
ChartSampleData class >> data [
	^ Array with: self data1 with: self data2
]

{ #category : #'sample data' }
ChartSampleData class >> data1 [
	^ 'Guillaume' -> #(65 59 90 81 56 55 40)
]

{ #category : #'sample data' }
ChartSampleData class >> data2 [
	^ 'Cyril' -> #(28 48 40 19 96 27 100)
]

{ #category : #'sample data' }
ChartSampleData class >> dataSet1 [
	^ ChartDataSetSequence name: self data1 key sequence: self data1 value
]

{ #category : #'sample data' }
ChartSampleData class >> dataSets [
	^ self data collect: [:e | ChartDataSetSequence name: e key sequence: e value]
]

{ #category : #'sample data' }
ChartSampleData class >> labels [
	^ #('Eating' 'Drinking' 'Sleeping' 'Designing' 'Coding' 'Cycling' 'Running')
]
