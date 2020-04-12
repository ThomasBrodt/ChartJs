"
ChartSampleData provides access to some data samples used in the chart.js demos
"
Class {
	#name : #ChartSampleData,
	#superclass : #Object,
	#category : #'ChartJs-Demo'
}

{ #category : #'sample data' }
ChartSampleData class >> activities [
	^ (self dataDictionary at: self dataDictionary keys first) keys
]

{ #category : #'sample data' }
ChartSampleData class >> bubbleData [
	^ Array with: self bubbleData1 with: self bubbleData2
]

{ #category : #'sample data' }
ChartSampleData class >> bubbleData1 [
	^ 'First dataset' -> ((1 to: 8) collect: [:e | ChartSampleDataTriplet fromColor: Color random])
]

{ #category : #'sample data' }
ChartSampleData class >> bubbleData2 [
	^ 'Second dataset' -> ((1 to: 8) collect: [:e | ChartSampleDataTriplet fromColor: Color random])
]

{ #category : #'sample data' }
ChartSampleData class >> bubbleData3 [
	^ 'Third dataset' -> ((1 to: 8) collect: [:e | ChartSampleDataTriplet fromColor: Color random])
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
ChartSampleData class >> dataByLabels [

	| dict |
	dict := Dictionary new.
	self labels doWithIndex: [:e :i | dict at: e put: (self data collect: [:c | c value at: i])].
	^ dict
]

{ #category : #'sample data' }
ChartSampleData class >> dataDictionary [
	^ Dictionary new
		at: 'Guillaume'
			put:
			(Dictionary new
				at: 'Eating' put: 65;
				at: 'Drinking' put: 59;
				at: 'Sleeping' put: 90;
				at: 'Designing' put: 81;
				at: 'Coding' put: 56;
				at: 'Cycling' put: 55;
				at: 'Running' put: 40;
				yourself);
		at: 'Cyril'
			put:
			(Dictionary new
				at: 'Eating' put: 80;
				at: 'Drinking' put: 100;
				at: 'Sleeping' put: 70;
				at: 'Designing' put: 50;
				at: 'Coding' put: 40;
				at: 'Cycling' put: 10;
				at: 'Running' put: 25;
				yourself);
		yourself
]

{ #category : #'sample data' }
ChartSampleData class >> dataEntries [
	| coll |
	coll := OrderedCollection new.
	self dataDictionary
		keysAndValuesDo: [ :eachName :eachDict | 
			eachDict
				keysAndValuesDo: [ :eachActivity :eachValue | 
					coll
						add:
							(ChartSampleDataEntry new
								name: eachName;
								activity: eachActivity;
								amount: eachValue;
								yourself) ] ].
	^ coll
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
	^ (self dataDictionary at: self dataDictionary keys first) keys
]

{ #category : #'sample data' }
ChartSampleData class >> names [
	^ self dataDictionary keys sort
]
