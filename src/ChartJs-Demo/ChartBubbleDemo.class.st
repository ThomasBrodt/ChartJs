"
ChartBubbleDemo shows an example of the bubble chart type of chart.js
"
Class {
	#name : #ChartBubbleDemo,
	#superclass : #ChartTypeDemo,
	#category : #'ChartJs-Demo'
}

{ #category : #accessing }
ChartBubbleDemo class >> description [
	^ 'Bubble chart implementation for ChartJs for Seaside.'
]

{ #category : #accessing }
ChartBubbleDemo class >> title [
	^ '- Bubble chart'
]

{ #category : #rendering }
ChartBubbleDemo >> renderChartJsComponentOn: html [
	| chartData chartOptions |
	chartData := Chart2dData pointDataSets: ChartSampleData bubbleData.
	chartData chartType: ChartBubble.
	chartOptions := ChartOptions new.
	chartOptions
		elementsAt: #point
		put: ( Dictionary newFromPairs: { #radius . (ChartJsCodeFragment bubbleChartRadiusFunction: 0.0002) } ).
	html div
		with: [ html chartJsChart
				maxHeight: '200px';
				maxWidth: '500px';
				data: chartData;
				options: chartOptions;
				callback: [ :value :label | value -> label ] ]
]
