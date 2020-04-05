"
ChartFinancialDemo shows an example of the financial chart type of chart.js
"
Class {
	#name : #ChartFinancialDemo,
	#superclass : #ChartAbstractDemo,
	#category : #'ChartJs-Demo'
}

{ #category : #accessing }
ChartFinancialDemo class >> description [
	^ 'Show data in the form of a box plot or violin.'
]

{ #category : #accessing }
ChartFinancialDemo class >> title [
	^ '- Financial'
]

{ #category : #rendering }
ChartFinancialDemo >> renderChartJsComponentOn: html [

	html heading
		level: 3;
		with: ['to be done']
]
