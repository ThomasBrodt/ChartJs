"
ChartDatalabelsDemo shows the usage of the datalabels plugin to add labels to chart.js charts
"
Class {
	#name : #ChartDatalabelsDemo,
	#superclass : #ChartAbstractDemo,
	#category : #'ChartJs-Demo'
}

{ #category : #accessing }
ChartDatalabelsDemo class >> description [
	^ 'Customize labels shown on data segments'
]

{ #category : #accessing }
ChartDatalabelsDemo class >> title [
	^ 'Datalabels'
]

{ #category : #rendering }
ChartDatalabelsDemo >> renderChartJsComponentOn: html [

	html heading
		level: 3;
		with: ['to be done']
]

{ #category : #updating }
ChartDatalabelsDemo >> updateRoot: html [
	super updateRoot: html.
	ChartJsPluginDatalabelsLibrary default updateRoot: html
]
