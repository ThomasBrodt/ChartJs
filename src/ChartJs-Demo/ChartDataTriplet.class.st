"
ChartDataTriplet is a sample data structure with x, y and z as part of the three rgb values from a Color
"
Class {
	#name : #ChartDataTriplet,
	#superclass : #Object,
	#classVars : [
		'x',
		'y',
		'z'
	],
	#category : #'ChartJs-Demo'
}

{ #category : #'instance creation' }
ChartDataTriplet class >> fromColor: aColor [
	^ self
		x: aColor red * 255
		y: aColor green * 255
		z: aColor blue * 255
]

{ #category : #'instance creation' }
ChartDataTriplet class >> x: xArg y: yArg z: zArg [
	^ self new
		x: xArg;
		y: yArg;
		z: zArg;
		yourself
]

{ #category : #converting }
ChartDataTriplet >> neoJsonOn: writer [
	writer
		writeMapStreamingDo: [ :mapWriter | 
			mapWriter writeKey: #x value: x.
			mapWriter writeKey: #y value: y.
			mapWriter writeKey: #z value: z]
]

{ #category : #'accessing structure variables' }
ChartDataTriplet >> x [
	^ x
]

{ #category : #'accessing structure variables' }
ChartDataTriplet >> x: xArg [
	x := xArg
]

{ #category : #'accessing structure variables' }
ChartDataTriplet >> y [
	^ y
]

{ #category : #'accessing structure variables' }
ChartDataTriplet >> y: yArg [
	y := yArg
]

{ #category : #'accessing structure variables' }
ChartDataTriplet >> z [
	^ z
]

{ #category : #'accessing structure variables' }
ChartDataTriplet >> z: zArg [
	z := zArg
]
