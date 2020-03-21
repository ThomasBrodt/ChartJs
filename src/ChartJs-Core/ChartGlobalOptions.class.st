"
I represent global options for chartJs

	
"
Class {
	#name : #ChartGlobalOptions,
	#superclass : #ChartOptions,
	#category : #'ChartJs-Core-Model'
}

{ #category : #converting }
ChartGlobalOptions >> asScript [
	^ String streamContents: [:str | self putRoot: dictionary on: str]
]

{ #category : #accessing }
ChartGlobalOptions >> at: aKey [
	^ self at: aKey ifAbsentPut: [ChartOptions new]
]

{ #category : #private }
ChartGlobalOptions >> put: aValue key: aKey on: aStream [
	
	aValue isDictionary
		ifTrue: [
			self
				putDictionary: aValue
				key: aKey
				on: aStream]
		ifFalse: [
			(aValue isKindOf: ChartOptions)
				ifTrue: [
					self
						putOptions: aValue
						key: aKey
						on: aStream]
				ifFalse: [
					self
						putValue: aValue
						key: aKey
						on: aStream]]
]

{ #category : #private }
ChartGlobalOptions >> putDictionary: aDict key: aKey on: aStream [
	
	^ aDict
		keysAndValuesDo: [:key :value |
			| compositeKey |
			compositeKey := aKey , '.' , key.
			value isDictionary
				ifTrue: [
					self
						putDictionary: value
						key: compositeKey
						on: aStream]
				ifFalse: [
					self
						putValue: value
						key: compositeKey
						on: aStream]]
]

{ #category : #private }
ChartGlobalOptions >> putOptions: anOptions key: aKey on: aStream [

	anOptions
		keysAndValuesDo: [:key :value |
			| compositeKey |
			compositeKey := aKey , '.' , key.
			value isDictionary
				ifTrue: [
					self
						putDictionary: value
						key: compositeKey
						on: aStream]
				ifFalse: [
					self
						putValue: value
						key: compositeKey
						on: aStream]]
]

{ #category : #private }
ChartGlobalOptions >> putRoot: aDictionary on: aStream [
	
	aDictionary
		keysAndValuesDo: [:eachKey :eachValue |
			(eachValue isKindOf: ChartOptions)
				ifTrue: [
					self
						putOptions: eachValue
						key: 'Chart.defaults.' , eachKey
						on: aStream]
				ifFalse: [
					self
						put: eachValue
						key: 'Chart.defaults.global.' , eachKey
						on: aStream]]
]

{ #category : #private }
ChartGlobalOptions >> putValue: aValue key: aKey on: aStream [
	
	aStream
		nextPutAll: aKey;
		nextPutAll: ' = '.
	(NeoJSONWriter on: aStream) nextPut: aValue.
	aStream 
		nextPutAll: ';';
		cr
]
