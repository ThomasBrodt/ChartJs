"
ChartDoughnutDemo shows an example of the doughnut chart type of chart.js
"
Class {
	#name : #ChartDoughnutDemo,
	#superclass : #ChartTypeDemo,
	#category : #'ChartJs-Demo'
}

{ #category : #accessing }
ChartDoughnutDemo class >> description [
	^ 'Show data in the form of a doughnut.'
]

{ #category : #accessing }
ChartDoughnutDemo class >> title [
	^ '- Doughnut'
]

{ #category : #rendering }
ChartDoughnutDemo >> renderChartJsComponentOn: html [
	| chartData chartOptions |
	chartData := Chart2dData new chartType: ChartDoughnut.
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
