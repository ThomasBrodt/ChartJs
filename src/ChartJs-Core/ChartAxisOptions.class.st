"
I am the options for an axis of the graph
"
Class {
	#name : #ChartAxisOptions,
	#superclass : #ChartAbstractOptions,
	#category : #'ChartJs-Core-Model'
}

{ #category : #accessing }
ChartAxisOptions >> barPercentage: aNumber [
	self at: #barPercentage put: aNumber
]

{ #category : #accessing }
ChartAxisOptions >> beginAtZero: aBoolean [
	self at: #beginAtZero put: aBoolean
]

{ #category : #accessing }
ChartAxisOptions >> categoryPercentage: aNumber [
	self at: #categoryPercentage put: aNumber
]

{ #category : #accessing }
ChartAxisOptions >> display [
	^ self at: #display
]

{ #category : #accessing }
ChartAxisOptions >> display: aBoolean [
	self at: #display put: aBoolean
]

{ #category : #accessing }
ChartAxisOptions >> fontSize [
	^ self at: #fontSize
]

{ #category : #accessing }
ChartAxisOptions >> fontSize: aSize [
	self at: #fontSize put: aSize
]

{ #category : #'accessing grid lines' }
ChartAxisOptions >> gridLines [
	^ self at: #gridLines
]

{ #category : #'accessing grid lines' }
ChartAxisOptions >> gridLinesAt: aKey put: aValue [
	(self at: #gridLines ifAbsentPut: [Dictionary new]) at: aKey put: aValue
]

{ #category : #'accessing grid lines' }
ChartAxisOptions >> gridLinesDisplay: aBoolean [
	self gridLinesAt: #display put: aBoolean
]

{ #category : #'accessing grid lines' }
ChartAxisOptions >> gridLinesDrawTicks: aBoolean [
	self gridLinesAt: #drawTicks put: aBoolean
]

{ #category : #'accessing grid lines' }
ChartAxisOptions >> gridLinesLineWidth: aNumber [
	self gridLinesAt:#lineWidth put: aNumber
]

{ #category : #accessing }
ChartAxisOptions >> id [
	^ self at: #id
]

{ #category : #accessing }
ChartAxisOptions >> id: aString [
	self at: #id put: aString
]

{ #category : #initialization }
ChartAxisOptions >> initialize [
	super initialize.
	self visible: true.
]

{ #category : #accessing }
ChartAxisOptions >> maxBarThickness: aNumber [
	self at: #maxBarThickness put: aNumber
]

{ #category : #converting }
ChartAxisOptions >> neoJsonOn: neoJSONWriter [
	neoJSONWriter writeListStreamingDo: [ :jsonListWriter |
		jsonListWriter writeElement: { #display -> self visible . #type -> self scale } asDictionary ]
]

{ #category : #accessing }
ChartAxisOptions >> positionBottom [
	self at: #position put: #bottom
]

{ #category : #accessing }
ChartAxisOptions >> positionLeft [
	self at: #position put: #left
]

{ #category : #accessing }
ChartAxisOptions >> positionRight [
	self at: #position put: #right
]

{ #category : #accessing }
ChartAxisOptions >> positionTop [
	self at: #position put: #top
]

{ #category : #accessing }
ChartAxisOptions >> scale [
	^ self at: #scale
]

{ #category : #accessing }
ChartAxisOptions >> scale: anObject [
	self at: #scale put: anObject
]

{ #category : #'accessing scaleLabel' }
ChartAxisOptions >> scaleLabelAt: aKey put: aValue [
	(self at: #scaleLabel ifAbsentPut: [Dictionary new]) at: aKey put: aValue
]

{ #category : #'accessing scaleLabel' }
ChartAxisOptions >> scaleLabelDisplay: aBoolean [
	
	self at: #scaleLabel at: #display put: aBoolean
]

{ #category : #'accessing scaleLabel' }
ChartAxisOptions >> scaleLabelLabelString: aString [
	
	self at: #scaleLabel at: #labelString put: aString
]

{ #category : #'accessing ticks' }
ChartAxisOptions >> ticks [
	^ self at: #ticks
]

{ #category : #'accessing ticks' }
ChartAxisOptions >> ticksAt: aKey put: aValue [
	(self at: #ticks ifAbsentPut: [Dictionary new]) at: aKey put: aValue
]

{ #category : #'accessing ticks' }
ChartAxisOptions >> ticksBeginAtZero: aBoolean [
	self ticksAt: #beginAtZero put: aBoolean
]

{ #category : #'accessing ticks' }
ChartAxisOptions >> ticksLabels: aCollection [
	self ticksAt: #labels put: aCollection
]

{ #category : #'accessing ticks' }
ChartAxisOptions >> ticksMax: aValue [
	self ticksAt: #max put: aValue
]

{ #category : #'accessing ticks' }
ChartAxisOptions >> ticksMaxTicksLimit: aValue [
	self ticksAt: #maxTicksLimit put: aValue
]

{ #category : #'accessing ticks' }
ChartAxisOptions >> ticksMin: aValue [
	self ticksAt: #min put: aValue
]

{ #category : #'accessing ticks' }
ChartAxisOptions >> ticksPrecision: aValue [
	self ticksAt: #precision put: aValue
]

{ #category : #'accessing ticks' }
ChartAxisOptions >> ticksStepSize: aValue [
	self ticksAt: #stepSize put: aValue
]

{ #category : #'accessing ticks' }
ChartAxisOptions >> ticksSuggestedMax: aValue [
	self ticksAt: #suggestedMax put: aValue
]

{ #category : #'accessing ticks' }
ChartAxisOptions >> ticksSuggestedMin: aValue [
	self ticksAt: #suggestedMin put: aValue
]

{ #category : #accessing }
ChartAxisOptions >> type [
	^ self at: #type
]

{ #category : #accessing }
ChartAxisOptions >> type: aString [
	self at: #type put: aString
]

{ #category : #accessing }
ChartAxisOptions >> typeLinear [
	self type: #linear
]

{ #category : #accessing }
ChartAxisOptions >> typeLogarithmic [
	self type: #logarithmic
]

{ #category : #'backward compatibility' }
ChartAxisOptions >> visible [
	^ self display
]

{ #category : #'backward compatibility' }
ChartAxisOptions >> visible: aBoolean [
	self display: aBoolean
]

{ #category : #accessing }
ChartAxisOptions >> weight [
	^ self at: #weight
]

{ #category : #accessing }
ChartAxisOptions >> weight: aString [
	self at: #weight put: aString
]
