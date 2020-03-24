"
I represent a bar chart
"
Class {
	#name : #ChartBar,
	#superclass : #ChartType,
	#category : #'ChartJs-Core-Types'
}

{ #category : #accessing }
ChartBar class >> dataFunction [
	^ 'bars'
]

{ #category : #accessing }
ChartBar class >> eventsCode [
	^ 'getBarsAtEvent(evt)'
]

{ #category : #testing }
ChartBar class >> isMultiDataSet [
	^ true
]

{ #category : #accessing }
ChartBar class >> optionKeys [
	^ #(#datalabels)
]

{ #category : #accessing }
ChartBar class >> styleSheetKeys [
	^ #(#backgroundColor #borderColor #hoverBackgroundColor #hoverBorderColor #fill #borderWidth)
]

{ #category : #accessing }
ChartBar class >> typeName [
	^ 'bar'
]
