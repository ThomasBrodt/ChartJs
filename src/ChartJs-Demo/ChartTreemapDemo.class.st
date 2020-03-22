"
ChartTreemapDemo shows an example of the treemap plugin chart type of chart.js
"
Class {
	#name : #ChartTreemapDemo,
	#superclass : #ChartAbstractDemo,
	#category : #'ChartJs-Demo'
}

{ #category : #accessing }
ChartTreemapDemo class >> description [
	^ 'Show data in the form of a treemap.'
]

{ #category : #accessing }
ChartTreemapDemo class >> title [
	^ 'Treemap'
]

{ #category : #rendering }
ChartTreemapDemo >> renderChartJsComponentOn: html [

	html heading
		level: 3;
		with: ['to be done']
]
