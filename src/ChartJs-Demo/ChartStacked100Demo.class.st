"
ChartStacked100Demo shows an example of the stacked100 plugin for the bar chart chart type of chart.js
"
Class {
	#name : #ChartStacked100Demo,
	#superclass : #ChartAbstractDemo,
	#category : #'ChartJs-Demo'
}

{ #category : #accessing }
ChartStacked100Demo class >> description [
	^ 'Show a variant of bars that are all the same size, better visualizing percentage of data'
]

{ #category : #accessing }
ChartStacked100Demo class >> title [
	^ 'Stacked100'
]

{ #category : #rendering }
ChartStacked100Demo >> renderChartJsComponentOn: html [

	html heading
		level: 3;
		with: ['to be done']
]
