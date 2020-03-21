"
ChartBrush is a compound brush for the nested tags that are needed to create a chart with chart.js
"
Class {
	#name : #ChartJsChartBrush,
	#superclass : #WACompound,
	#instVars : [
		'data',
		'options',
		'maxHeight',
		'maxWidth',
		'noDataBlock',
		'height',
		'usePositionRelative'
	],
	#classVars : [
		'DefaultCssClassForCanvas',
		'DefaultCssClassForCanvasDiv',
		'DefaultCssClassForChartDiv',
		'DefaultIdPrefixForCanvas',
		'DefaultIdPrefixForCanvasDiv',
		'DefaultIdPrefixForChartDiv',
		'DefaultUsePositionRelative'
	],
	#category : #'ChartJs-Core-Component'
}

{ #category : #private }
ChartJsChartBrush >> addCallback [
	
	^ self
]

{ #category : #private }
ChartJsChartBrush >> callbackScript: aChartCanvas callback: aCallback [

	^ String
		streamContents: [:stream |
			stream
				nextPutAll: 'document.getElementById("';
				nextPutAll: aChartCanvas id;
				nextPutAll: '").onclick = function(evt){';
				cr;
				nextPutAll: 'var activeElement = myChart';
				nextPutAll: self id;
				nextPutAll: '.getElementAtEvent(evt);';
				cr;
				nextPutAll: 'var activePointIndex = 0;';
				cr;
				nextPutAll: 'if (activeElement.size > 0) {activePointIndex = activeElement[0]._index};';
				cr;
				nextPutAll: '// add 1 because Smalltalk starts at 1 and Javascript at 0';
				cr;
				nextPutAll: 'if (activePointIndex!=0) {';
				nextPutAll: 'post("';
				nextPutAll: canvas actionUrl asString;
				nextPutAll: '", { "';
				nextPutAll: aCallback;
				nextPutAll: '" : activePointIndex + 1} );}};']
]

{ #category : #private }
ChartJsChartBrush >> chartScript [

	^ String
		streamContents: [:aStream |
			aStream
				nextPutAll: 'var myChart' , self id;
				nextPutAll: ' = new Chart("';
				nextPutAll: #chartJsCanvas , self id;
				nextPutAll: '", {';
				nextPutAll: 'type: ';
				nextPutAll: self data chartType typeName printString;
				nextPutAll: ', data: '.
			self printChartDataOn: aStream.
			aStream nextPutAll: ', options: '.
			self printChartOptionsOn: aStream.
			aStream nextPutAll: '});']
]

{ #category : #accessing }
ChartJsChartBrush >> data [
	^ data
]

{ #category : #accessing }
ChartJsChartBrush >> data: anObject [
	data := anObject
]

{ #category : #accessing }
ChartJsChartBrush >> height [
	
	^ height
]

{ #category : #accessing }
ChartJsChartBrush >> height: anObject [
	
	height := anObject
]

{ #category : #accessing }
ChartJsChartBrush >> maxHeight [
	^ maxHeight
]

{ #category : #accessing }
ChartJsChartBrush >> maxHeight: aHeight [
	maxHeight := aHeight
]

{ #category : #accessing }
ChartJsChartBrush >> maxWidth [
	^ maxWidth
]

{ #category : #accessing }
ChartJsChartBrush >> maxWidth: aWidth [
	maxWidth := aWidth
]

{ #category : #accessing }
ChartJsChartBrush >> noDataBlock [
	^ noDataBlock
]

{ #category : #accessing }
ChartJsChartBrush >> noDataBlock: aBlock [
	noDataBlock := aBlock
]

{ #category : #accessing }
ChartJsChartBrush >> options [
	^ options ifNil: [ ChartOptions new ]
]

{ #category : #accessing }
ChartJsChartBrush >> options: anObject [
	options := anObject
]

{ #category : #private }
ChartJsChartBrush >> postFunctionScript [

	^ 'function post(path, parameters) {
    var form = $(''<form></form>'');

    form.attr("method", "post");
    form.attr("action", path);

    $.each(parameters, function(key, value) {
        var field = $(''<input></input>'');

        field.attr("type", "hidden");
        field.attr("name", key);
        field.attr("value", value);

        form.append(field);
    });

    // The form needs to be a part of the document in
    // order for us to be able to submit it.
    $(document.body).append(form);
    form.submit();
}'
]

{ #category : #private }
ChartJsChartBrush >> printChartDataOn: stream [
	(NeoJSONWriter on: stream) nextPut: self data
]

{ #category : #private }
ChartJsChartBrush >> printChartOptionsOn: aStream [
	| optionsDictionary |
	optionsDictionary := self options.
	self data enrichOptions: optionsDictionary.
	(NeoJSONWriter on: aStream) nextPut: optionsDictionary
]

{ #category : #rendering }
ChartJsChartBrush >> renderCallbackIn: aChartCanvas [
	| cb |
	self hasCallback
		ifFalse: [ ^ self ].
		
	cb := aChartCanvas
		storeCallback:
			(WAValuesCallback
				on: [ :nodeOrAssociation | 
					callbackBlock
						cull: nodeOrAssociation value
						cull: nodeOrAssociation key ]
				values: self data).
	canvas script: (self callbackScript: aChartCanvas callback: cb)
]

{ #category : #rendering }
ChartJsChartBrush >> renderChartCanvas [
	| chartCanvas |
	chartCanvas := canvas canvas.
	DefaultIdPrefixForCanvas ifNotNil: [:prefix | chartCanvas id: prefix , self id].
	DefaultCssClassForCanvas ifNotNil: [:cssClass | chartCanvas class: cssClass].
	self renderCallbackIn: chartCanvas
]

{ #category : #rendering }
ChartJsChartBrush >> renderChartDiv [
	| div |
	div := canvas div.
	DefaultIdPrefixForChartDiv ifNotNil: [:prefix | div id: prefix , self id].
	DefaultCssClassForChartDiv ifNotNil: [:cssClass | div class: cssClass].
	div 
		class: self data chartType cssClass;
		with: [
			self data hasData
				ifTrue: [self renderGraphDiv]
				ifFalse: [self renderNoData]]
]

{ #category : #rendering }
ChartJsChartBrush >> renderChartScript [

	canvas script: self chartScript
]

{ #category : #rendering }
ChartJsChartBrush >> renderGraphDiv [
	| div |
	div := canvas div.
	DefaultIdPrefixForCanvasDiv ifNotNil: [:prefix | div id: prefix , self id].
	DefaultCssClassForCanvasDiv ifNotNil: [:cssClass | div class: cssClass].

	self usePositionRelative 
		ifTrue: [div style: 'position: relative'].
	self height
		ifNotNil: [:w |
			w isString
				ifTrue: [div style: 'height: ' , height]
				ifFalse: [div style: 'height: ' , height printString]].
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

	div with: [self renderChartCanvas].
	self renderChartScript
]

{ #category : #rendering }
ChartJsChartBrush >> renderNoData [

	noDataBlock ifNotNil: [:b | b cull: canvas]
]

{ #category : #rendering }
ChartJsChartBrush >> renderPostFunctionScript [

	canvas script: self postFunctionScript
]

{ #category : #accessing }
ChartJsChartBrush >> usePositionRelative [
	
	^usePositionRelative ifNil: [true]
]

{ #category : #accessing }
ChartJsChartBrush >> usePositionRelative: aBoolean [
	
	usePositionRelative := aBoolean
]

{ #category : #public }
ChartJsChartBrush >> with: anObject [
	
	super with: anObject.
	id ifNil: [id := canvas nextId].
	self renderChartDiv
]
