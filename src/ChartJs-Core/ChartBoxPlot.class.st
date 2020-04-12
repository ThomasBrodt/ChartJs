"
I represent a chart box plot, I require ChartBoxPlotData in my datasets
"
Class {
	#name : #ChartBoxPlot,
	#superclass : #ChartType,
	#category : #'ChartJs-Core-Types'
}

{ #category : #accessing }
ChartBoxPlot class >> dataFunction [
	^ 'bars'
]

{ #category : #accessing }
ChartBoxPlot class >> eventsCode [
	^ 'getBarsAtEvent(evt)'
]

{ #category : #testing }
ChartBoxPlot class >> isMultiDataSet [
	^ true
]

{ #category : #accessing }
ChartBoxPlot class >> styleSheetKeys [
	^ #()
]

{ #category : #accessing }
ChartBoxPlot class >> typeName [
	
	^ 'boxplot'
]
