"
ChartDataTriplet is a sample data structure with x, y and z as part of the three rgb values from a Color
"
Class {
	#name : #ChartSampleDataTriplet,
	#superclass : #Object,
	#instVars : [
		'x',
		'y',
		'z'
	],
	#category : #'ChartJs-Demo'
}

{ #category : #'instance creation' }
ChartSampleDataTriplet class >> fromColor: aColor [
	^ self
		x: (aColor red * 255) floor
		y: (aColor green * 255) floor
		z: (aColor blue * 255) floor
]

{ #category : #'instance creation' }
ChartSampleDataTriplet class >> x: xArg y: yArg z: zArg [
	^ self new
		x: xArg;
		y: yArg;
		z: zArg;
		yourself
]

{ #category : #converting }
ChartSampleDataTriplet >> neoJsonOn: writer [
	writer
		writeMapStreamingDo: [ :mapWriter | 
			mapWriter writeKey: #x value: x.
			mapWriter writeKey: #y value: y.
			mapWriter writeKey: #z value: z]
]

{ #category : #'accessing structure variables' }
ChartSampleDataTriplet >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		print: x;
		nextPut: $;;
		print: y;
		nextPut: $;;
		print: z;
		nextPut: $)
]

{ #category : #'accessing structure variables' }
ChartSampleDataTriplet >> x [
	^ x
]

{ #category : #'accessing structure variables' }
ChartSampleDataTriplet >> x: xArg [
	x := xArg
]

{ #category : #'accessing structure variables' }
ChartSampleDataTriplet >> y [
	^ y
]

{ #category : #'accessing structure variables' }
ChartSampleDataTriplet >> y: yArg [
	y := yArg
]

{ #category : #'accessing structure variables' }
ChartSampleDataTriplet >> z [
	^ z
]

{ #category : #'accessing structure variables' }
ChartSampleDataTriplet >> z: zArg [
	z := zArg
]
