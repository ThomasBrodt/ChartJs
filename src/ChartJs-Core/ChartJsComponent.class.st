"
I am a seaside component able to display a Chart with the Chart.js library.

Give me a ChartData to display and I will manage everything.

Don't forget to add ChartJsLibrary to your application
"
Class {
	#name : #ChartJsComponent,
	#superclass : #WAComponent,
	#instVars : [
		'data',
		'options',
		'value',
		'maxHeight',
		'maxWidth'
	],
	#category : #'ChartJs-Core-Component'
}

{ #category : #'instance creation' }
ChartJsComponent class >> data: aChartData [
	^ self new data: aChartData; yourself
]

{ #category : #'instance creation' }
ChartJsComponent class >> data: aChartData callback: aBlockClosure [ 
	^ self new data: aChartData; callback: aBlockClosure; yourself
]

{ #category : #'instance creation' }
ChartJsComponent class >> data: aChartData options: aChartOptions [
	^ self new data: aChartData; options: aChartOptions; yourself
]

{ #category : #'instance creation' }
ChartJsComponent class >> data: aChartData options: aChartOptions callback: aBlockClosure [ 
	^ self new data: aChartData; options: aChartOptions; callback: aBlockClosure; yourself
]

{ #category : #accessing }
ChartJsComponent >> callback: aBlockClosure [ 
	self value: aBlockClosure 
]

{ #category : #callback }
ChartJsComponent >> callbackMechanism: canvasId actionUrl: anUrl cb: cb eventsCode: eventsCode [
	^ String
		streamContents: [ :stream | 
			stream
				<< ('document.getElementById("chartJsGraph' , canvasId);
				<< '").onclick = function(evt){';
				cr;
				<< '	//add 1 because Pharo start at 1 and Js at 0';
				cr;
				<< ('	var activePointIndex = myChart' , canvasId);
				<<
					(self data chartType isMultiDataSet
						ifTrue: [ '.datasets[0].' ]
						ifFalse: [ '.' ]);
				<< self data chartType dataFunction;
				<< '.indexOf(myChart';
				<< canvasId;
				<< '.';
				<< eventsCode;
				<< '[0]);';
				cr;
				<< '	if (activePointIndex != 0) {';
				cr;
				<< '				post( "';
				<< anUrl asString;
				<< '", { "';
				<< cb;
				<< '" : activePointIndex + 1 } );';
				cr;
				<< '	}};' ]
]

{ #category : #rendering }
ChartJsComponent >> chartCreationScriptInDiv: divId [
	^ String
		streamContents: [ :aStream | self printChartCreationScriptOn: aStream inDiv: divId ]
]

{ #category : #accessing }
ChartJsComponent >> data [
	^ data
]

{ #category : #accessing }
ChartJsComponent >> data: anObject [
	data := anObject
]

{ #category : #testing }
ChartJsComponent >> hasCallBack [
	^ self value notNil
]

{ #category : #rendering }
ChartJsComponent >> manageCallBackIn: html canvas: canvas inDiv: divId [
	| cb |
	self hasCallBack
		ifFalse: [ ^ self ].

	cb := canvas
		storeCallback:
			(WAValuesCallback
				on:
					[ :nodeOrAssociation | self value cull: nodeOrAssociation value cull: nodeOrAssociation key ]
				values: self data).
	html
		script:
			(self
				callbackMechanism: divId
				actionUrl: html actionUrl asString
				cb: cb
				eventsCode: self data chartType eventsCode)
]

{ #category : #accessing }
ChartJsComponent >> maxHeight [
	^ maxHeight
]

{ #category : #accessing }
ChartJsComponent >> maxHeight: aHeight [
	maxHeight := aHeight
]

{ #category : #accessing }
ChartJsComponent >> maxWidth [
	^ maxWidth
]

{ #category : #accessing }
ChartJsComponent >> maxWidth: aWidth [
	maxWidth := aWidth
]

{ #category : #accessing }
ChartJsComponent >> options [
	^ options ifNil: [ ChartOptions new ]
]

{ #category : #accessing }
ChartJsComponent >> options: anObject [
	options := anObject
]

{ #category : #rendering }
ChartJsComponent >> printChartCreationScriptOn: aStream inDiv: divId [
	aStream
		<< ('var myChart' , divId);
		<< ' = new Chart("chartJsCanvas';
		<< divId;
		<< '", {';
		<< 'type: ';
		<< self data chartType typeName printString;
		<< ', data: '.
	self printChartDataOn: aStream.
	aStream << ', options: '.
	self printChartOptionsOn: aStream.
	aStream << '});'
]

{ #category : #rendering }
ChartJsComponent >> printChartDataOn: stream [
	(NeoJSONWriter on: stream) nextPut: self data
]

{ #category : #rendering }
ChartJsComponent >> printChartOptionsOn: aStream [
	| optionsDictionary |
	optionsDictionary := self options.
	self data enrichOptions: optionsDictionary.
	(NeoJSONWriter on: aStream) nextPut: optionsDictionary
]

{ #category : #rendering }
ChartJsComponent >> renderContentOn: html [
	| divId canvas |
	divId := html nextId.
	html div
		id: #chartJsChart , divId;
		class: #chartJsChart;
		class: self data chartType name;
		class: #chartJsChartWithLegend if: self data hasLegend;	
		with: [ self data hasData
				ifTrue: [ 
						| div |
						div := html div
							id: #chartJsGraph , divId;
							class: #chartJsGraph;
							style: 'position: relative'.
						self maxHeight
								ifNotNil: [:h |
									h isString
										ifTrue: [div style: 'max-height: ' , h]
										ifFalse: [div style: 'max-height: ' , h printString]].
									self maxWidth
								ifNotNil: [:w |
									w isString
										ifTrue: [div style: 'max-width: ' , w]
										ifFalse: [div style: 'max-width: ' , w printString]].
						div with: [ 
							canvas := html canvas id: #chartJsCanvas , divId.
							self manageCallBackIn: html canvas: canvas inDiv: divId].
					html script: (self chartCreationScriptInDiv: divId)]
				ifFalse: [ html div
						class: 'mdl-alert mdl-alert__danger';
						style: 'color: red; text-align: center; margin: auto;';
						with: [ html text: 'No data to display' ] ] ]
]

{ #category : #rendering }
ChartJsComponent >> renderTitleId: divId on: html [
	^ html div
		id: #title , divId;
		class: #chartJsTitle;
		with: [ 
					html heading
						level3;
						with: self data title ]
]

{ #category : #accessing }
ChartJsComponent >> value [
	^ value
]

{ #category : #accessing }
ChartJsComponent >> value: anObject [
	value := anObject
]
