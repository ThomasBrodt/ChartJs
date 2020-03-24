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
ChartJsPluginLibrary class >> asSelector: aFilename [
	"ChartJsLibrary asSelector: 'Chart.min.js' "
	
	| mainPart extension theStream theFlag |
	mainPart := aFilename copyUpToLast: $..
	[mainPart first isDigit] whileTrue: [mainPart := mainPart allButFirst].
	extension := (aFilename copyAfterLast: $.) asLowercase capitalized.

	theStream := (String new: mainPart size) writeStream.
	theFlag := false.
	mainPart
		do: [:char |
			char isAlphaNumeric
				ifTrue: [
					theStream
						nextPut:
							(theFlag
								ifTrue: [char asUppercase]
								ifFalse: [char asLowercase]).
					theFlag := false]
				ifFalse: [
					('/\.-' includes: char)
						ifTrue: [theFlag := true]]].

	^ (theStream contents , extension) asSymbol
]

{ #category : #private }
ChartJsPluginLibrary >> github [
	^ self subclassResponsibility
]

{ #category : #private }
ChartJsPluginLibrary >> version [
	^ self subclassResponsibility
]
