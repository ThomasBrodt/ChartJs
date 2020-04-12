"
ChartBubbleDemo shows an example of the scatter plot chart type of chart.js
"
Class {
	#name : #ChartScatterDemo,
	#superclass : #ChartTypeDemo,
	#category : #'ChartJs-Demo'
}

{ #category : #accessing }
ChartScatterDemo class >> description [
	^ 'Show a scatter graph of all points'
]

{ #category : #accessing }
ChartScatterDemo class >> title [
	^ '- Scatter'
]

{ #category : #rendering }
ChartScatterDemo >> renderChartJsComponentOn: html [
	| chartData chartOptions |
	chartData := Chart2dData pointDataSets: ChartSampleData bubbleData.
	chartData chartType: ChartScatter.
	chartOptions := ChartOptions new
		legendDisplay: true;
		legendPosition: #right.
	chartOptions xAxis
		scaleLabelLabelString: 'Percentage';
		gridLinesDisplay: false;
		scaleLabelDisplay: true.
	chartOptions yAxis
		ticksBeginAtZero: true;
		scaleLabelDisplay: true;
		gridLinesDisplay: false.
	html div
		with: [ html chartJsChart
				data: chartData;
				options: chartOptions;
				callback: [ :value :label | value -> label ] ]
]
