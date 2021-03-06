"
ChartBoxPlotDemo shows an example of the box plot chart type of chart.js
"
Class {
	#name : #ChartBoxPlotDemo,
	#superclass : #ChartTypeDemo,
	#category : #'ChartJs-Demo'
}

{ #category : #accessing }
ChartBoxPlotDemo class >> description [
	^ 'Boxplot implementation for ChartJs for Seaside.'
]

{ #category : #accessing }
ChartBoxPlotDemo class >> title [
	^ '- Box plot'
]

{ #category : #rendering }
ChartBoxPlotDemo >> renderChartJsComponentOn: html [
	| chartData chartData2 chartOptions |
	chartData := Chart2dData
		xObjects: #(Guillaume Cyril)
		function: [ :aPlayer | 
			ChartBoxPlotData
				lowest: 5 atRandom
				firstQuartile: (5 to: 10) atRandom
				median: (11 to: 15) atRandom
				thirdQuartile: (16 to: 20) atRandom
				highest: (21 to: 25) atRandom ].
	chartData chartType: ChartBoxPlot.
	chartOptions := ChartOptions new 
		responsive: true;
		legendPosition: 'top'.
	html div
		with: [ html chartJsChart
				maxHeight: '200px';
				maxWidth: '500px';
				data: chartData;
				options: chartOptions;
				callback: [ :value :label | value -> label ] ].
	
	chartData2 := Chart2dData
		xObjects: { Collection . Magnitude }
		function: [ :class | ChartBoxPlotData for: class allSubclasses using: [ :c | c methods size ] ].
	chartData2 chartType: ChartBoxPlot; keyDisplayBlock: #printString.
	html render: (ChartJsComponent data: chartData2)
]
