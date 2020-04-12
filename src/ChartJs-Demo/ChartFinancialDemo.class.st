"
updateRoot: html
	super updateRoot: html.
	ChartJsPluginFinancialLibrary default updateRoot: html
"
Class {
	#name : #ChartFinancialDemo,
	#superclass : #ChartTypeDemo,
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

{ #category : #updating }
ChartFinancialDemo >> updateRoot: html [
	super updateRoot: html.
	ChartJsPluginChartFinancialLibrary default updateRoot: html
]
