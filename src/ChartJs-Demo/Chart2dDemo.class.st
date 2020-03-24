Class {
	#name : #Chart2dDemo,
	#superclass : #ChartAbstractChartTypeDemo,
	#category : #'ChartJs-Demo'
}

{ #category : #accessing }
Chart2dDemo class >> description [
	^ 'Demo about two dimensions charts with ChartJs for Seaside.'
]

{ #category : #accessing }
Chart2dDemo class >> title [
	^ '2D demo'
]

{ #category : #accessing }
Chart2dDemo >> kinds [
	^ {
		ChartPie.
		ChartDoughnut.
		ChartPolar.
		ChartBar.
		ChartHorizontalBar.
		ChartLine.
		ChartRadar.
		ChartBubble.
		ChartScatter
		}
]

{ #category : #rendering }
Chart2dDemo >> renderChartJsComponentOn: html [
	| renderingChartBlock id |
	
	renderingChartBlock := [ :canvas | 
	| chartOptions chartData |
	chartOptions := ChartOptions new.
	self kind = ChartBubble
		ifTrue: [
			chartData := Chart2dData pointDataSets: ChartSampleData bubbleData.
			chartOptions
				elementsAt: #point
				put:
					((Dictionary new)
						at: #radius put: (ChartJsCodeFragment bubbleChartRadiusFunction: 0.0002s);
						yourself)]
		ifFalse: [
			self kind = ChartScatter
				ifTrue: [chartData := Chart2dData pointDataSets: ChartSampleData bubbleData]
				ifFalse: [
					chartData := Chart2dData xObjects: ChartSampleData labels multiYObjects: ChartSampleData data.
					chartData styleSheets: (ChartSampleData labels collect: [:e | ChartStyleSheet chartDataSetDefault])]].
	chartData
		title: [:sets | 'Spent time for ' , (sets collect: #name) asCommaStringAnd];
		multiValueTooltip: '<label> spent <value> min in <key>';
		chartType: self kind;
		yourself.
	selection
		ifNotNil: [ canvas heading
				level: 3;
				with: 'Selected value: ' , selection key asString , ' label: ' , selection value ].
	html render: (ChartJsComponent data: chartData options: chartOptions callback: [ :value :label | selection := value -> label ]) ].

	id := html nextId.
	self renderPossibleKindsUpdating: id with: renderingChartBlock on: html.
	self renderDemoWithId: id with: renderingChartBlock on: html
]
