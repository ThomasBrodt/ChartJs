"
I am the demos for charts components
"
Class {
	#name : #ChartsDemos,
	#superclass : #WAComponent,
	#instVars : [
		'selectedNode',
		'selectedValue',
		'currentDemo'
	],
	#category : #'ChartJs-Demo'
}

{ #category : #'class initialization' }
ChartsDemos class >> initialize [
	WAAdmin applicationDefaults
		removeParent: WADevelopmentConfiguration instance.
	(WAAdmin register: self asApplicationAt: 'ChartJsDemo')
		addLibrary: JQDeploymentLibrary;
		addLibrary: PrismLibrary;
		addLibrary: ChartJsLibrary;
		addLibrary: ChartJsPluginBoxPlotLibrary;
		addLibrary: ChartJsPluginChartFinancialLibrary;
		addLibrary: ChartJsPluginDoughnutLabelLibrary;
		addLibrary: ChartJsPluginLabelsLibrary;
		addLibrary: ChartJsPluginTreemapLibrary
]

{ #category : #versions }
ChartsDemos class >> version [
	^ 'v2.9.3'
]

{ #category : #accessing }
ChartsDemos >> currentDemo [
	^ currentDemo
]

{ #category : #accessing }
ChartsDemos >> currentDemo: anObject [
	currentDemo := anObject
]

{ #category : #initialization }
ChartsDemos >> initialize [
	super initialize.
	self currentDemo: Chart2dDemo new
]

{ #category : #rendering }
ChartsDemos >> renderContentOn: html [
	html div
		class: 'chartJs-demo';
		with: [ self renderDemoListOn: html.
			(html tag: 'main')
				with: [ html div
						class: 'chartJs-demo-page';
						with: [ html render: self currentDemo ] ] ]
]

{ #category : #rendering }
ChartsDemos >> renderDemoListOn: html [
	html div
		class: 'chartJs-demo-list';
		with: [ html unorderedList: [ ChartAbstractDemo demos do: [ :aDemoClass | self renderDemosListItemFor: aDemoClass on: html ] ] ]
]

{ #category : #rendering }
ChartsDemos >> renderDemosListItemFor: aDemoClass on: html [
	html listItem
		class: 'chartJs-demo-list-item_active' if: aDemoClass = self currentDemo class;
		with: [ html anchor
				callback: [ self currentDemo: aDemoClass new ];
				with: [ html span: aDemoClass title ] ]
]

{ #category : #hooks }
ChartsDemos >> style [
	^ 'body, html{
	margin: 0;
	height: 100%;
	width: 100%;
	font-size: 14px;
	font-weight: 400;
	line-height: 20px;
	color: #757575;
	font-family: ''Roboto'',''Helvetica'',''Arial'', sans-serif;
}
	
.chartJs-demo{
	display: flex;
	display: -webkit-flex;
	display: -ms-flexbox;
	background: #fafafa;
	height: 100%;
	width: 100%;
}

.chartJs-demo-list{
	width: 225px;
	height: 100%;
	background-color: #FFF;
	box-shadow: 0 4px 5px 0 rgba(0,0,0,.14),0 1px 10px 0 rgba(0,0,0,.12),0 2px 4px -1px rgba(0,0,0,.2);
}

.chartJs-demo-list ul{
	padding-left: 0;
	font-size: 14px;
	line-height: 24px;
	font-weight: 400;
	letter-spacing: 0;
}

.chartJs-demo-list li{
	-webkit-transition: all 450ms cubic-bezier(.23, 1, .32, 1) 0ms;
	transition: all 450ms cubic-bezier(.23, 1, .32, 1) 0ms;
	width: 100%;
	line-height: 0;
}

.chartJs-demo-list li a{
	padding-left: 15px;
	font-size: 16px;
	font-weight: inherit;
	display: -webkit-flex;
	color: rgba(0,0,0,0.87);
	text-decoration: none;
	white-space: nowrap;
	cursor: pointer;
}

.chartJs-demo-list li a:hover{
	background-color: #eee;
}

.chartJs-demo-list li a span{
	line-height: 60px;
}

.chartJs-demo-list-item_active{
	background-color: rgba(206,147,216 ,1);
}

.chartJs-demo-list li.chartJs-demo-list-item_active a:hover{
	background-color: rgba(186,104,200 ,1);
}

.chartJs-demo-list li.chartJs-demo-list-item_active a{
	color: #FFF;
}

.chartJs-demo main{
	display: inline-block;
	-webkit-flex-grow: 1;
	-ms-flex-positive: 1;
	flex-grow: 1;
	overflow: auto;
}

.chartJs-demo-page{
	padding: 16px;
}

.chartJs-demo-page-title{
	margin-bottom: 60px;
	margin-left: 32px;
	text-align: justify;
}

.chartJs-demo-page-title h3{
	font-size: 16px;
	font-weight: 600;
	margin-top: 80px;
	text-transform: uppercase;
	color: rgba(0,0,0,.54);
	line-height: 40px;
}

.chartJs-demo-page-title p{	
	margin-top: 16px;
	margin-bottom: 16px;
	font-size: 13px;
	max-width: 640px;
}

.chartJs-demo-snippet-group{
	width: 100%;
	overflow: hidden;
	display: flex;
	display: -webkit-flex;
	display: -ms-flexbox;
	flex-direction: column;
}

.chartJs-demo-snippet-demo{
	text-align: center;
	margin: auto;
	width: 100%;
}

.chartJs-demo-snippet-demo .chartJsChart {
    min-width: 600px;
    margin: auto;
}

.chartJs-demo pre{
	margin-top: 0;
	margin-bottom: 0;
	padding-top: 0;
	padding-bottom: 0;
}
'


]

{ #category : #hooks }
ChartsDemos >> styleChartJs [
	^ '
// *************************************
// moved here from ChartJsLibrary
// *************************************

.chartJsChart{
	width: 40%;
	position:relative;
}
	
.chartJsLegend { 
	width: 30%;
	list-style: none;
	text-align: left;
	right: 8px;
	top: 0;
	position: absolute;
}

.chartJsChartWithLegend .chartJsGraph { 
	width: 70%;
}

.chartJsTitle {
	text-align: center;
} 

.radar-legend li, .bar-legend li, .line-legend li, .boxplot-legend li, .pie-legend li, .doughnut-legend li, .polararea-legend li {
	display: block;
	padding-left: 30px;
	position: relative;
	margin-bottom: 4px;
}

.radar-legend li span {
	display: block;
	position: absolute;
	left: 0;
	top: 30%;
	width: 10px;
	height: 10px;
	border-radius: 5px;
}

.bar-legend li span, .boxplot-legend li span, .pie-legend li span, .doughnut-legend li span, .polararea-legend li span {
	display: block;
	position: absolute;
	left: 0;
	top: 0;
	width: 20px;
	height: 100%;
	border-radius: 5px;
}

.line-legend li span {
	display: block;
	position: absolute;
	left: 0;
	top: 45%;
	width: 20px;
	height: 10%;
	border-radius: 0px;
}
'
]

{ #category : #updating }
ChartsDemos >> updateRoot: anHtmlRoot [
	super updateRoot: anHtmlRoot.
	anHtmlRoot link
		beStylesheet;
		url: 'https://fonts.googleapis.com/css?family=Roboto'.
	anHtmlRoot title: 'ChartJs Demo - ' , self class version.
	anHtmlRoot addStyle: self styleChartJs.
	self currentDemo updateRoot: anHtmlRoot
]
