"
I am the abstract superclass for all chart.js plugins file libraries

Subclasses add the js, css content for the plugin to run
"
Class {
	#name : #ChartJsPluginLibrary,
	#superclass : #WAFileMetadataLibrary,
	#category : #'ChartJs-Library-Plugins'
}

{ #category : #private }
ChartJsPluginLibrary >> github [
	^ self subclassResponsibility
]

{ #category : #private }
ChartJsPluginLibrary >> version [
	^ self subclassResponsibility
]
