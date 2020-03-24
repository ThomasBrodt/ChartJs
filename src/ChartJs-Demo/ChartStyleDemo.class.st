Class {
	#name : #ChartStyleDemo,
	#superclass : #ChartAbstractDemo,
	#category : #'ChartJs-Demo'
}

{ #category : #accessing }
ChartStyleDemo class >> description [
	^ 'It is possible to customize the style of the chart.'
]

{ #category : #accessing }
ChartStyleDemo class >> title [
	^ 'Style'
]

{ #category : #rendering }
ChartStyleDemo >> renderChartJsComponentOn: html [
	| chartData styleForPersons |
	chartData := (Chart2dData
		xObjects: ChartSampleData labels
		multiYObjects:
			((Array new: 2)
				at: 1 put: ChartSampleData data1;
				at: 2 put: ChartSampleData data2 yourself))
		title: [:sets | 'Spent time for ' , (sets collect: #name) asCommaStringAnd];
		chartType: ChartLine;
		yourself.
	styleForPersons := Dictionary
		with:
			ChartSampleData data1 key
				->
					(Dictionary
						with: #pointColor -> Color green
						with: #borderColor -> Color green
						with: #backgroundColor -> Color green)
		with:
			ChartSampleData data2 key
				->
					(Dictionary
						with: #pointColor -> Color blue
						with: #borderColor -> Color blue
						with: #backgroundColor -> Color blue).
	chartData dataSets
		do: [:set |
			(set styleSheet)
				pointColor: [:keys :values :label | (styleForPersons at: label) at: #pointColor];
				borderColor: [:keys :values :label | (styleForPersons at: label) at: #borderColor];
				pointBorderColor: Color white;
				backgroundColor: [:keys :values :label | ((styleForPersons at: label) at: #backgroundColor) alpha: 0.3];
				pointHoverBackgroundColor: Color pink;
				pointHoverBorderColor: Color red].
	html render: (ChartJsComponent data: chartData)
]
