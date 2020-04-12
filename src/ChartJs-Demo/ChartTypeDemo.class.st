"
ChartType demo is an abstract class for the demo classes that show a single chart type in detail
"
Class {
	#name : #ChartTypeDemo,
	#superclass : #ChartAbstractDemo,
	#category : #'ChartJs-Demo'
}

{ #category : #testing }
ChartTypeDemo class >> isAbstract [
	^ self = ChartTypeDemo
]
