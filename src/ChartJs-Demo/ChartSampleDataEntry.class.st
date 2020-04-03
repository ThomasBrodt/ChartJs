Class {
	#name : #ChartSampleDataEntry,
	#superclass : #Object,
	#instVars : [
		'name',
		'activity',
		'amount'
	],
	#category : #'ChartJs-Demo'
}

{ #category : #accessing }
ChartSampleDataEntry >> activity [
	^ activity
]

{ #category : #accessing }
ChartSampleDataEntry >> activity: anObject [
	activity := anObject
]

{ #category : #accessing }
ChartSampleDataEntry >> amount [
	^ amount
]

{ #category : #accessing }
ChartSampleDataEntry >> amount: anObject [
	amount := anObject
]

{ #category : #accessing }
ChartSampleDataEntry >> name [
	^ name
]

{ #category : #accessing }
ChartSampleDataEntry >> name: anObject [
	name := anObject
]
