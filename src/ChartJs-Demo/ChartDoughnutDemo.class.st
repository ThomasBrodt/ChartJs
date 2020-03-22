"
ChartDoughnutDemo shows an example of the doughnut chart type of chart.js
"
Class {
	#name : #ChartDoughnutDemo,
	#superclass : #ChartAbstractDemo,
	#category : #'ChartJs-Demo'
}

{ #category : #accessing }
ChartDoughnutDemo class >> description [
	^ 'Show data in the form of a doughnut.'
]

{ #category : #accessing }
ChartDoughnutDemo class >> title [
	^ 'Doughnut'
]

{ #category : #rendering }
ChartDoughnutDemo >> renderChartJsComponentOn: html [

	html heading
		level: 3;
		with: ['to be done']
]
