"
ChartTreemapDemo shows an example of the treemap plugin chart type of chart.js
"
Class {
	#name : #ChartTreemapDemo,
	#superclass : #ChartTypeDemo,
	#category : #'ChartJs-Demo'
}

{ #category : #accessing }
ChartTreemapDemo class >> description [
	^ 'Show data in the form of a treemap.'
]

{ #category : #accessing }
ChartTreemapDemo class >> title [
	^ '- Treemap'
]

{ #category : #rendering }
ChartTreemapDemo >> renderChartJsComponentOn: html [
	| chartData chartOptions |
	chartData := Chart2dData new.
	chartData styleSheet backgroundColor: nil.
	chartData
		chartType: ChartTreemap;
		title: '';
		addDataSet:
			(ChartDataSetTree new
				name: '';
				chartType: ChartTreemap;
				groups: #('name' 'activity');
				key: 'amount';
				tree:
					(ChartSampleData dataEntries
						collect: [ :each | 
							Dictionary new
								at: 'name' put: each name;
								at: 'activity' put: each activity;
								at: 'amount' put: each amount;
								yourself ]);
				options:
					(ChartTreemapOptions new
						spacing: 1;
						borderWidth: 2;
						fontColor: Color black forChartJs;
						fontSize: 16;
						fontWeight: 'bold';
						backgroundColor: (ChartJsCodeFragment from: 'function(ctx) {
																var item = ctx.dataset.data[ctx.dataIndex];
																if (!item) { 
																	return ;
																}
																var weight = item.v / (item.gs || item.s) / 2 + 0.2;
																switch (item.l) {
																	case 0:
																		switch (item.g) {
																			case "Cyril": return Color("#834659").rgbString();
																			default: return Color("#A68C52").rgbString();
																			}
																	case 1: 
																		switch (item.g) {
																			case "Coding": return Color("red").alpha(0.3).rgbString();
																			default: return Color("white").alpha(weight).rgbString();
																			}
																	default: return Color("orange").alpha(weight).rgbString();
																}
															}');
						yourself);
				yourself).

	chartOptions := ChartOptions new.
	chartOptions legendDisplay: false.
	chartOptions
		tooltipsAt: #callbacks
		at: #title
		put:
			(ChartJsCodeFragment
				from:
					'function(item, data) {return data.datasets[item[0].datasetIndex].key;}').
	chartOptions
		tooltipsAt: #callbacks
		at: #label
		put:
			(ChartJsCodeFragment
				from:
					'function(item, data) {
						var dataset = data.datasets[item.datasetIndex];
						var dataItem = dataset.data[item.index];
						var obj = dataItem._data;
						var label;
						for (i = dataset.groups.length; i > 0; i--) {
							if (label == null) { label = obj[dataset.groups[i - 1]] }
						};
						return label + ": " + (dataItem.v);
						}').
	html div
		with: [ html chartJsChart
				data: chartData;
				options: chartOptions;
				callback: [ :value :label | value -> label ] ]
]

{ #category : #updating }
ChartTreemapDemo >> updateRoot: html [
	super updateRoot: html.
	ChartJsPluginTreemapLibrary default updateRoot: html
]
