"
ChartPieDemo shows an example of the pie chart type of chart.js
"
Class {
	#name : #ChartPieDemo,
	#superclass : #ChartTypeDemo,
	#category : #'ChartJs-Demo'
}

{ #category : #accessing }
ChartPieDemo class >> description [
	^ 'Show data in the form of a pie.'
]

{ #category : #accessing }
ChartPieDemo class >> title [
	^ '- Pie'
]

{ #category : #rendering }
ChartPieDemo >> renderChartJsComponentOn: html [
	| chartData chartOptions |
	chartData := Chart2dData new chartType: ChartPie.
	chartData xObjects: ChartSampleData labels.
	chartData dataSets: ChartSampleData dataSets.
	chartData
		styleSheets:
			(ChartSampleData labels
				collect: [ :e | ChartStyleSheet chartDataSetDefault ]).
	chartOptions := ChartOptions new
		legendDisplay: true;
		legendPosition: #right.
	html div
		with: [ html chartJsChart
				maxHeight: '200px';
				maxWidth: '500px';
				data: chartData;
				options: chartOptions;
				callback: [ :value :label | value -> label ] ]
]
