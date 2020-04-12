"
I am the styleSheet for a Chart
"
Class {
	#name : #ChartStyleSheet,
	#superclass : #StyleSheet,
	#category : #'ChartJs-Core-Style'
}

{ #category : #'instance creation' }
ChartStyleSheet class >> backgroundColor: aColor [
	^ self 
		backgroundColor: aColor 
		borderColor: self defaultBorderColor
]

{ #category : #'instance creation' }
ChartStyleSheet class >> backgroundColor: aColor borderColor: aBorderColor [
	^ (self new)
		globalSetColor: aColor borderColor: aBorderColor;
		yourself
]

{ #category : #'instance creation' }
ChartStyleSheet class >> borderedColor: aColor [
	^ self borderedColor: aColor width: self defaultBorderWidth
]

{ #category : #'instance creation' }
ChartStyleSheet class >> borderedColor: aColor backgroundAlpha: anAlphaValue [ 
	^ self 
		borderedColor: aColor 
		width: self defaultBorderWidth
		backgroundAlpha: anAlphaValue
]

{ #category : #'instance creation' }
ChartStyleSheet class >> borderedColor: aColor backgroundBlendWith: aBlendColor weight: aWeight [
	^ self 
		borderedColor: aColor 
		width: self defaultBorderWidth
		backgroundBlendWith: aBlendColor 
		weight: aWeight
]

{ #category : #'instance creation' }
ChartStyleSheet class >> borderedColor: aColor width: aWidth [
	^ (self new)
		globalSetColor: aColor backgroundBlendWith: self defaultBackgroundBlendColor weight: self defaultBackgroundWeight;
		borderWidth: aWidth;
		fill: false;
		yourself
]

{ #category : #'instance creation' }
ChartStyleSheet class >> borderedColor: aColor width: aWidth backgroundAlpha: anAlphaValue [ 
	^ (self new)
		globalSetColor: aColor backgroundAlpha: anAlphaValue;
		borderWidth: aWidth;
		fill: false;
		yourself
]

{ #category : #'instance creation' }
ChartStyleSheet class >> borderedColor: aColor width: aWidth backgroundBlendWith: aBlendColor weight: aWeight [
	^ (self new)
		globalSetColor: aColor backgroundBlendWith: aBlendColor weight: aWeight;
		borderWidth: aWidth;
		fill: false;
		yourself
]

{ #category : #'instance creation' }
ChartStyleSheet class >> borderedRandom [
	^ (self new)
		globalSetColor: Color random backgroundBlendWith: self defaultBackgroundBlendColor weight: self defaultBackgroundWeight;
		yourself
]

{ #category : #'instance creation' }
ChartStyleSheet class >> charDataSetDefault [
	^ self new
		globalSetColor: Color random;
		yourself
]

{ #category : #'instance creation' }
ChartStyleSheet class >> chartDataSetDefault [
	^ self borderedColor: Color random
]

{ #category : #'instance creation' }
ChartStyleSheet class >> color: aColor [
	^ (self new)
		globalSetColor: aColor;
		yourself
]

{ #category : #'instance creation' }
ChartStyleSheet class >> default [
	^ self new
		chartType: ChartBar;
		yourself
]

{ #category : #defaults }
ChartStyleSheet class >> defaultBackgroundBlendColor [

	^ Color white
]

{ #category : #defaults }
ChartStyleSheet class >> defaultBackgroundWeight [

	^ 0.7
]

{ #category : #defaults }
ChartStyleSheet class >> defaultBorderColor [

	^ Color white
]

{ #category : #defaults }
ChartStyleSheet class >> defaultBorderWidth [

	^ 2
]

{ #category : #'instance creation' }
ChartStyleSheet class >> random [
	^ (self new)
		globalSetColor: Color random;
		yourself
]

{ #category : #'instance creation' }
ChartStyleSheet class >> solidColor: aColor [
	^ self 
		solidColor: aColor 
		borderColor: self defaultBorderColor
]

{ #category : #'instance creation' }
ChartStyleSheet class >> solidColor: aColor borderColor: aBorderColor [
	^ (self new)
		globalSetColor: aColor borderColor: aBorderColor;
		yourself
]

{ #category : #'instance creation' }
ChartStyleSheet class >> solidRandom [
	^ (self new)
		globalSetColor: Color random;
		yourself
]

{ #category : #colors }
ChartStyleSheet >> backgroundColor [
	^ self get: #backgroundColor
]

{ #category : #colors }
ChartStyleSheet >> backgroundColor: aColor [
	^ self at: #backgroundColor put: aColor
]

{ #category : #colors }
ChartStyleSheet >> borderColor [
	^ self get: #borderColor
]

{ #category : #colors }
ChartStyleSheet >> borderColor: aColor [
	^ self at: #borderColor put: aColor
]

{ #category : #colors }
ChartStyleSheet >> borderDash [
	^ self get: #borderDash
]

{ #category : #colors }
ChartStyleSheet >> borderDash: anArray [
	^ self at: #borderDash put: anArray
]

{ #category : #colors }
ChartStyleSheet >> borderWidth [
	^ self get: #borderWidth
]

{ #category : #colors }
ChartStyleSheet >> borderWidth: aNumber [
	^ self at: #borderWidth put: aNumber
]

{ #category : #'chart type' }
ChartStyleSheet >> chartType [
	^ self get: #chartType
]

{ #category : #'chart type' }
ChartStyleSheet >> chartType: aChartType [
	self at: #chartType put: aChartType
]

{ #category : #points }
ChartStyleSheet >> fill [
	^ self get: #fill
							

]

{ #category : #points }
ChartStyleSheet >> fill: aBoolean [
	^ self at: #fill put: aBoolean
]

{ #category : #'backward compatibility' }
ChartStyleSheet >> fillColor [
	^ self get: #fillColor
]

{ #category : #'backward compatibility' }
ChartStyleSheet >> fillColor: aColor [
	^ self at: #fillColor put: aColor
]

{ #category : #private }
ChartStyleSheet >> get: anAttribute [
	^ attributes at: anAttribute ifAbsent: []
]

{ #category : #private }
ChartStyleSheet >> get: anAttribute ifAbsent: aBlock [
	^ attributes at: anAttribute ifAbsent: aBlock
]

{ #category : #private }
ChartStyleSheet >> get: anAttribute ifPresent: aBlock [
	^ attributes at: anAttribute ifPresent: aBlock
]

{ #category : #private }
ChartStyleSheet >> get: anAttribute ifPresent: aBlock ifAbsent: anAbsentBlock [
	^ attributes at: anAttribute ifPresent: aBlock ifAbsent: anAbsentBlock
]

{ #category : #helpers }
ChartStyleSheet >> globalSetBorderedColor: aColor [
	self globalSetColor: aColor backgroundBlendWith: self class defaultBackgroundBlendColor weight: self class defaultBackgroundWeight.
	self fill: false.
	self borderWidth: self class defaultBorderWidth
]

{ #category : #helpers }
ChartStyleSheet >> globalSetColor: aColor [
	"self backgroundColor: (aColor copy alpha: 0.2)." "no direct alpha support in ColorValue, so help out with whitening"
	self backgroundColor: (aColor blendWith: Color white weight: 0.7).

	self borderColor: aColor.
	self hoverBorderColor: aColor.
	self hoverBackgroundColor: aColor.

	self pointColor: aColor.
	self pointHoverBackgroundColor: Color white.
	self pointHoverBorderColor: aColor.
	self pointBorderColor: Color white
]

{ #category : #helpers }
ChartStyleSheet >> globalSetColor: aColor backgroundAlpha: anAlphaValue [

	self backgroundColor: (aColor copy alpha: anAlphaValue).

	self borderColor: aColor.
	self hoverBorderColor: aColor.
	self hoverBackgroundColor: aColor.

	self pointColor: aColor.
	self pointHoverBackgroundColor: Color white.
	self pointHoverBorderColor: aColor.
	self pointBorderColor: Color white
]

{ #category : #helpers }
ChartStyleSheet >> globalSetColor: aColor backgroundBlendWith: aBlendColor weight: aWeight [

	self backgroundColor: (aColor blendWith: aBlendColor weight: aWeight).

	self borderColor: aColor.
	self hoverBorderColor: aColor.
	self hoverBackgroundColor: aColor.

	self pointColor: aColor.
	self pointHoverBackgroundColor: Color white.
	self pointHoverBorderColor: aColor.
	self pointBorderColor: Color white
]

{ #category : #helpers }
ChartStyleSheet >> globalSetColor: aColor borderColor: aBorderColor [

	self backgroundColor: aColor.

	self borderColor: aBorderColor.
	self hoverBorderColor: aBorderColor.
	self hoverBackgroundColor: aColor.

	self pointColor: aColor.
	self pointHoverBackgroundColor: aColor.
	self pointHoverBorderColor: aBorderColor.
	self pointBorderColor: aBorderColor
]

{ #category : #helpers }
ChartStyleSheet >> globalSetColorZone: aColor [
	self backgroundColor: (aColor copy alpha: 0.8).
	self borderColor: aColor
]

{ #category : #colors }
ChartStyleSheet >> hoverBackgroundColor [
	^ self get: #hoverBackgroundColor
]

{ #category : #colors }
ChartStyleSheet >> hoverBackgroundColor: aColor [
	^ self at: #hoverBackgroundColor put: aColor
]

{ #category : #colors }
ChartStyleSheet >> hoverBorderColor [
	^ self get: #hoverBorderColor
]

{ #category : #colors }
ChartStyleSheet >> hoverBorderColor: aColor [
	^ self at: #hoverBorderColor put: aColor
]

{ #category : #colors }
ChartStyleSheet >> lineTension [
	^ self get: #lineTension
]

{ #category : #colors }
ChartStyleSheet >> lineTension: aValue [
	^ self at: #lineTension put: aValue
]

{ #category : #scale }
ChartStyleSheet >> logarithmicScale [
	self at: #scale put: #logarithmic
]

{ #category : #private }
ChartStyleSheet >> obtainValue: aPropertyOrValuable forKeys: aCollectionOfXObjects andValues: values [
	| result |
	result := aPropertyOrValuable cull: self.
	^ (result isBlock or: [ result isSymbol ])
		ifTrue: [ result cull: aCollectionOfXObjects cull: values ]
		ifFalse: [ result ]
]

{ #category : #private }
ChartStyleSheet >> obtainValue: aPropertyOrValuable forKeys: aCollectionOfXObjects andValues: values andLabel: aLabel [

	| result |
	result := aPropertyOrValuable cull: self.
	^ (result isBlock or: [result isSymbol])
		ifTrue: [
			result
				cull: aCollectionOfXObjects
				cull: values
				cull: aLabel]
		ifFalse: [result]
]

{ #category : #points }
ChartStyleSheet >> pointBackgroundColor [
	^ self get: #pointBackgroundColor
]

{ #category : #points }
ChartStyleSheet >> pointBackgroundColor: aColor [
	^ self at: #pointBackgroundColor put: aColor
]

{ #category : #points }
ChartStyleSheet >> pointBorderColor [
	^ self get: #pointBorderColor
]

{ #category : #points }
ChartStyleSheet >> pointBorderColor: aColor [
	^ self at: #pointBorderColor put: aColor
]

{ #category : #points }
ChartStyleSheet >> pointBorderWidth [
	^ self get: #pointBorderWidth
]

{ #category : #points }
ChartStyleSheet >> pointBorderWidth: aColor [
	^ self at: #pointBorderWidth put: aColor
]

{ #category : #points }
ChartStyleSheet >> pointColor [
	^ self get: #pointColor
]

{ #category : #points }
ChartStyleSheet >> pointColor: aColor [
	^ self at: #pointColor put: aColor
]

{ #category : #points }
ChartStyleSheet >> pointHighlightFill [
	^ self pointHoverBackgroundColor
]

{ #category : #points }
ChartStyleSheet >> pointHighlightFill: aColor [
	^ self pointHoverBackgroundColor: aColor
]

{ #category : #'backward compatibility' }
ChartStyleSheet >> pointHighlightStroke [
	^ self get: #pointHighlightStroke
]

{ #category : #'backward compatibility' }
ChartStyleSheet >> pointHighlightStroke: aColor [
	^ self at: #pointHighlightStroke put: aColor
]

{ #category : #points }
ChartStyleSheet >> pointHitRadius [
	^ self get: #pointHitRadius
]

{ #category : #points }
ChartStyleSheet >> pointHitRadius: aValue [
	^ self at: #pointHitRadius put: aValue
]

{ #category : #points }
ChartStyleSheet >> pointHoverBackgroundColor [
	^ self get: #pointHoverBackgroundColor
]

{ #category : #points }
ChartStyleSheet >> pointHoverBackgroundColor: aColor [
	^ self at: #pointHoverBackgroundColor put: aColor
]

{ #category : #points }
ChartStyleSheet >> pointHoverBorderColor [
	^ self get: #pointHoverBorderColor
]

{ #category : #points }
ChartStyleSheet >> pointHoverBorderColor: aColor [
	^ self at: #pointHoverBorderColor put: aColor
]

{ #category : #points }
ChartStyleSheet >> pointHoverBorderWidth [
	^ self get: #pointHoverBorderWidth
]

{ #category : #points }
ChartStyleSheet >> pointHoverBorderWidth: aValue [
	^ self at: #pointHoverBorderWidth put: aValue
]

{ #category : #points }
ChartStyleSheet >> pointHoverRadius [
	^ self get: #pointHoverRadius
]

{ #category : #points }
ChartStyleSheet >> pointHoverRadius: aValue [
	^ self at: #pointHoverRadius put: aValue
]

{ #category : #points }
ChartStyleSheet >> pointRadius [
	^ self get: #pointRadius
]

{ #category : #points }
ChartStyleSheet >> pointRadius: aValue [
	^ self at: #pointRadius put: aValue
]

{ #category : #'backward compatibility' }
ChartStyleSheet >> pointStrokeColor [
	^ self get: #pointStrokeColor
]

{ #category : #'backward compatibility' }
ChartStyleSheet >> pointStrokeColor: aColor [
	^ self at: #pointStrokeColor put: aColor
]

{ #category : #points }
ChartStyleSheet >> pointStyle [
	^ self get: #pointStyle
]

{ #category : #points }
ChartStyleSheet >> pointStyle: aValue [
	^ self at: #pointStyle put: aValue
]

{ #category : #scale }
ChartStyleSheet >> scale [
	self get: #scale
]

{ #category : #colors }
ChartStyleSheet >> showLine [
	^ self get: #showLine
]

{ #category : #colors }
ChartStyleSheet >> steppedLine [
	^ self get: #steppedLine
]

{ #category : #colors }
ChartStyleSheet >> steppedLine: aValue [
	^ self at: #steppedLine put: aValue
]

{ #category : #'backward compatibility' }
ChartStyleSheet >> strokeColor [
	^ self get: #strokeColor
]

{ #category : #'backward compatibility' }
ChartStyleSheet >> strokeColor: aColor [
	^ self at: #strokeColor put: aColor
]
