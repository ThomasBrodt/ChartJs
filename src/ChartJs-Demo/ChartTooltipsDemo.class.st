Class {
	#name : #ChartTooltipsDemo,
	#superclass : #ChartAbstractDemo,
	#category : #'ChartJs-Demo'
}

{ #category : #accessing }
ChartTooltipsDemo class >> description [
	^ 'It is possible to tooltips in the charts.'
]

{ #category : #accessing }
ChartTooltipsDemo class >> title [
	^ 'Tooltips'
]

{ #category : #rendering }
ChartTooltipsDemo >> renderChartJsComponentOn: html [
		| chartData chartData2 |
	chartData := (Chart2dData xObjects: #('Eating' 'Drinking' 'Sleeping' 'Designing' 'Coding' 'Cycling' 'Running')
		yObjects: #(80 100 70 50 40 10 25))
		title: [ :datas | 'Priority of actions' ];
		singleValueTooltip: '<key> has an importance of <value>%';
		chartType: ChartDoughnut;
		yourself.
	chartData styleSheets: (chartData xObjects collect: [:e | ChartStyleSheet chartDataSetDefault]).
	html render: (ChartJsComponent data: chartData).
	
	chartData2 := (Chart2dData
		xObjects: {'Eating' . 'Drinking' . 'Sleeping' . 'Designing' . 'Coding' . 'Cycling' . 'Running'}
		multiYObjects: {('Guillaume' -> {65 . 59 . 90 . 81 . 56 . 55 . 40}). ('Cyril' -> {28 . 48 . 40 . 19 . 96 . 27 . 100})})
		title: [ :sets | 'Spent time for ' , (sets collect: #name) asCommaStringAnd ];
		multiValueTooltip: '<label> spent <value> min in <key>';
		chartType: ChartBar;
		yourself.
	html render: (ChartJsComponent data: chartData2)
]
