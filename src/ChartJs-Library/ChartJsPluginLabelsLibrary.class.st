"
I am the import of the labels plugin source files for seaside.

ChartJsPluginBoxPlotLibrary recursivelyAddAllFilesIn: 'C:\TEMP\chartjs-plugin-labels'
"
Class {
	#name : #ChartJsPluginLabelsLibrary,
	#superclass : #ChartJsPluginLibrary,
	#category : #'ChartJs-Library-Plugins'
}

{ #category : #'uploaded metadata' }
ChartJsPluginLabelsLibrary >> chartjsPluginLabelsJs [
	
	^ WAFileLibraryResource
		filepath: 'chartjs-plugin-labels.js'
		mimeType: (WAMimeType main: 'application' sub: 'javascript')
		cacheDuration:
			(Duration
				days: 0
				hours: 0
				minutes: 30
				seconds: 0)
		contents: (GRDelayedSend receiver: self selector: #chartjsPluginLabelsJsContent)
]

{ #category : #uploaded }
ChartJsPluginLabelsLibrary >> chartjsPluginLabelsJsContent [
	
	^ '/**
 * [chartjs-plugin-labels]{@link https://github.com/emn178/chartjs-plugin-labels}
 *
 * @version 1.1.0
 * @author Chen, Yi-Cyuan [emn178@gmail.com]
 * @copyright Chen, Yi-Cyuan 2017-2018
 * @license MIT
 */
(function () {
  ''use strict'';

  if (typeof Chart === ''undefined'') {
    console.error(''Can not find Chart object.'');
    return;
  }

  if (typeof Object.assign != ''function'') {
    Object.assign = function (target, varArgs) {
      if (target == null) {
        throw new TypeError(''Cannot convert undefined or null to object'');
      }
      var to = Object(target);
      for (var index = 1; index < arguments.length; index++) {
        var nextSource = arguments[index];
        if (nextSource != null) {
          for (var nextKey in nextSource) {
            if (Object.prototype.hasOwnProperty.call(nextSource, nextKey)) {
              to[nextKey] = nextSource[nextKey];
            }
          }
        }
      }
      return to;
    };
  }

  var SUPPORTED_TYPES = {};
  [''pie'', ''doughnut'', ''polarArea'', ''bar''].forEach(function (t) {
    SUPPORTED_TYPES[t] = true;
  });

  function Label() {
    this.renderToDataset = this.renderToDataset.bind(this);
  }

  Label.prototype.setup = function (chart, options) {
    this.chart = chart;
    this.ctx = chart.ctx;
    this.args = {};
    this.barTotal = {};
    var chartOptions = chart.config.options;
    this.options = Object.assign({
      position: ''default'',
      precision: 0,
      fontSize: chartOptions.defaultFontSize,
      fontColor: chartOptions.defaultFontColor,
      fontStyle: chartOptions.defaultFontStyle,
      fontFamily: chartOptions.defaultFontFamily,
      shadowOffsetX: 3,
      shadowOffsetY: 3,
      shadowColor: ''rgba(0,0,0,0.3)'',
      shadowBlur: 6,
      images: [],
      outsidePadding: 2,
      textMargin: 2,
      overlap: true
    }, options);
    if (chart.config.type === ''bar'') {
      this.options.position = ''default'';
      this.options.arc = false;
      this.options.overlap = true;
    }
  };

  Label.prototype.render = function () {
    this.labelBounds = [];
    this.chart.data.datasets.forEach(this.renderToDataset);
  };

  Label.prototype.renderToDataset = function (dataset, index) {
    this.totalPercentage = 0;
    this.total = null;
    var arg = this.args[index];
    arg.meta.data.forEach(function (element, index) {
      this.renderToElement(dataset, arg, element, index);
    }.bind(this));
  };

  Label.prototype.renderToElement = function (dataset, arg, element, index) {
    if (!this.shouldRenderToElement(arg.meta, element)) {
      return;
    }
    this.percentage = null;
    var label = this.getLabel(dataset, element, index);
    if (!label) {
      return;
    }
    var ctx = this.ctx;
    ctx.save();
    ctx.font = Chart.helpers.fontString(this.options.fontSize, this.options.fontStyle, this.options.fontFamily);
    var renderInfo = this.getRenderInfo(element, label);
    if (!this.drawable(element, label, renderInfo)) {
      ctx.restore();
      return;
    }
    ctx.beginPath();
    ctx.fillStyle = this.getFontColor(dataset, element, index);
    this.renderLabel(label, renderInfo);
    ctx.restore();
  };

  Label.prototype.renderLabel = function (label, renderInfo) {
    return this.options.arc ? this.renderArcLabel(label, renderInfo) : this.renderBaseLabel(label, renderInfo);
  };

  Label.prototype.renderBaseLabel = function (label, position) {
    var ctx = this.ctx;
    if (typeof label === ''object'') {
      ctx.drawImage(label, position.x - label.width / 2, position.y - label.height / 2, label.width, label.height);
    } else {
      ctx.save();
      ctx.textBaseline = ''top'';
      ctx.textAlign = ''center'';

      if (this.options.textShadow) {
        ctx.shadowOffsetX = this.options.shadowOffsetX;
        ctx.shadowOffsetY = this.options.shadowOffsetY;
        ctx.shadowColor = this.options.shadowColor;
        ctx.shadowBlur = this.options.shadowBlur;
      }

      var lines = label.split(''\n'');
      for (var i = 0; i < lines.length; i++) {
        var y = position.y - this.options.fontSize / 2 * lines.length + this.options.fontSize * i;
        ctx.fillText(lines[i], position.x, y);
      }
      ctx.restore();
    }
  };

  Label.prototype.renderArcLabel = function (label, renderInfo) {
    var ctx = this.ctx, radius = renderInfo.radius, view = renderInfo.view;
    ctx.save();
    ctx.translate(view.x, view.y);
    if (typeof label === ''string'') {
      ctx.rotate(renderInfo.startAngle);
      ctx.textBaseline = ''middle'';
      ctx.textAlign = ''left'';
      var lines = label.split(''\n''), max = 0, widths = [], offset = 0;
      if (this.options.position === ''border'') {
        offset = (lines.length - 1) * this.options.fontSize / 2;
      }
      for (var j = 0; j < lines.length; ++j) {
        var mertrics = ctx.measureText(lines[j]);
        if (mertrics.width > max) {
          max = mertrics.width;
        }
        widths.push(mertrics.width);
      }
      for (var j = 0; j < lines.length; ++j) {
        var line = lines[j];
        var y = (lines.length - 1 - j) * -this.options.fontSize + offset;
        ctx.save();
        var padding = (max - widths[j]) / 2;
        ctx.rotate(padding / radius);
        for (var i = 0; i < line.length; i++) {
          var char = line.charAt(i);
          mertrics = ctx.measureText(char);
          ctx.save();
          ctx.translate(0, -1 * radius);
          ctx.fillText(char, 0, y);
          ctx.restore();
          ctx.rotate(mertrics.width / radius);
        }
        ctx.restore();
      }
    } else {
      ctx.rotate((view.startAngle + Math.PI / 2 + renderInfo.endAngle) / 2);
      ctx.translate(0, -1 * radius);
      this.renderLabel(label, { x: 0, y: 0 });
    }
    ctx.restore();
  };

  Label.prototype.shouldRenderToElement = function (meta, element) {
    return !meta.hidden && !element.hidden && (
      this.options.showZero ||
      this.chart.config.type === ''polarArea'' ? element._view.outerRadius !== 0 : element._view.circumference !== 0
    );
  };

  Label.prototype.getLabel = function (dataset, element, index) {
    var label;
    if (typeof this.options.render === ''function'') {
      label = this.options.render({
        label: this.chart.config.data.labels[index],
        value: dataset.data[index],
        percentage: this.getPercentage(dataset, element, index),
        dataset: dataset,
        index: index
      });
    } else {
      switch (this.options.render) {
        case ''value'':
          label = dataset.data[index];
          break;
        case ''label'':
          label = this.chart.config.data.labels[index];
          break;
        case ''image'':
          label = this.options.images[index] ? this.loadImage(this.options.images[index]) : '''';
          break;
        case ''percentage'':
        default:
          label = this.getPercentage(dataset, element, index) + ''%'';
          break;
      }
    }
    if (typeof label === ''object'') {
      label = this.loadImage(label);
    } else if (label !== null && label !== undefined) {
      label = label.toString();
    }
    return label;
  };

  Label.prototype.getFontColor = function (dataset, element, index) {
    var fontColor = this.options.fontColor;
    if (typeof fontColor === ''function'') {
      fontColor = fontColor({
        label: this.chart.config.data.labels[index],
        value: dataset.data[index],
        percentage: this.getPercentage(dataset, element, index),
        backgroundColor: dataset.backgroundColor[index],
        dataset: dataset,
        index: index
      });
    } else if (typeof fontColor !== ''string'') {
      fontColor = fontColor[index] || this.chart.config.options.defaultFontColor;
    }
    return fontColor;
  };

  Label.prototype.getPercentage = function (dataset, element, index) {
    if (this.percentage !== null) {
      return this.percentage;
    }
    var percentage;
    if (this.chart.config.type === ''polarArea'') {
      if (this.total === null) {
        this.total = 0;
        for (var i = 0;i < dataset.data.length; ++i) {
          this.total += dataset.data[i];
        }
      }
      percentage = dataset.data[index] / this.total * 100;
    } else if (this.chart.config.type === ''bar'') {
      if (this.barTotal[index] === undefined) {
        this.barTotal[index] = 0;
        for (var i = 0;i < this.chart.data.datasets.length; ++i) {
          this.barTotal[index] += this.chart.data.datasets[i].data[index];
        }
      }
      percentage = dataset.data[index] / this.barTotal[index] * 100;
    } else {
      percentage = element._view.circumference / this.chart.config.options.circumference * 100;
    }
    percentage = parseFloat(percentage.toFixed(this.options.precision));
    if (!this.options.showActualPercentages) {
      if (this.chart.config.type === ''bar'') {
        this.totalPercentage = this.barTotalPercentage[index] || 0;
      }
      this.totalPercentage += percentage;
      if (this.totalPercentage > 100) {
        percentage -= this.totalPercentage - 100;
        percentage = parseFloat(percentage.toFixed(this.options.precision));
      }
      if (this.chart.config.type === ''bar'') {
        this.barTotalPercentage[index] = this.totalPercentage
      }
    }
    this.percentage = percentage;
    return percentage;
  };

  Label.prototype.getRenderInfo = function (element, label) {
    if (this.chart.config.type === ''bar'') {
      return this.getBarRenderInfo(element, label);
    } else {
      return this.options.arc ? this.getArcRenderInfo(element, label) : this.getBaseRenderInfo(element, label);
    }
  };

  Label.prototype.getBaseRenderInfo = function (element, label) {
    if (this.options.position === ''outside'' || this.options.position === ''border'') {
      var renderInfo, rangeFromCentre,
        view = element._view,
        centreAngle = view.startAngle + (view.endAngle - view.startAngle) / 2,
        innerRadius = view.outerRadius / 2;
      if (this.options.position === ''border'') {
        rangeFromCentre = (view.outerRadius - innerRadius) / 2 + innerRadius;
      } else if (this.options.position === ''outside'') {
        rangeFromCentre = (view.outerRadius - innerRadius) + innerRadius + this.options.textMargin;
      }
      renderInfo = {
        x: view.x + (Math.cos(centreAngle) * rangeFromCentre),
        y: view.y + (Math.sin(centreAngle) * rangeFromCentre)
      };
      if (this.options.position === ''outside'') {
        var offset = this.options.textMargin + this.measureLabel(label).width / 2;
        renderInfo.x += renderInfo.x < view.x ? -offset : offset;
      }
      return renderInfo;
    } else {
      return element.tooltipPosition();
    }
  };

  Label.prototype.getArcRenderInfo = function (element, label) {
    var radius, view = element._view;
    if (this.options.position === ''outside'') {
      radius = view.outerRadius + this.options.fontSize + this.options.textMargin;
    } else if (this.options.position === ''border'') {
      radius = (view.outerRadius / 2 + view.outerRadius) / 2;
    } else {
      radius = (view.innerRadius + view.outerRadius) / 2;
    }
    var startAngle = view.startAngle, endAngle = view.endAngle;
    var totalAngle = endAngle - startAngle;
    startAngle += Math.PI / 2;
    endAngle += Math.PI / 2;
    var mertrics = this.measureLabel(label);
    startAngle += (endAngle - (mertrics.width / radius + startAngle)) / 2;
    return {
      radius: radius,
      startAngle: startAngle,
      endAngle: endAngle,
      totalAngle: totalAngle,
      view: view
    }
  };

  Label.prototype.getBarRenderInfo = function (element, label) {
    var renderInfo = element.tooltipPosition();
    renderInfo.y -= this.measureLabel(label).height / 2 + this.options.textMargin;
    return renderInfo;
  };

  Label.prototype.drawable = function (element, label, renderInfo) {
    if (this.options.overlap) {
      return true;
    } else if (this.options.arc) {
      return renderInfo.endAngle - renderInfo.startAngle <= renderInfo.totalAngle;
    } else {
      var mertrics = this.measureLabel(label),
        left = renderInfo.x - mertrics.width / 2,
        right = renderInfo.x + mertrics.width / 2,
        top = renderInfo.y - mertrics.height / 2,
        bottom = renderInfo.y + mertrics.height / 2;
      if (this.options.renderInfo === ''outside'') {
        return this.outsideInRange(left, right, top, bottom);
      } else {
        return element.inRange(left, top) && element.inRange(left, bottom) &&
          element.inRange(right, top) && element.inRange(right, bottom);
      }
    }
  };

  Label.prototype.outsideInRange = function (left, right, top, bottom) {
    var labelBounds = this.labelBounds;
    for (var i = 0;i < labelBounds.length;++i) {
      var bound = labelBounds[i];
      var potins = [
        [left, top],
        [left, bottom],
        [right, top],
        [right, bottom]
      ];
      for (var j = 0;j < potins.length;++j) {
        var x = potins[j][0];
        var y = potins[j][1];
        if (x >= bound.left && x <= bound.right && y >= bound.top && y <= bound.bottom) {
          return false;
        }
      }
      potins = [
        [bound.left, bound.top],
        [bound.left, bound.bottom],
        [bound.right, bound.top],
        [bound.right, bound.bottom]
      ];
      for (var j = 0;j < potins.length;++j) {
        var x = potins[j][0];
        var y = potins[j][1];
        if (x >= left && x <= right && y >= top && y <= bottom) {
          return false;
        }
      }
    }
    labelBounds.push({
      left: left,
      right: right,
      top: top,
      bottom: bottom
    });
    return true;
  };

  Label.prototype.measureLabel = function (label) {
    if (typeof label === ''object'') {
      return { width: label.width, height: label.height };
    } else {
      var width = 0;
      var lines = label.split(''\n'');
      for (var i = 0; i < lines.length; ++i) {
        var result = this.ctx.measureText(lines[i]);
        if (result.width > width) {
          width = result.width;
        }
      }
      return { width: width, height: this.options.fontSize * lines.length };
    }
  };

  Label.prototype.loadImage = function (obj) {
    var image = new Image();
    image.src = obj.src;
    image.width = obj.width;
    image.height = obj.height;
    return image;
  };

  Chart.plugins.register({
    id: ''labels'',
    beforeDatasetsUpdate: function (chart, options) {
      if (!SUPPORTED_TYPES[chart.config.type]) {
        return;
      }
      if (!Array.isArray(options)) {
        options = [options];
      }
      var count = options.length;
      if (!chart._labels || count !== chart._labels.length) {
        chart._labels = options.map(function () {
          return new Label();
        });
      }
      var someOutside = false, maxPadding = 0;
      for (var i = 0; i < count; ++i) {
        var label = chart._labels[i];
        label.setup(chart, options[i]);
        if (label.options.position === ''outside'') {
          someOutside = true;
          var padding = label.options.fontSize * 1.5 + label.options.outsidePadding;
          if (padding > maxPadding) {
            maxPadding = padding;
          }
        }
      }
      if (someOutside) {
        chart.chartArea.top += maxPadding;
        chart.chartArea.bottom -= maxPadding;
      }
    },
    afterDatasetUpdate: function (chart, args, options) {
      if (!SUPPORTED_TYPES[chart.config.type]) {
        return;
      }
      chart._labels.forEach(function (label) {
        label.args[args.index] = args;
      });
    },
    beforeDraw: function (chart) {
      if (!SUPPORTED_TYPES[chart.config.type]) {
        return;
      }
      chart._labels.forEach(function (label) {
        label.barTotalPercentage = {};
      });
    },
    afterDatasetsDraw: function (chart) {
      if (!SUPPORTED_TYPES[chart.config.type]) {
        return;
      }
      chart._labels.forEach(function (label) {
        label.render();
      });
    }
  });
})();'
]

{ #category : #'uploaded metadata' }
ChartJsPluginLabelsLibrary >> chartjsPluginLabelsMinJs [
	
	^ WAFileLibraryResource
		filepath: 'chartjs-plugin-labels.min.js'
		mimeType: (WAMimeType main: 'application' sub: 'javascript')
		cacheDuration:
			(Duration
				days: 0
				hours: 0
				minutes: 30
				seconds: 0)
		contents: (GRDelayedSend receiver: self selector: #chartjsPluginLabelsMinJsContent)
]

{ #category : #uploaded }
ChartJsPluginLabelsLibrary >> chartjsPluginLabelsMinJsContent [
	
	^ '/**
 * [chartjs-plugin-labels]{@link https://github.com/emn178/chartjs-plugin-labels}
 *
 * @version 1.1.0
 * @author Chen, Yi-Cyuan [emn178@gmail.com]
 * @copyright Chen, Yi-Cyuan 2017-2018
 * @license MIT
 */
(function(){function f(){this.renderToDataset=this.renderToDataset.bind(this)}if("undefined"===typeof Chart)console.error("Can not find Chart object.");else{"function"!=typeof Object.assign&&(Object.assign=function(a,c){if(null==a)throw new TypeError("Cannot convert undefined or null to object");for(var b=Object(a),e=1;e<arguments.length;e++){var d=arguments[e];if(null!=d)for(var g in d)Object.prototype.hasOwnProperty.call(d,g)&&(b[g]=d[g])}return b});var k={};["pie","doughnut","polarArea","bar"].forEach(function(a){k[a]=
!0});f.prototype.setup=function(a,c){this.chart=a;this.ctx=a.ctx;this.args={};this.barTotal={};var b=a.config.options;this.options=Object.assign({position:"default",precision:0,fontSize:b.defaultFontSize,fontColor:b.defaultFontColor,fontStyle:b.defaultFontStyle,fontFamily:b.defaultFontFamily,shadowOffsetX:3,shadowOffsetY:3,shadowColor:"rgba(0,0,0,0.3)",shadowBlur:6,images:[],outsidePadding:2,textMargin:2,overlap:!0},c);"bar"===a.config.type&&(this.options.position="default",this.options.arc=!1,this.options.overlap=
!0)};f.prototype.render=function(){this.labelBounds=[];this.chart.data.datasets.forEach(this.renderToDataset)};f.prototype.renderToDataset=function(a,c){this.totalPercentage=0;this.total=null;var b=this.args[c];b.meta.data.forEach(function(c,d){this.renderToElement(a,b,c,d)}.bind(this))};f.prototype.renderToElement=function(a,c,b,e){if(this.shouldRenderToElement(c.meta,b)&&(this.percentage=null,c=this.getLabel(a,b,e))){var d=this.ctx;d.save();d.font=Chart.helpers.fontString(this.options.fontSize,
this.options.fontStyle,this.options.fontFamily);var g=this.getRenderInfo(b,c);this.drawable(b,c,g)&&(d.beginPath(),d.fillStyle=this.getFontColor(a,b,e),this.renderLabel(c,g));d.restore()}};f.prototype.renderLabel=function(a,c){return this.options.arc?this.renderArcLabel(a,c):this.renderBaseLabel(a,c)};f.prototype.renderBaseLabel=function(a,c){var b=this.ctx;if("object"===typeof a)b.drawImage(a,c.x-a.width/2,c.y-a.height/2,a.width,a.height);else{b.save();b.textBaseline="top";b.textAlign="center";this.options.textShadow&&
(b.shadowOffsetX=this.options.shadowOffsetX,b.shadowOffsetY=this.options.shadowOffsetY,b.shadowColor=this.options.shadowColor,b.shadowBlur=this.options.shadowBlur);for(var e=a.split("\n"),d=0;d<e.length;d++)b.fillText(e[d],c.x,c.y-this.options.fontSize/2*e.length+this.options.fontSize*d);b.restore()}};f.prototype.renderArcLabel=function(a,c){var b=this.ctx,e=c.radius,d=c.view;b.save();b.translate(d.x,d.y);if("string"===typeof a){b.rotate(c.startAngle);b.textBaseline="middle";b.textAlign="left";d=
a.split("\n");var g=0,l=[],f=0;"border"===this.options.position&&(f=(d.length-1)*this.options.fontSize/2);for(var h=0;h<d.length;++h){var m=b.measureText(d[h]);m.width>g&&(g=m.width);l.push(m.width)}for(h=0;h<d.length;++h){var n=d[h],k=(d.length-1-h)*-this.options.fontSize+f;b.save();b.rotate((g-l[h])/2/e);for(var p=0;p<n.length;p++){var q=n.charAt(p);m=b.measureText(q);b.save();b.translate(0,-1*e);b.fillText(q,0,k);b.restore();b.rotate(m.width/e)}b.restore()}}else b.rotate((d.startAngle+Math.PI/
2+c.endAngle)/2),b.translate(0,-1*e),this.renderLabel(a,{x:0,y:0});b.restore()};f.prototype.shouldRenderToElement=function(a,c){return!a.hidden&&!c.hidden&&(this.options.showZero||"polarArea"===this.chart.config.type?0!==c._view.outerRadius:0!==c._view.circumference)};f.prototype.getLabel=function(a,c,b){if("function"===typeof this.options.render)a=this.options.render({label:this.chart.config.data.labels[b],value:a.data[b],percentage:this.getPercentage(a,c,b),dataset:a,index:b});else switch(this.options.render){case "value":a=
a.data[b];break;case "label":a=this.chart.config.data.labels[b];break;case "image":a=this.options.images[b]?this.loadImage(this.options.images[b]):"";break;default:a=this.getPercentage(a,c,b)+"%"}"object"===typeof a?a=this.loadImage(a):null!==a&&void 0!==a&&(a=a.toString());return a};f.prototype.getFontColor=function(a,c,b){var e=this.options.fontColor;"function"===typeof e?e=e({label:this.chart.config.data.labels[b],value:a.data[b],percentage:this.getPercentage(a,c,b),backgroundColor:a.backgroundColor[b],
dataset:a,index:b}):"string"!==typeof e&&(e=e[b]||this.chart.config.options.defaultFontColor);return e};f.prototype.getPercentage=function(a,c,b){if(null!==this.percentage)return this.percentage;if("polarArea"===this.chart.config.type){if(null===this.total)for(c=this.total=0;c<a.data.length;++c)this.total+=a.data[c];a=a.data[b]/this.total*100}else if("bar"===this.chart.config.type){if(void 0===this.barTotal[b])for(c=this.barTotal[b]=0;c<this.chart.data.datasets.length;++c)this.barTotal[b]+=this.chart.data.datasets[c].data[b];
a=a.data[b]/this.barTotal[b]*100}else a=c._view.circumference/this.chart.config.options.circumference*100;a=parseFloat(a.toFixed(this.options.precision));this.options.showActualPercentages||("bar"===this.chart.config.type&&(this.totalPercentage=this.barTotalPercentage[b]||0),this.totalPercentage+=a,100<this.totalPercentage&&(a-=this.totalPercentage-100,a=parseFloat(a.toFixed(this.options.precision))),"bar"===this.chart.config.type&&(this.barTotalPercentage[b]=this.totalPercentage));return this.percentage=
a};f.prototype.getRenderInfo=function(a,c){return"bar"===this.chart.config.type?this.getBarRenderInfo(a,c):this.options.arc?this.getArcRenderInfo(a,c):this.getBaseRenderInfo(a,c)};f.prototype.getBaseRenderInfo=function(a,c){if("outside"===this.options.position||"border"===this.options.position){var b,e=a._view,d=e.startAngle+(e.endAngle-e.startAngle)/2,g=e.outerRadius/2;"border"===this.options.position?b=(e.outerRadius-g)/2+g:"outside"===this.options.position&&(b=e.outerRadius-g+g+this.options.textMargin);
b={x:e.x+Math.cos(d)*b,y:e.y+Math.sin(d)*b};"outside"===this.options.position&&(d=this.options.textMargin+this.measureLabel(c).width/2,b.x+=b.x<e.x?-d:d);return b}return a.tooltipPosition()};f.prototype.getArcRenderInfo=function(a,c){var b=a._view;var e="outside"===this.options.position?b.outerRadius+this.options.fontSize+this.options.textMargin:"border"===this.options.position?(b.outerRadius/2+b.outerRadius)/2:(b.innerRadius+b.outerRadius)/2;var d=b.startAngle,g=b.endAngle,l=g-d;d+=Math.PI/2;g+=
Math.PI/2;var f=this.measureLabel(c);d+=(g-(f.width/e+d))/2;return{radius:e,startAngle:d,endAngle:g,totalAngle:l,view:b}};f.prototype.getBarRenderInfo=function(a,c){var b=a.tooltipPosition();b.y-=this.measureLabel(c).height/2+this.options.textMargin;return b};f.prototype.drawable=function(a,c,b){if(this.options.overlap)return!0;if(this.options.arc)return b.endAngle-b.startAngle<=b.totalAngle;var e=this.measureLabel(c);c=b.x-e.width/2;var d=b.x+e.width/2,g=b.y-e.height/2;b=b.y+e.height/2;return"outside"===
this.options.renderInfo?this.outsideInRange(c,d,g,b):a.inRange(c,g)&&a.inRange(c,b)&&a.inRange(d,g)&&a.inRange(d,b)};f.prototype.outsideInRange=function(a,c,b,e){for(var d=this.labelBounds,g=0;g<d.length;++g){for(var f=d[g],k=[[a,b],[a,e],[c,b],[c,e]],h=0;h<k.length;++h){var m=k[h][0],n=k[h][1];if(m>=f.left&&m<=f.right&&n>=f.top&&n<=f.bottom)return!1}k=[[f.left,f.top],[f.left,f.bottom],[f.right,f.top],[f.right,f.bottom]];for(h=0;h<k.length;++h)if(m=k[h][0],n=k[h][1],m>=a&&m<=c&&n>=b&&n<=e)return!1}d.push({left:a,
right:c,top:b,bottom:e});return!0};f.prototype.measureLabel=function(a){if("object"===typeof a)return{width:a.width,height:a.height};var c=0;a=a.split("\n");for(var b=0;b<a.length;++b){var e=this.ctx.measureText(a[b]);e.width>c&&(c=e.width)}return{width:c,height:this.options.fontSize*a.length}};f.prototype.loadImage=function(a){var c=new Image;c.src=a.src;c.width=a.width;c.height=a.height;return c};Chart.plugins.register({id:"labels",beforeDatasetsUpdate:function(a,c){if(k[a.config.type]){Array.isArray(c)||
(c=[c]);var b=c.length;a._labels&&b===a._labels.length||(a._labels=c.map(function(){return new f}));for(var e=!1,d=0,g=0;g<b;++g){var l=a._labels[g];l.setup(a,c[g]);"outside"===l.options.position&&(e=!0,l=1.5*l.options.fontSize+l.options.outsidePadding,l>d&&(d=l))}e&&(a.chartArea.top+=d,a.chartArea.bottom-=d)}},afterDatasetUpdate:function(a,c,b){k[a.config.type]&&a._labels.forEach(function(a){a.args[c.index]=c})},beforeDraw:function(a){k[a.config.type]&&a._labels.forEach(function(a){a.barTotalPercentage=
{}})},afterDatasetsDraw:function(a){k[a.config.type]&&a._labels.forEach(function(a){a.render()})}})}})();'
]

{ #category : #private }
ChartJsPluginLabelsLibrary >> github [
	
	^ 'https://github.com/emn178/chartjs-plugin-labels'
]

{ #category : #accessing }
ChartJsPluginLabelsLibrary >> selectorsToInclude [
	^ #(#chartjsPluginLabelsMinJs)
]

{ #category : #private }
ChartJsPluginLabelsLibrary >> version [
	^ '1.1.0'
]
