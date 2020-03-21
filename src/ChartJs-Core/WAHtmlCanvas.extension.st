Extension { #name : #WAHtmlCanvas }

{ #category : #'*ChartJs-Core' }
WAHtmlCanvas >> chartJsChart [
	^ self brush: ChartJsChartBrush new
]
