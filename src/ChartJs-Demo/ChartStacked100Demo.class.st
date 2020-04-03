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
	| chartData chartOptions |
	chartData := Chart2dData new chartType: ChartHorizontalBar.
	chartData xObjects: ChartSampleData names.
	ChartSampleData labels
		doWithIndex: [ :each :index | 
			chartData
				addDataSet:
					((ChartDataSetSequence name: each sequence: (ChartSampleData dataByLabels at: each))
						stack: 'key';
						yourself) ].
	chartData keyDisplayBlock: [ :key | key].
	chartOptions := ChartOptions new
		legendDisplay: true;
		legendPosition: #right.
	chartOptions xAxis
		at: #maxBarThickness put: 150;
		scaleLabelLabelString: 'Percentage';
		gridLinesDisplay: false;
		scaleLabelDisplay: true.
	chartOptions yAxis
		ticksBeginAtZero: true;
		scaleLabelDisplay: true;
		gridLinesDisplay: false.
	chartOptions xAxis at: #stacked put: true.
	chartOptions yAxis at: #stacked put: true.
	chartOptions pluginsAt: #datalabels at: #display put: true.
	chartOptions pluginsAt: #stacked100 at: #enable put: true.
	chartOptions
				pluginsAt: #datalabels
				at: #formatter
				put: ChartJsCodeFragment stacked100Datalabel.
	html div
		with: [ html chartJsChart
				data: chartData;
				options: chartOptions;
				callback: [ :value :label | value -> label ] ]
]

{ #category : #updating }
ChartStacked100Demo >> updateRoot: html [
	super updateRoot: html.
	ChartJsPluginStacked100Library default updateRoot: html
]
