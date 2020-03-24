Class {
	#name : #Chart2dMixedDemo,
	#superclass : #ChartAbstractChartTypeDemo,
	#category : #'ChartJs-Demo'
}

{ #category : #accessing }
Chart2dMixedDemo class >> description [
	^ 'Demo for mixed chart types in one chart with ChartJs for Seaside.'
]

{ #category : #accessing }
Chart2dMixedDemo class >> title [
	^ '2D mixed type demo'
]

{ #category : #accessing }
Chart2dMixedDemo >> kinds [
	^ (Array new: 3)
		at: 1 put: #ChartBarWithLine;
		at: 2 put: #ChartScatterWithLine;
		at: 3 put: #ChartBubbleWithLine;
		yourself
]

{ #category : #rendering }
Chart2dMixedDemo >> renderChartJsComponentOn: html [
	| renderingChartBlock id |
	renderingChartBlock := [:canvas |
	| chartData stylesheets |
	self kind = #ChartBarWithLine
		ifTrue: [
			chartData := (Chart2dData xObjects: ChartSampleData labels multiYObjects: ChartSampleData data)
				title: [:sets | 'Spent time for ' , (sets collect: #name) asCommaStringAnd];
				multiValueTooltip: '<label> spent <value> min in <key>';
				chartType: ChartBar;
				yourself.
			chartData dataSets first chartType: ChartLine.
			stylesheets := ChartSampleData labels collect: [:e | ChartStyleSheet chartDataSetDefault].
			chartData styleSheets: stylesheets]
		ifFalse: [
			chartData := (Chart2dData pointDataSets: ChartSampleData bubbleData)
				title: [:sets | 'Spent time for ' , (sets collect: #name) asCommaStringAnd];
				multiValueTooltip: '<label> spent <value> min in <key>';
				yourself.
			self kind = #ChartScatterWithLine
				ifTrue: [chartData chartType: ChartScatter]
				ifFalse: [chartData chartType: ChartBubble].
			chartData
				addDataSet:
					((ChartDataSetSequence name: 'Third dataset' sequence: ChartSampleData bubbleData3 value) chartType: ChartLine)].
	selection
		ifNotNil: [
			(canvas heading)
				level: 3;
				with: 'Selected value: ' , selection key asString , ' label: ' , selection value].
	html render: (ChartJsComponent data: chartData callback: [:value :label | selection := value -> label])].
	id := html nextId.
	self
		renderPossibleKindsUpdating: id
		with: renderingChartBlock
		on: html.
	self
		renderDemoWithId: id
		with: renderingChartBlock
		on: html
]

{ #category : #rendering }
Chart2dMixedDemo >> renderPossibleKindsUpdating: id with: renderingChartBlock on: html [
	html form
		style: 'display: flex; justify-content: space-around; margin-bottom: 20px;';
		with: [ html radioGroup
				selected: self kind;
				callback: [ :k | self kind: k ];
				with: [ :group | 
					self kinds
						do: [ :each | 
							html
								label: [ html radioButton
										group: group;
										value: each;
										onChange:
											(html jQuery ajax
												serializeThis;
												onComplete:
													((html jQuery id: id) load html: [ :r | renderingChartBlock value: r ])).
									html text: each ] ] ] ]
]
