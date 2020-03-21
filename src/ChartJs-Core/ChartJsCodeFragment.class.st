"
ChartJsCodeFragment is a piece of javascript code that can be rendered as is e.g. in a script tag.
"
Class {
	#name : #ChartJsCodeFragment,
	#superclass : #Object,
	#instVars : [
		'string'
	],
	#category : #'ChartJs-Core-Component'
}

{ #category : #'instance creation' }
ChartJsCodeFragment class >> addTooltipPositionerAverageBelowChartHeight [
	
	^ self new string:
			'Chart.Tooltip.positioners.averageBelowChartHeight = function(elements, position) {
	/** 
	 * a copy of average, but limited to chart height, otherwise 
	 * the tooltip is not shown if the bar is higher than
	 * maxTicks allows
	 */
	
	if (!elements.length) {
		return false;
	}

	var i, len;
	var x = 0;
	var y = 0;
	var count = 0;
	
	for (i = 0, len = elements.length; i < len; ++i) {
		var el = elements[i];
		if (el && el.hasValue()) {
			var pos = el.tooltipPosition();
			x += pos.x;
			y += pos.y;
			++count;
		}
	}

	x = x / count;
	y = y / count;

	/* ensure position is in the bounds of the chart (with some padding) */
	if (y < 0) {
		y = 5;
	}

	return {
		x: x,
		y: y
	};
}'
]

{ #category : #'instance creation' }
ChartJsCodeFragment class >> bubbleChartRadiusFunction: aFactor [
	| theStream |
	theStream := String new writeStream.
	theStream
		nextPutAll: 'function(context) {';
		crtab;
		nextPutAll: 'var triplet = context.dataset.data[context.dataIndex];';
		crtab;
		nextPutAll: 'var value = Math.abs(triplet.z);';
		crtab;
		nextPutAll: 'var chartWidth = context.chart.width;';
		crtab;
		nextPutAll: 'return (chartWidth * value * ';
		nextPutAll: aFactor displayString;
		nextPutAll: ');}'.
	^ self new string: theStream contents
]

{ #category : #'instance creation' }
ChartJsCodeFragment class >> from: aString [
	^ self new string: aString
]

{ #category : #'instance creation' }
ChartJsCodeFragment class >> stacked100Datalabel [
	
	^ self new string:
			'function(value, context)  {
	const data = context.chart.data; 
	const datasetIndex = context.datasetIndex
	const dataIndex = context.dataIndex; 
	if ((data.originalData[datasetIndex][dataIndex]) == 0) return ""; 
	return data.originalData[datasetIndex][dataIndex];
	}'
]

{ #category : #'instance creation' }
ChartJsCodeFragment class >> tooltipLabelFunction: aString [

	| in out needPlus |
	in := aString readStream.
	out := String new writeStream.
	needPlus := false.
	out
		nextPutAll: 'function(tooltipItem, data) {';
		nextPutAll: 'return '.
	[in atEnd]
		whileFalse: [
			| substr placeholder |
			substr := in upTo: $<.
			substr size > 0
				ifTrue: [
					needPlus
						ifTrue: [out nextPutAll: ' + '].
					out
						nextPut: $";
						nextPutAll: substr;
						nextPut: $".
					needPlus := true].
			placeholder := in upTo: $>.
			placeholder = 'key'
				ifTrue: [
					needPlus
						ifTrue: [out nextPutAll: ' + '].
					out nextPutAll: 'data.labels[tooltipItem.index]'.
					needPlus := true].
			placeholder = 'label'
				ifTrue: [
					needPlus
						ifTrue: [out nextPutAll: ' + '].
					out nextPutAll: 'data.datasets[tooltipItem.datasetIndex].label'.
					needPlus := true].
			placeholder = 'value'
				ifTrue: [
					needPlus
						ifTrue: [out nextPutAll: ' + '].
					out nextPutAll: 'data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index]'.
					needPlus := true]].
	out nextPutAll: ';}'.
	^ self new string: out contents
]

{ #category : #converting }
ChartJsCodeFragment >> greaseString [
	
	^ self string greaseString
]

{ #category : #accessing }
ChartJsCodeFragment >> string [
	
	^ string
]

{ #category : #accessing }
ChartJsCodeFragment >> string: anObject [
	
	string := anObject
]
