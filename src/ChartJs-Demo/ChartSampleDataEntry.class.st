"
A simple Object representing data for the chart.js demos
 
    Instance Variables
	name:			<String> the name who is doing something 
	activity:		<String> the kind of activity that is done
	amount:		<Object> the amount of time spent for the activity
"
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
