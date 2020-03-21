Class {
	#name : #ChartJsPluginBoxPlotLibrary,
	#superclass : #ChartJsPluginLibrary,
	#category : #'ChartJs-Library'
}

{ #category : #'uploaded metadata' }
ChartJsPluginBoxPlotLibrary >> chartBoxplotJs [
	^ WAFileLibraryResource
		filepath: 'Chart.BoxPlot.js'
		mimeType: (WAMimeType main: 'application' sub: 'javascript')
		cacheDuration: (Duration days: 0 hours: 0 minutes: 30 seconds: 0)
		contents: (GRDelayedSend receiver: self selector: #chartBoxplotJsContent)
]

{ #category : #uploaded }
ChartJsPluginBoxPlotLibrary >> chartBoxplotJsContent [
	
	^ '(function (global, factory) {
  typeof exports === ''object'' && typeof module !== ''undefined'' ? factory(exports, require(''chart.js'')) :
  typeof define === ''function'' && define.amd ? define([''exports'', ''chart.js''], factory) :
  (global = global || self, factory(global.ChartBoxPlot = {}, global.Chart));
}(this, function (exports, Chart) { ''use strict'';

  function _defineProperty(obj, key, value) {
    if (key in obj) {
      Object.defineProperty(obj, key, {
        value: value,
        enumerable: true,
        configurable: true,
        writable: true
      });
    } else {
      obj[key] = value;
    }

    return obj;
  }

  function _objectSpread(target) {
    for (var i = 1; i < arguments.length; i++) {
      var source = arguments[i] != null ? arguments[i] : {};
      var ownKeys = Object.keys(source);

      if (typeof Object.getOwnPropertySymbols === ''function'') {
        ownKeys = ownKeys.concat(Object.getOwnPropertySymbols(source).filter(function (sym) {
          return Object.getOwnPropertyDescriptor(source, sym).enumerable;
        }));
      }

      ownKeys.forEach(function (key) {
        _defineProperty(target, key, source[key]);
      });
    }

    return target;
  }

  function _slicedToArray(arr, i) {
    return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _nonIterableRest();
  }

  function _arrayWithHoles(arr) {
    if (Array.isArray(arr)) return arr;
  }

  function _iterableToArrayLimit(arr, i) {
    var _arr = [];
    var _n = true;
    var _d = false;
    var _e = undefined;

    try {
      for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) {
        _arr.push(_s.value);

        if (i && _arr.length === i) break;
      }
    } catch (err) {
      _d = true;
      _e = err;
    } finally {
      try {
        if (!_n && _i["return"] != null) _i["return"]();
      } finally {
        if (_d) throw _e;
      }
    }

    return _arr;
  }

  function _nonIterableRest() {
    throw new TypeError("Invalid attempt to destructure non-iterable instance");
  }

  function ascending(a, b) {
    return a - b;
  }

  function quantiles(d, quantiles) {
    d = d.slice().sort(ascending);
    var n_1 = d.length - 1;
    return quantiles.map(function (q) {
      if (q === 0) return d[0];else if (q === 1) return d[n_1];
      var index = 1 + q * n_1,
          lo = Math.floor(index),
          h = index - lo,
          a = d[lo - 1];
      return h === 0 ? a : a + h * (d[lo] - a);
    });
  }

  // See <http://en.wikipedia.org/wiki/Kernel_(statistics)>.
  function gaussian(u) {
    return 1 / Math.sqrt(2 * Math.PI) * Math.exp(-.5 * u * u);
  }

  // Welford''s algorithm.
  function mean(x) {
    var n = x.length;
    if (n === 0) return NaN;
    var m = 0,
        i = -1;

    while (++i < n) m += (x[i] - m) / (i + 1);

    return m;
  }

  // Also known as the sample variance, where the denominator is n - 1.

  function variance(x) {
    var n = x.length;
    if (n < 1) return NaN;
    if (n === 1) return 0;
    var mean$$1 = mean(x),
        i = -1,
        s = 0;

    while (++i < n) {
      var v = x[i] - mean$$1;
      s += v * v;
    }

    return s / (n - 1);
  }

  function iqr(x) {
    var quartiles = quantiles(x, [.25, .75]);
    return quartiles[1] - quartiles[0];
  }

  // Visualization. Wiley.

  function nrd(x) {
    var h = iqr(x) / 1.34;
    return 1.06 * Math.min(Math.sqrt(variance(x)), h) * Math.pow(x.length, -1 / 5);
  }

  function functor(v) {
    return typeof v === "function" ? v : function () {
      return v;
    };
  }

  function kde() {
    var kernel = gaussian,
        sample = [],
        bandwidth = nrd;

    function kde(points, i) {
      var bw = bandwidth.call(this, sample);
      return points.map(function (x) {
        var i = -1,
            y = 0,
            n = sample.length;

        while (++i < n) {
          y += kernel((x - sample[i]) / bw);
        }

        return [x, y / bw / n];
      });
    }

    kde.kernel = function (x) {
      if (!arguments.length) return kernel;
      kernel = x;
      return kde;
    };

    kde.sample = function (x) {
      if (!arguments.length) return sample;
      sample = x;
      return kde;
    };

    kde.bandwidth = function (x) {
      if (!arguments.length) return bandwidth;
      bandwidth = functor(x);
      return kde;
    };

    return kde;
  }

  function extent(arr) {
    return arr.reduce(function (acc, v) {
      return [Math.min(acc[0], v), Math.max(acc[1], v)];
    }, [Number.POSITIVE_INFINITY, Number.NEGATIVE_INFINITY]);
  }

  function whiskers(boxplot, arr) {
    var iqr = boxplot.q3 - boxplot.q1; // since top left is max

    var whiskerMin = Math.max(boxplot.min, boxplot.q1 - iqr);
    var whiskerMax = Math.min(boxplot.max, boxplot.q3 + iqr);

    if (Array.isArray(arr)) {
      // compute the closest real element
      for (var i = 0; i < arr.length; i++) {
        var v = arr[i];

        if (v >= whiskerMin) {
          whiskerMin = v;
          break;
        }
      }

      for (var _i = arr.length - 1; _i >= 0; _i--) {
        var _v = arr[_i];

        if (_v <= whiskerMax) {
          whiskerMax = _v;
          break;
        }
      }
    }

    return {
      whiskerMin: whiskerMin,
      whiskerMax: whiskerMax
    };
  }
  function boxplotStats(arr) {
    // console.assert(Array.isArray(arr));
    if (arr.length === 0) {
      return {
        min: NaN,
        max: NaN,
        median: NaN,
        q1: NaN,
        q3: NaN,
        whiskerMin: NaN,
        whiskerMax: NaN,
        outliers: []
      };
    }

    arr = arr.filter(function (v) {
      return typeof v === ''number'' && !isNaN(v);
    });
    arr.sort(function (a, b) {
      return a - b;
    });

    var _quantiles = quantiles(arr, [0.5, 0.25, 0.75]),
        _quantiles2 = _slicedToArray(_quantiles, 3),
        median = _quantiles2[0],
        q1 = _quantiles2[1],
        q3 = _quantiles2[2];

    var minmax = extent(arr);
    var base = {
      min: minmax[0],
      max: minmax[1],
      median: median,
      q1: q1,
      q3: q3,
      outliers: []
    };

    var _whiskers = whiskers(base, arr),
        whiskerMin = _whiskers.whiskerMin,
        whiskerMax = _whiskers.whiskerMax;

    base.outliers = arr.filter(function (v) {
      return v < whiskerMin || v > whiskerMax;
    });
    base.whiskerMin = whiskerMin;
    base.whiskerMax = whiskerMax;
    return base;
  }
  function violinStats(arr) {
    // console.assert(Array.isArray(arr));
    if (arr.length === 0) {
      return {
        outliers: []
      };
    }

    arr = arr.filter(function (v) {
      return typeof v === ''number'' && !isNaN(v);
    });
    arr.sort(function (a, b) {
      return a - b;
    });
    var minmax = extent(arr);
    return {
      min: minmax[0],
      max: minmax[1],
      median: quantiles(arr, [0.5])[0],
      kde: kde().sample(arr)
    };
  }
  function asBoxPlotStats(value) {
    if (!value) {
      return null;
    }

    if (typeof value.median === ''number'' && typeof value.q1 === ''number'' && typeof value.q3 === ''number'') {
      // sounds good, check for helper
      if (typeof value.whiskerMin === ''undefined'') {
        var _whiskers2 = whiskers(value, Array.isArray(value.items) ? value.items.slice().sort(function (a, b) {
          return a - b;
        }) : null),
            whiskerMin = _whiskers2.whiskerMin,
            whiskerMax = _whiskers2.whiskerMax;

        value.whiskerMin = whiskerMin;
        value.whiskerMax = whiskerMax;
      }

      return value;
    }

    if (!Array.isArray(value)) {
      return undefined;
    }

    if (value.__stats === undefined) {
      value.__stats = boxplotStats(value);
    }

    return value.__stats;
  }
  function asViolinStats(value) {
    if (!value) {
      return null;
    }

    if (typeof value.median === ''number'' && (typeof value.kde === ''function'' || Array.isArray(value.coords))) {
      return value;
    }

    if (!Array.isArray(value)) {
      return undefined;
    }

    if (value.__kde === undefined) {
      value.__kde = violinStats(value);
    }

    return value.__kde;
  }
  function asValueStats(value, minStats, maxStats) {
    if (typeof value[minStats] === ''number'' && typeof value[maxStats] === ''number'') {
      return value;
    }

    if (!Array.isArray(value) || value.length === 0) {
      return undefined;
    }

    return asBoxPlotStats(value);
  }
  function getRightValue(rawValue) {
    if (!rawValue) {
      return rawValue;
    }

    if (typeof rawValue === ''number'' || typeof rawValue === ''string'') {
      return Number(rawValue);
    }

    var b = asBoxPlotStats(rawValue);
    return b ? b.median : rawValue;
  }
  var commonScaleOptions = {
    ticks: {
      minStats: ''min'',
      maxStats: ''max''
    }
  };
  function commonDataLimits(extraCallback) {
    var _this = this;

    var chart = this.chart;
    var isHorizontal = this.isHorizontal();
    var tickOpts = this.options.ticks;
    var minStats = tickOpts.minStats;
    var maxStats = tickOpts.maxStats;

    var matchID = function matchID(meta) {
      return isHorizontal ? meta.xAxisID === _this.id : meta.yAxisID === _this.id;
    }; // First Calculate the range


    this.min = null;
    this.max = null; // Regular charts use x, y values
    // For the boxplot chart we have rawValue.min and rawValue.max for each point

    chart.data.datasets.forEach(function (d, i) {
      var meta = chart.getDatasetMeta(i);

      if (!chart.isDatasetVisible(i) || !matchID(meta)) {
        return;
      }

      d.data.forEach(function (value, j) {
        if (!value || meta.data[j].hidden) {
          return;
        }

        var stats = asValueStats(value, minStats, maxStats);

        if (!stats) {
          return;
        }

        if (_this.min === null || stats[minStats] < _this.min) {
          _this.min = stats[minStats];
        }

        if (_this.max === null || stats[maxStats] > _this.max) {
          _this.max = stats[maxStats];
        }

        if (extraCallback) {
          extraCallback(stats);
        }
      });
    });
  }
  function rnd(seed) {
    // Adapted from http://indiegamr.com/generate-repeatable-random-numbers-in-js/
    if (seed === undefined) {
      seed = Date.now();
    }

    return function () {
      seed = (seed * 9301 + 49297) % 233280;
      return seed / 233280;
    };
  }

  var defaults = _objectSpread({}, Chart.defaults.global.elements.rectangle, {
    borderWidth: 1,
    outlierRadius: 2,
    outlierColor: Chart.defaults.global.elements.rectangle.backgroundColor,
    medianColor: null,
    itemRadius: 0,
    itemStyle: ''circle'',
    itemBackgroundColor: Chart.defaults.global.elements.rectangle.backgroundColor,
    itemBorderColor: Chart.defaults.global.elements.rectangle.borderColor,
    hitPadding: 2,
    tooltipDecimals: 2
  });
  var ArrayElementBase = Chart.Element.extend({
    isVertical: function isVertical() {
      return this._view.width !== undefined;
    },
    draw: function draw() {// abstract
    },
    _drawItems: function _drawItems(vm, container, ctx, vert) {
      if (vm.itemRadius <= 0 || !container.items || container.items.length <= 0) {
        return;
      }

      ctx.save();
      ctx.strokeStle = vm.itemBorderColor;
      ctx.fillStyle = vm.itemBackgroundColor; // jitter based on random data
      // use the datesetindex and index to initialize the random number generator

      var random = rnd(this._datasetIndex * 1000 + this._index);

      if (vert) {
        container.items.forEach(function (v) {
          Chart.canvasHelpers.drawPoint(ctx, vm.itemStyle, vm.itemRadius, vm.x - vm.width / 2 + random() * vm.width, v);
        });
      } else {
        container.items.forEach(function (v) {
          Chart.canvasHelpers.drawPoint(ctx, vm.itemStyle, vm.itemRadius, v, vm.y - vm.height / 2 + random() * vm.height);
        });
      }

      ctx.restore();
    },
    _drawOutliers: function _drawOutliers(vm, container, ctx, vert) {
      if (!container.outliers) {
        return;
      }

      ctx.fillStyle = vm.outlierColor;
      ctx.beginPath();

      if (vert) {
        container.outliers.forEach(function (v) {
          ctx.arc(vm.x, v, vm.outlierRadius, 0, Math.PI * 2);
        });
      } else {
        container.outliers.forEach(function (v) {
          ctx.arc(v, vm.y, vm.outlierRadius, 0, Math.PI * 2);
        });
      }

      ctx.fill();
      ctx.closePath();
    },
    _getBounds: function _getBounds() {
      // abstract
      return {
        left: 0,
        top: 0,
        right: 0,
        bottom: 0
      };
    },
    _getHitBounds: function _getHitBounds() {
      var padding = this._view.hitPadding;

      var b = this._getBounds();

      return {
        left: b.left - padding,
        top: b.top - padding,
        right: b.right + padding,
        bottom: b.bottom + padding
      };
    },
    height: function height() {
      return 0; // abstract
    },
    inRange: function inRange(mouseX, mouseY) {
      if (!this._view) {
        return false;
      }

      var bounds = this._getHitBounds();

      return mouseX >= bounds.left && mouseX <= bounds.right && mouseY >= bounds.top && mouseY <= bounds.bottom;
    },
    inLabelRange: function inLabelRange(mouseX, mouseY) {
      if (!this._view) {
        return false;
      }

      var bounds = this._getHitBounds();

      if (this.isVertical()) {
        return mouseX >= bounds.left && mouseX <= bounds.right;
      }

      return mouseY >= bounds.top && mouseY <= bounds.bottom;
    },
    inXRange: function inXRange(mouseX) {
      var bounds = this._getHitBounds();

      return mouseX >= bounds.left && mouseX <= bounds.right;
    },
    inYRange: function inYRange(mouseY) {
      var bounds = this._getHitBounds();

      return mouseY >= bounds.top && mouseY <= bounds.bottom;
    },
    getCenterPoint: function getCenterPoint() {
      var _this$_view = this._view,
          x = _this$_view.x,
          y = _this$_view.y;
      return {
        x: x,
        y: y
      };
    },
    getArea: function getArea() {
      return 0; // abstract
    },
    tooltipPosition_: function tooltipPosition_() {
      return this.getCenterPoint();
    }
  });

  Chart.defaults.global.elements.boxandwhiskers = _objectSpread({}, defaults);

  function transitionBoxPlot(start, view, model, ease) {
    var keys = Object.keys(model);

    for (var _i = 0; _i < keys.length; _i++) {
      var key = keys[_i];
      var target = model[key];
      var origin = start[key];

      if (origin === target) {
        continue;
      }

      if (typeof target === ''number'') {
        view[key] = origin + (target - origin) * ease;
        continue;
      }

      if (Array.isArray(target)) {
        var v = view[key];
        var common = Math.min(target.length, origin.length);

        for (var i = 0; i < common; ++i) {
          v[i] = origin[i] + (target[i] - origin[i]) * ease;
        }
      }
    }
  }

  var BoxAndWiskers = Chart.elements.BoxAndWhiskers = ArrayElementBase.extend({
    transition: function transition(ease) {
      var r = Chart.Element.prototype.transition.call(this, ease);
      var model = this._model;
      var start = this._start;
      var view = this._view; // No animation -> No Transition

      if (!model || ease === 1) {
        return r;
      }

      if (start.boxplot == null) {
        return r; // model === view -> not copied
      } // create deep copy to avoid alternation


      if (model.boxplot === view.boxplot) {
        view.boxplot = Chart.helpers.clone(view.boxplot);
      }

      transitionBoxPlot(start.boxplot, view.boxplot, model.boxplot, ease);
      return r;
    },
    draw: function draw() {
      var ctx = this._chart.ctx;
      var vm = this._view;
      var boxplot = vm.boxplot;
      var vert = this.isVertical();

      this._drawItems(vm, boxplot, ctx, vert);

      ctx.save();
      ctx.fillStyle = vm.backgroundColor;
      ctx.strokeStyle = vm.borderColor;
      ctx.lineWidth = vm.borderWidth;

      this._drawBoxPlot(vm, boxplot, ctx, vert);

      this._drawOutliers(vm, boxplot, ctx, vert);

      ctx.restore();
    },
    _drawBoxPlot: function _drawBoxPlot(vm, boxplot, ctx, vert) {
      if (vert) {
        this._drawBoxPlotVert(vm, boxplot, ctx);
      } else {
        this._drawBoxPlotHoriz(vm, boxplot, ctx);
      }
    },
    _drawBoxPlotVert: function _drawBoxPlotVert(vm, boxplot, ctx) {
      var x = vm.x;
      var width = vm.width;
      var x0 = x - width / 2; // Draw the q1>q3 box

      if (boxplot.q3 > boxplot.q1) {
        ctx.fillRect(x0, boxplot.q1, width, boxplot.q3 - boxplot.q1);
      } else {
        ctx.fillRect(x0, boxplot.q3, width, boxplot.q1 - boxplot.q3);
      } // Draw the median line


      ctx.save();

      if (vm.medianColor) {
        ctx.strokeStyle = vm.medianColor;
      }

      ctx.beginPath();
      ctx.moveTo(x0, boxplot.median);
      ctx.lineTo(x0 + width, boxplot.median);
      ctx.closePath();
      ctx.stroke();
      ctx.restore(); // Draw the border around the main q1>q3 box

      if (boxplot.q3 > boxplot.q1) {
        ctx.strokeRect(x0, boxplot.q1, width, boxplot.q3 - boxplot.q1);
      } else {
        ctx.strokeRect(x0, boxplot.q3, width, boxplot.q1 - boxplot.q3);
      } // Draw the whiskers


      ctx.beginPath();
      ctx.moveTo(x0, boxplot.whiskerMin);
      ctx.lineTo(x0 + width, boxplot.whiskerMin);
      ctx.moveTo(x, boxplot.whiskerMin);
      ctx.lineTo(x, boxplot.q1);
      ctx.moveTo(x0, boxplot.whiskerMax);
      ctx.lineTo(x0 + width, boxplot.whiskerMax);
      ctx.moveTo(x, boxplot.whiskerMax);
      ctx.lineTo(x, boxplot.q3);
      ctx.closePath();
      ctx.stroke();
    },
    _drawBoxPlotHoriz: function _drawBoxPlotHoriz(vm, boxplot, ctx) {
      var y = vm.y;
      var height = vm.height;
      var y0 = y - height / 2; // Draw the q1>q3 box

      if (boxplot.q3 > boxplot.q1) {
        ctx.fillRect(boxplot.q1, y0, boxplot.q3 - boxplot.q1, height);
      } else {
        ctx.fillRect(boxplot.q3, y0, boxplot.q1 - boxplot.q3, height);
      } // Draw the median line


      ctx.save();

      if (vm.medianColor) {
        ctx.strokeStyle = vm.medianColor;
      }

      ctx.beginPath();
      ctx.moveTo(boxplot.median, y0);
      ctx.lineTo(boxplot.median, y0 + height);
      ctx.closePath();
      ctx.stroke();
      ctx.restore(); // Draw the border around the main q1>q3 box

      if (boxplot.q3 > boxplot.q1) {
        ctx.strokeRect(boxplot.q1, y0, boxplot.q3 - boxplot.q1, height);
      } else {
        ctx.strokeRect(boxplot.q3, y0, boxplot.q1 - boxplot.q3, height);
      } // Draw the whiskers


      ctx.beginPath();
      ctx.moveTo(boxplot.whiskerMin, y0);
      ctx.lineTo(boxplot.whiskerMin, y0 + height);
      ctx.moveTo(boxplot.whiskerMin, y);
      ctx.lineTo(boxplot.q1, y);
      ctx.moveTo(boxplot.whiskerMax, y0);
      ctx.lineTo(boxplot.whiskerMax, y0 + height);
      ctx.moveTo(boxplot.whiskerMax, y);
      ctx.lineTo(boxplot.q3, y);
      ctx.closePath();
      ctx.stroke();
    },
    _getBounds: function _getBounds() {
      var vm = this._view;
      var vert = this.isVertical();
      var boxplot = vm.boxplot;

      if (!boxplot) {
        return {
          left: 0,
          top: 0,
          right: 0,
          bottom: 0
        };
      }

      if (vert) {
        var x = vm.x,
            width = vm.width;
        var x0 = x - width / 2;
        return {
          left: x0,
          top: boxplot.whiskerMax,
          right: x0 + width,
          bottom: boxplot.whiskerMin
        };
      }

      var y = vm.y,
          height = vm.height;
      var y0 = y - height / 2;
      return {
        left: boxplot.whiskerMin,
        top: y0,
        right: boxplot.whiskerMax,
        bottom: y0 + height
      };
    },
    height: function height() {
      var vm = this._view;
      return vm.base - Math.min(vm.boxplot.q1, vm.boxplot.q3);
    },
    getArea: function getArea() {
      var vm = this._view;
      var iqr = Math.abs(vm.boxplot.q3 - vm.boxplot.q1);

      if (this.isVertical()) {
        return iqr * vm.width;
      }

      return iqr * vm.height;
    }
  });

  Chart.defaults.global.elements.violin = _objectSpread({
    points: 100
  }, defaults);

  function transitionViolin(start, view, model, ease) {
    var keys = Object.keys(model);

    for (var _i = 0; _i < keys.length; _i++) {
      var key = keys[_i];
      var target = model[key];
      var origin = start[key];

      if (origin === target) {
        continue;
      }

      if (typeof target === ''number'') {
        view[key] = origin + (target - origin) * ease;
        continue;
      }

      if (key === ''coords'') {
        var v = view[key];
        var common = Math.min(target.length, origin.length);

        for (var i = 0; i < common; ++i) {
          v[i].v = origin[i].v + (target[i].v - origin[i].v) * ease;
          v[i].estimate = origin[i].estimate + (target[i].estimate - origin[i].estimate) * ease;
        }
      }
    }
  }

  var Violin = Chart.elements.Violin = ArrayElementBase.extend({
    transition: function transition(ease) {
      var r = Chart.Element.prototype.transition.call(this, ease);
      var model = this._model;
      var start = this._start;
      var view = this._view; // No animation -> No Transition

      if (!model || ease === 1) {
        return r;
      }

      if (start.violin == null) {
        return r; // model === view -> not copied
      } // create deep copy to avoid alternation


      if (model.violin === view.violin) {
        view.violin = Chart.helpers.clone(view.violin);
      }

      transitionViolin(start.violin, view.violin, model.violin, ease);
      return r;
    },
    draw: function draw() {
      var ctx = this._chart.ctx;
      var vm = this._view;
      var violin = vm.violin;
      var vert = this.isVertical();

      this._drawItems(vm, violin, ctx, vert);

      ctx.save();
      ctx.fillStyle = vm.backgroundColor;
      ctx.strokeStyle = vm.borderColor;
      ctx.lineWidth = vm.borderWidth;
      var coords = violin.coords;
      Chart.canvasHelpers.drawPoint(ctx, ''rectRot'', 5, vm.x, vm.y);
      ctx.stroke();
      ctx.beginPath();

      if (vert) {
        var x = vm.x;
        var width = vm.width;
        var factor = width / 2 / violin.maxEstimate;
        ctx.moveTo(x, violin.min);
        coords.forEach(function (_ref) {
          var v = _ref.v,
              estimate = _ref.estimate;
          ctx.lineTo(x - estimate * factor, v);
        });
        ctx.lineTo(x, violin.max);
        ctx.moveTo(x, violin.min);
        coords.forEach(function (_ref2) {
          var v = _ref2.v,
              estimate = _ref2.estimate;
          ctx.lineTo(x + estimate * factor, v);
        });
        ctx.lineTo(x, violin.max);
      } else {
        var y = vm.y;
        var height = vm.height;

        var _factor = height / 2 / violin.maxEstimate;

        ctx.moveTo(violin.min, y);
        coords.forEach(function (_ref3) {
          var v = _ref3.v,
              estimate = _ref3.estimate;
          ctx.lineTo(v, y - estimate * _factor);
        });
        ctx.lineTo(violin.max, y);
        ctx.moveTo(violin.min, y);
        coords.forEach(function (_ref4) {
          var v = _ref4.v,
              estimate = _ref4.estimate;
          ctx.lineTo(v, y + estimate * _factor);
        });
        ctx.lineTo(violin.max, y);
      }

      ctx.stroke();
      ctx.fill();
      ctx.closePath();

      this._drawOutliers(vm, violin, ctx, vert);

      ctx.restore();
    },
    _getBounds: function _getBounds() {
      var vm = this._view;
      var vert = this.isVertical();
      var violin = vm.violin;

      if (vert) {
        var x = vm.x,
            width = vm.width;
        var x0 = x - width / 2;
        return {
          left: x0,
          top: violin.max,
          right: x0 + width,
          bottom: violin.min
        };
      }

      var y = vm.y,
          height = vm.height;
      var y0 = y - height / 2;
      return {
        left: violin.min,
        top: y0,
        right: violin.max,
        bottom: y0 + height
      };
    },
    height: function height() {
      var vm = this._view;
      return vm.base - Math.min(vm.violin.min, vm.violin.max);
    },
    getArea: function getArea() {
      var vm = this._view;
      var iqr = Math.abs(vm.violin.max - vm.violin.min);

      if (this.isVertical()) {
        return iqr * vm.width;
      }

      return iqr * vm.height;
    }
  });

  var verticalDefaults = {
    scales: {
      yAxes: [{
        type: ''arrayLinear''
      }]
    }
  };
  var horizontalDefaults = {
    scales: {
      xAxes: [{
        type: ''arrayLinear''
      }]
    }
  };
  function toFixed(value) {
    var decimals = this._chart.config.options.tooltipDecimals; // inject number of decimals from config

    if (decimals == null || typeof decimals !== ''number'' || decimals < 0) {
      return value;
    }

    return Number.parseFloat(value).toFixed(decimals);
  }
  var array = {
    _elementOptions: function _elementOptions() {
      return {};
    },
    updateElement: function updateElement(elem, index, reset) {
      var dataset = this.getDataset();
      var custom = elem.custom || {};

      var options = this._elementOptions();

      Chart.controllers.bar.prototype.updateElement.call(this, elem, index, reset);
      var resolve = Chart.helpers.options.resolve;
      var keys = [''outlierRadius'', ''itemRadius'', ''itemStyle'', ''itemBackgroundColor'', ''itemBorderColor'', ''outlierColor'', ''medianColor'', ''hitPadding'']; // Scriptable options

      var context = {
        chart: this.chart,
        dataIndex: index,
        dataset: dataset,
        datasetIndex: this.index
      };
      keys.forEach(function (item) {
        elem._model[item] = resolve([custom[item], dataset[item], options[item]], context, index);
      });
    },
    _calculateCommonModel: function _calculateCommonModel(r, data, container, scale) {
      if (container.outliers) {
        r.outliers = container.outliers.map(function (d) {
          return scale.getPixelForValue(Number(d));
        });
      }

      if (Array.isArray(data)) {
        r.items = data.map(function (d) {
          return scale.getPixelForValue(Number(d));
        });
      }
    }
  };

  var defaults$1 = {
    tooltips: {
      callbacks: {
        label: function label(item, data) {
          var datasetLabel = data.datasets[item.datasetIndex].label || '''';
          var value = data.datasets[item.datasetIndex].data[item.index];
          var b = asBoxPlotStats(value);
          var label = "".concat(datasetLabel, " ").concat(typeof item.xLabel === ''string'' ? item.xLabel : item.yLabel);

          if (!b) {
            return "".concat(label, " (NaN)");
          }

          return "".concat(label, " (min: ").concat(toFixed.call(this, b.min), ", q1: ").concat(toFixed.call(this, b.q1), ", median: ").concat(toFixed.call(this, b.median), ", q3: ").concat(toFixed.call(this, b.q3), ", max: ").concat(toFixed.call(this, b.max), ")");
        }
      }
    }
  };
  Chart.defaults.boxplot = Chart.helpers.merge({}, [Chart.defaults.bar, verticalDefaults, defaults$1]);
  Chart.defaults.horizontalBoxplot = Chart.helpers.merge({}, [Chart.defaults.horizontalBar, horizontalDefaults, defaults$1]);

  var boxplot = _objectSpread({}, array, {
    dataElementType: Chart.elements.BoxAndWhiskers,
    _elementOptions: function _elementOptions() {
      return this.chart.options.elements.boxandwhiskers;
    },

    /**
     * @private
     */
    _updateElementGeometry: function _updateElementGeometry(elem, index, reset) {
      Chart.controllers.bar.prototype._updateElementGeometry.call(this, elem, index, reset);

      elem._model.boxplot = this._calculateBoxPlotValuesPixels(this.index, index);
    },

    /**
     * @private
     */
    _calculateBoxPlotValuesPixels: function _calculateBoxPlotValuesPixels(datasetIndex, index) {
      var scale = this._getValueScale();

      var data = this.chart.data.datasets[datasetIndex].data[index];

      if (!data) {
        return null;
      }

      var v = asBoxPlotStats(data);
      var r = {};
      Object.keys(v).forEach(function (key) {
        if (key !== ''outliers'') {
          r[key] = scale.getPixelForValue(Number(v[key]));
        }
      });

      this._calculateCommonModel(r, data, v, scale);

      return r;
    }
  });
  /**
   * This class is based off controller.bar.js from the upstream Chart.js library
   */


  var BoxPlot = Chart.controllers.boxplot = Chart.controllers.bar.extend(boxplot);
  var HorizontalBoxPlot = Chart.controllers.horizontalBoxplot = Chart.controllers.horizontalBar.extend(boxplot);

  var defaults$2 = {
    tooltips: {
      callbacks: {
        label: function label(item, data) {
          var datasetLabel = data.datasets[item.datasetIndex].label || '''';
          var value = item.value;
          var label = "".concat(datasetLabel, " ").concat(typeof item.xLabel === ''string'' ? item.xLabel : item.yLabel);
          return "".concat(label, " (").concat(toFixed.call(this, value), ")");
        }
      }
    }
  };
  Chart.defaults.violin = Chart.helpers.merge({}, [Chart.defaults.bar, verticalDefaults, defaults$2]);
  Chart.defaults.horizontalViolin = Chart.helpers.merge({}, [Chart.defaults.horizontalBar, horizontalDefaults, defaults$2]);

  var controller = _objectSpread({}, array, {
    dataElementType: Chart.elements.Violin,
    _elementOptions: function _elementOptions() {
      return this.chart.options.elements.violin;
    },

    /**
     * @private
     */
    _updateElementGeometry: function _updateElementGeometry(elem, index, reset) {
      Chart.controllers.bar.prototype._updateElementGeometry.call(this, elem, index, reset);

      var custom = elem.custom || {};

      var options = this._elementOptions();

      elem._model.violin = this._calculateViolinValuesPixels(this.index, index, custom.points !== undefined ? custom.points : options.points);
    },

    /**
     * @private
     */
    _calculateViolinValuesPixels: function _calculateViolinValuesPixels(datasetIndex, index, points) {
      var scale = this._getValueScale();

      var data = this.chart.data.datasets[datasetIndex].data[index];
      var violin = asViolinStats(data);

      if (!Array.isArray(data) && typeof data === ''number'' && !Number.isNaN || violin == null) {
        return {
          min: data,
          max: data,
          median: data,
          coords: [{
            v: data,
            estimate: Number.NEGATIVE_INFINITY
          }],
          maxEstimate: Number.NEGATIVE_INFINITY
        };
      }

      var range = violin.max - violin.min;
      var samples = [];
      var inc = range / points;

      for (var v = violin.min; v <= violin.max && inc > 0; v += inc) {
        samples.push(v);
      }

      if (samples[samples.length - 1] !== violin.max) {
        samples.push(violin.max);
      }

      var coords = violin.coords || violin.kde(samples).map(function (v) {
        return {
          v: v[0],
          estimate: v[1]
        };
      });
      var r = {
        min: scale.getPixelForValue(violin.min),
        max: scale.getPixelForValue(violin.max),
        median: scale.getPixelForValue(violin.median),
        coords: coords.map(function (_ref) {
          var v = _ref.v,
              estimate = _ref.estimate;
          return {
            v: scale.getPixelForValue(v),
            estimate: estimate
          };
        }),
        maxEstimate: coords.reduce(function (a, d) {
          return Math.max(a, d.estimate);
        }, Number.NEGATIVE_INFINITY)
      };

      this._calculateCommonModel(r, data, violin, scale);

      return r;
    }
  });
  /**
   * This class is based off controller.bar.js from the upstream Chart.js library
   */


  var Violin$1 = Chart.controllers.violin = Chart.controllers.bar.extend(controller);
  var HorizontalViolin = Chart.controllers.horizontalViolin = Chart.controllers.horizontalBar.extend(controller);

  var helpers = Chart.helpers;
  var ArrayLinearScaleOptions = helpers.merge({}, [commonScaleOptions, Chart.scaleService.getScaleDefaults(''linear'')]);
  var ArrayLinearScale = Chart.scaleService.getScaleConstructor(''linear'').extend({
    getRightValue: function getRightValue$$1(rawValue) {
      return Chart.LinearScaleBase.prototype.getRightValue.call(this, getRightValue(rawValue));
    },
    determineDataLimits: function determineDataLimits() {
      commonDataLimits.call(this); // Common base implementation to handle ticks.min, ticks.max, ticks.beginAtZero

      this.handleTickRangeOptions();
    }
  });
  Chart.scaleService.registerScaleType(''arrayLinear'', ArrayLinearScale, ArrayLinearScaleOptions);

  var helpers$1 = Chart.helpers;
  var ArrayLogarithmicScaleOptions = helpers$1.merge({}, [commonScaleOptions, Chart.scaleService.getScaleDefaults(''logarithmic'')]);
  var ArrayLogarithmicScale = Chart.scaleService.getScaleConstructor(''logarithmic'').extend({
    getRightValue: function getRightValue$$1(rawValue) {
      return Chart.LinearScaleBase.prototype.getRightValue.call(this, getRightValue(rawValue));
    },
    determineDataLimits: function determineDataLimits() {
      var _this = this;

      // Add whitespace around bars. Axis shouldn''t go exactly from min to max
      var tickOpts = this.options.ticks;
      this.minNotZero = null;
      commonDataLimits.call(this, function (boxPlot) {
        var value = boxPlot[tickOpts.minStats];

        if (value !== 0 && (_this.minNotZero === null || value < _this.minNotZero)) {
          _this.minNotZero = value;
        }
      });
      this.min = helpers$1.valueOrDefault(tickOpts.min, this.min - this.min * 0.05);
      this.max = helpers$1.valueOrDefault(tickOpts.max, this.max + this.max * 0.05);

      if (this.min === this.max) {
        if (this.min !== 0 && this.min !== null) {
          this.min = Math.pow(10, Math.floor(helpers$1.log10(this.min)) - 1);
          this.max = Math.pow(10, Math.floor(helpers$1.log10(this.max)) + 1);
        } else {
          this.min = 1;
          this.max = 10;
        }
      }
    }
  });
  Chart.scaleService.registerScaleType(''arrayLogarithmic'', ArrayLogarithmicScale, ArrayLogarithmicScaleOptions);

  exports.BoxAndWhiskers = BoxAndWiskers;
  exports.Violin = Violin;
  exports.ArrayLinearScale = ArrayLinearScale;
  exports.ArrayLogarithmicScale = ArrayLogarithmicScale;
  exports.BoxPlot = BoxPlot;
  exports.HorizontalBoxPlot = HorizontalBoxPlot;
  exports.HorizontalViolin = HorizontalViolin;

  Object.defineProperty(exports, ''__esModule'', { value: true });

}));'
]

{ #category : #'uploaded metadata' }
ChartJsPluginBoxPlotLibrary >> chartBoxplotMinJs [
	^ WAFileLibraryResource
		filepath: 'Chart.BoxPlot.min.js'
		mimeType: (WAMimeType main: 'application' sub: 'javascript')
		cacheDuration: (Duration days: 0 hours: 0 minutes: 30 seconds: 0)
		contents: (GRDelayedSend receiver: self selector: #chartBoxplotMinJsContent)
]

{ #category : #uploaded }
ChartJsPluginBoxPlotLibrary >> chartBoxplotMinJsContent [
	
	^ '!function(t,e){"object"==typeof exports&&"undefined"!=typeof module?e(exports,require("chart.js")):"function"==typeof define&&define.amd?define(["exports","chart.js"],e):e((t=t||self).ChartBoxPlot={},t.Chart)}(this,function(t,e){"use strict";function i(t,e,i){return e in t?Object.defineProperty(t,e,{value:i,enumerable:!0,configurable:!0,writable:!0}):t[e]=i,t}function r(t){for(var e=1;e<arguments.length;e++){var r=null!=arguments[e]?arguments[e]:{},n=Object.keys(r);"function"==typeof Object.getOwnPropertySymbols&&(n=n.concat(Object.getOwnPropertySymbols(r).filter(function(t){return Object.getOwnPropertyDescriptor(r,t).enumerable}))),n.forEach(function(e){i(t,e,r[e])})}return t}function n(t,e){return function(t){if(Array.isArray(t))return t}(t)||function(t,e){var i=[],r=!0,n=!1,o=void 0;try{for(var a,l=t[Symbol.iterator]();!(r=(a=l.next()).done)&&(i.push(a.value),!e||i.length!==e);r=!0);}catch(t){n=!0,o=t}finally{try{r||null==l.return||l.return()}finally{if(n)throw o}}return i}(t,e)||function(){throw new TypeError("Invalid attempt to destructure non-iterable instance")}()}function o(t,e){return t-e}function a(t,e){var i=(t=t.slice().sort(o)).length-1;return e.map(function(e){if(0===e)return t[0];if(1===e)return t[i];var r=1+e*i,n=Math.floor(r),o=r-n,a=t[n-1];return 0===o?a:a+o*(t[n]-a)})}function l(t){return 1/Math.sqrt(2*Math.PI)*Math.exp(-.5*t*t)}function s(t){var e=function(t){var e=a(t,[.25,.75]);return e[1]-e[0]}(t)/1.34;return 1.06*Math.min(Math.sqrt(function(t){var e=t.length;if(e<1)return NaN;if(1===e)return 0;for(var i=function(t){var e=t.length;if(0===e)return NaN;for(var i=0,r=-1;++r<e;)i+=(t[r]-i)/(r+1);return i}(t),r=-1,n=0;++r<e;){var o=t[r]-i;n+=o*o}return n/(e-1)}(t)),e)*Math.pow(t.length,-.2)}function u(t){return t.reduce(function(t,e){return[Math.min(t[0],e),Math.max(t[1],e)]},[Number.POSITIVE_INFINITY,Number.NEGATIVE_INFINITY])}function c(t,e){var i=t.q3-t.q1,r=Math.max(t.min,t.q1-i),n=Math.min(t.max,t.q3+i);if(Array.isArray(e)){for(var o=0;o<e.length;o++){var a=e[o];if(a>=r){r=a;break}}for(var l=e.length-1;l>=0;l--){var s=e[l];if(s<=n){n=s;break}}}return{whiskerMin:r,whiskerMax:n}}function h(t){if(0===t.length)return{outliers:[]};(t=t.filter(function(t){return"number"==typeof t&&!isNaN(t)})).sort(function(t,e){return t-e});var e=u(t);return{min:e[0],max:e[1],median:a(t,[.5])[0],kde:function(){var t=l,e=[],i=s;function r(r,n){var o=i.call(this,e);return r.map(function(i){for(var r=-1,n=0,a=e.length;++r<a;)n+=t((i-e[r])/o);return[i,n/o/a]})}return r.kernel=function(e){return arguments.length?(t=e,r):t},r.sample=function(t){return arguments.length?(e=t,r):e},r.bandwidth=function(t){return arguments.length?(i="function"==typeof(e=t)?e:function(){return e},r):i;var e},r}().sample(t)}}function m(t){if(!t)return null;if("number"==typeof t.median&&"number"==typeof t.q1&&"number"==typeof t.q3){if(void 0===t.whiskerMin){var e=c(t,Array.isArray(t.items)?t.items.slice().sort(function(t,e){return t-e}):null),i=e.whiskerMin,r=e.whiskerMax;t.whiskerMin=i,t.whiskerMax=r}return t}return Array.isArray(t)?(void 0===t.__stats&&(t.__stats=function(t){if(0===t.length)return{min:NaN,max:NaN,median:NaN,q1:NaN,q3:NaN,whiskerMin:NaN,whiskerMax:NaN,outliers:[]};(t=t.filter(function(t){return"number"==typeof t&&!isNaN(t)})).sort(function(t,e){return t-e});var e=n(a(t,[.5,.25,.75]),3),i=e[0],r=e[1],o=e[2],l=u(t),s={min:l[0],max:l[1],median:i,q1:r,q3:o,outliers:[]},h=c(s,t),m=h.whiskerMin,f=h.whiskerMax;return s.outliers=t.filter(function(t){return t<m||t>f}),s.whiskerMin=m,s.whiskerMax=f,s}(t)),t.__stats):void 0}function f(t){if(!t)return t;if("number"==typeof t||"string"==typeof t)return Number(t);var e=m(t);return e?e.median:t}var d={ticks:{minStats:"min",maxStats:"max"}};function v(t){var e=this,i=this.chart,r=this.isHorizontal(),n=this.options.ticks,o=n.minStats,a=n.maxStats;this.min=null,this.max=null,i.data.datasets.forEach(function(n,l){var s=i.getDatasetMeta(l);i.isDatasetVisible(l)&&function(t){return r?t.xAxisID===e.id:t.yAxisID===e.id}(s)&&n.data.forEach(function(i,r){if(i&&!s.data[r].hidden){var n=function(t,e,i){return"number"==typeof t[e]&&"number"==typeof t[i]?t:Array.isArray(t)&&0!==t.length?m(t):void 0}(i,o,a);n&&((null===e.min||n[o]<e.min)&&(e.min=n[o]),(null===e.max||n[a]>e.max)&&(e.max=n[a]),t&&t(n))}})})}var x=r({},e.defaults.global.elements.rectangle,{borderWidth:1,outlierRadius:2,outlierColor:e.defaults.global.elements.rectangle.backgroundColor,medianColor:null,itemRadius:0,itemStyle:"circle",itemBackgroundColor:e.defaults.global.elements.rectangle.backgroundColor,itemBorderColor:e.defaults.global.elements.rectangle.borderColor,hitPadding:2,tooltipDecimals:2}),p=e.Element.extend({isVertical:function(){return void 0!==this._view.width},draw:function(){},_drawItems:function(t,i,r,n){if(!(t.itemRadius<=0||!i.items||i.items.length<=0)){r.save(),r.strokeStle=t.itemBorderColor,r.fillStyle=t.itemBackgroundColor;var o,a=(void 0===(o=1e3*this._datasetIndex+this._index)&&(o=Date.now()),function(){return(o=(9301*o+49297)%233280)/233280});n?i.items.forEach(function(i){e.canvasHelpers.drawPoint(r,t.itemStyle,t.itemRadius,t.x-t.width/2+a()*t.width,i)}):i.items.forEach(function(i){e.canvasHelpers.drawPoint(r,t.itemStyle,t.itemRadius,i,t.y-t.height/2+a()*t.height)}),r.restore()}},_drawOutliers:function(t,e,i,r){e.outliers&&(i.fillStyle=t.outlierColor,i.beginPath(),r?e.outliers.forEach(function(e){i.arc(t.x,e,t.outlierRadius,0,2*Math.PI)}):e.outliers.forEach(function(e){i.arc(e,t.y,t.outlierRadius,0,2*Math.PI)}),i.fill(),i.closePath())},_getBounds:function(){return{left:0,top:0,right:0,bottom:0}},_getHitBounds:function(){var t=this._view.hitPadding,e=this._getBounds();return{left:e.left-t,top:e.top-t,right:e.right+t,bottom:e.bottom+t}},height:function(){return 0},inRange:function(t,e){if(!this._view)return!1;var i=this._getHitBounds();return t>=i.left&&t<=i.right&&e>=i.top&&e<=i.bottom},inLabelRange:function(t,e){if(!this._view)return!1;var i=this._getHitBounds();return this.isVertical()?t>=i.left&&t<=i.right:e>=i.top&&e<=i.bottom},inXRange:function(t){var e=this._getHitBounds();return t>=e.left&&t<=e.right},inYRange:function(t){var e=this._getHitBounds();return t>=e.top&&t<=e.bottom},getCenterPoint:function(){var t=this._view;return{x:t.x,y:t.y}},getArea:function(){return 0},tooltipPosition_:function(){return this.getCenterPoint()}});e.defaults.global.elements.boxandwhiskers=r({},x);var g=e.elements.BoxAndWhiskers=p.extend({transition:function(t){var i=e.Element.prototype.transition.call(this,t),r=this._model,n=this._start,o=this._view;return r&&1!==t?null==n.boxplot?i:(r.boxplot===o.boxplot&&(o.boxplot=e.helpers.clone(o.boxplot)),function(t,e,i,r){for(var n=Object.keys(i),o=0;o<n.length;o++){var a=n[o],l=i[a],s=t[a];if(s!==l)if("number"!=typeof l){if(Array.isArray(l))for(var u=e[a],c=Math.min(l.length,s.length),h=0;h<c;++h)u[h]=s[h]+(l[h]-s[h])*r}else e[a]=s+(l-s)*r}}(n.boxplot,o.boxplot,r.boxplot,t),i):i},draw:function(){var t=this._chart.ctx,e=this._view,i=e.boxplot,r=this.isVertical();this._drawItems(e,i,t,r),t.save(),t.fillStyle=e.backgroundColor,t.strokeStyle=e.borderColor,t.lineWidth=e.borderWidth,this._drawBoxPlot(e,i,t,r),this._drawOutliers(e,i,t,r),t.restore()},_drawBoxPlot:function(t,e,i,r){r?this._drawBoxPlotVert(t,e,i):this._drawBoxPlotHoriz(t,e,i)},_drawBoxPlotVert:function(t,e,i){var r=t.x,n=t.width,o=r-n/2;e.q3>e.q1?i.fillRect(o,e.q1,n,e.q3-e.q1):i.fillRect(o,e.q3,n,e.q1-e.q3),i.save(),t.medianColor&&(i.strokeStyle=t.medianColor),i.beginPath(),i.moveTo(o,e.median),i.lineTo(o+n,e.median),i.closePath(),i.stroke(),i.restore(),e.q3>e.q1?i.strokeRect(o,e.q1,n,e.q3-e.q1):i.strokeRect(o,e.q3,n,e.q1-e.q3),i.beginPath(),i.moveTo(o,e.whiskerMin),i.lineTo(o+n,e.whiskerMin),i.moveTo(r,e.whiskerMin),i.lineTo(r,e.q1),i.moveTo(o,e.whiskerMax),i.lineTo(o+n,e.whiskerMax),i.moveTo(r,e.whiskerMax),i.lineTo(r,e.q3),i.closePath(),i.stroke()},_drawBoxPlotHoriz:function(t,e,i){var r=t.y,n=t.height,o=r-n/2;e.q3>e.q1?i.fillRect(e.q1,o,e.q3-e.q1,n):i.fillRect(e.q3,o,e.q1-e.q3,n),i.save(),t.medianColor&&(i.strokeStyle=t.medianColor),i.beginPath(),i.moveTo(e.median,o),i.lineTo(e.median,o+n),i.closePath(),i.stroke(),i.restore(),e.q3>e.q1?i.strokeRect(e.q1,o,e.q3-e.q1,n):i.strokeRect(e.q3,o,e.q1-e.q3,n),i.beginPath(),i.moveTo(e.whiskerMin,o),i.lineTo(e.whiskerMin,o+n),i.moveTo(e.whiskerMin,r),i.lineTo(e.q1,r),i.moveTo(e.whiskerMax,o),i.lineTo(e.whiskerMax,o+n),i.moveTo(e.whiskerMax,r),i.lineTo(e.q3,r),i.closePath(),i.stroke()},_getBounds:function(){var t=this._view,e=this.isVertical(),i=t.boxplot;if(!i)return{left:0,top:0,right:0,bottom:0};if(e){var r=t.x,n=t.width,o=r-n/2;return{left:o,top:i.whiskerMax,right:o+n,bottom:i.whiskerMin}}var a=t.y,l=t.height,s=a-l/2;return{left:i.whiskerMin,top:s,right:i.whiskerMax,bottom:s+l}},height:function(){var t=this._view;return t.base-Math.min(t.boxplot.q1,t.boxplot.q3)},getArea:function(){var t=this._view,e=Math.abs(t.boxplot.q3-t.boxplot.q1);return this.isVertical()?e*t.width:e*t.height}});e.defaults.global.elements.violin=r({points:100},x);var b=e.elements.Violin=p.extend({transition:function(t){var i=e.Element.prototype.transition.call(this,t),r=this._model,n=this._start,o=this._view;return r&&1!==t?null==n.violin?i:(r.violin===o.violin&&(o.violin=e.helpers.clone(o.violin)),function(t,e,i,r){for(var n=Object.keys(i),o=0;o<n.length;o++){var a=n[o],l=i[a],s=t[a];if(s!==l)if("number"!=typeof l){if("coords"===a)for(var u=e[a],c=Math.min(l.length,s.length),h=0;h<c;++h)u[h].v=s[h].v+(l[h].v-s[h].v)*r,u[h].estimate=s[h].estimate+(l[h].estimate-s[h].estimate)*r}else e[a]=s+(l-s)*r}}(n.violin,o.violin,r.violin,t),i):i},draw:function(){var t=this._chart.ctx,i=this._view,r=i.violin,n=this.isVertical();this._drawItems(i,r,t,n),t.save(),t.fillStyle=i.backgroundColor,t.strokeStyle=i.borderColor,t.lineWidth=i.borderWidth;var o=r.coords;if(e.canvasHelpers.drawPoint(t,"rectRot",5,i.x,i.y),t.stroke(),t.beginPath(),n){var a=i.x,l=i.width/2/r.maxEstimate;t.moveTo(a,r.min),o.forEach(function(e){var i=e.v,r=e.estimate;t.lineTo(a-r*l,i)}),t.lineTo(a,r.max),t.moveTo(a,r.min),o.forEach(function(e){var i=e.v,r=e.estimate;t.lineTo(a+r*l,i)}),t.lineTo(a,r.max)}else{var s=i.y,u=i.height/2/r.maxEstimate;t.moveTo(r.min,s),o.forEach(function(e){var i=e.v,r=e.estimate;t.lineTo(i,s-r*u)}),t.lineTo(r.max,s),t.moveTo(r.min,s),o.forEach(function(e){var i=e.v,r=e.estimate;t.lineTo(i,s+r*u)}),t.lineTo(r.max,s)}t.stroke(),t.fill(),t.closePath(),this._drawOutliers(i,r,t,n),t.restore()},_getBounds:function(){var t=this._view,e=this.isVertical(),i=t.violin;if(e){var r=t.x,n=t.width,o=r-n/2;return{left:o,top:i.max,right:o+n,bottom:i.min}}var a=t.y,l=t.height,s=a-l/2;return{left:i.min,top:s,right:i.max,bottom:s+l}},height:function(){var t=this._view;return t.base-Math.min(t.violin.min,t.violin.max)},getArea:function(){var t=this._view,e=Math.abs(t.violin.max-t.violin.min);return this.isVertical()?e*t.width:e*t.height}}),y={scales:{yAxes:[{type:"arrayLinear"}]}},_={scales:{xAxes:[{type:"arrayLinear"}]}};function w(t){var e=this._chart.config.options.tooltipDecimals;return null==e||"number"!=typeof e||e<0?t:Number.parseFloat(t).toFixed(e)}var k={_elementOptions:function(){return{}},updateElement:function(t,i,r){var n=this.getDataset(),o=t.custom||{},a=this._elementOptions();e.controllers.bar.prototype.updateElement.call(this,t,i,r);var l=e.helpers.options.resolve,s={chart:this.chart,dataIndex:i,dataset:n,datasetIndex:this.index};["outlierRadius","itemRadius","itemStyle","itemBackgroundColor","itemBorderColor","outlierColor","medianColor","hitPadding"].forEach(function(e){t._model[e]=l([o[e],n[e],a[e]],s,i)})},_calculateCommonModel:function(t,e,i,r){i.outliers&&(t.outliers=i.outliers.map(function(t){return r.getPixelForValue(Number(t))})),Array.isArray(e)&&(t.items=e.map(function(t){return r.getPixelForValue(Number(t))}))}},M={tooltips:{callbacks:{label:function(t,e){var i=e.datasets[t.datasetIndex].label||"",r=m(e.datasets[t.datasetIndex].data[t.index]),n="".concat(i," ").concat("string"==typeof t.xLabel?t.xLabel:t.yLabel);return r?"".concat(n," (min: ").concat(w.call(this,r.min),", q1: ").concat(w.call(this,r.q1),", median: ").concat(w.call(this,r.median),", q3: ").concat(w.call(this,r.q3),", max: ").concat(w.call(this,r.max),")"):"".concat(n," (NaN)")}}}};e.defaults.boxplot=e.helpers.merge({},[e.defaults.bar,y,M]),e.defaults.horizontalBoxplot=e.helpers.merge({},[e.defaults.horizontalBar,_,M]);var q=r({},k,{dataElementType:e.elements.BoxAndWhiskers,_elementOptions:function(){return this.chart.options.elements.boxandwhiskers},_updateElementGeometry:function(t,i,r){e.controllers.bar.prototype._updateElementGeometry.call(this,t,i,r),t._model.boxplot=this._calculateBoxPlotValuesPixels(this.index,i)},_calculateBoxPlotValuesPixels:function(t,e){var i=this._getValueScale(),r=this.chart.data.datasets[t].data[e];if(!r)return null;var n=m(r),o={};return Object.keys(n).forEach(function(t){"outliers"!==t&&(o[t]=i.getPixelForValue(Number(n[t])))}),this._calculateCommonModel(o,r,n,i),o}}),N=e.controllers.boxplot=e.controllers.bar.extend(q),P=e.controllers.horizontalBoxplot=e.controllers.horizontalBar.extend(q),T={tooltips:{callbacks:{label:function(t,e){var i=e.datasets[t.datasetIndex].label||"",r=t.value,n="".concat(i," ").concat("string"==typeof t.xLabel?t.xLabel:t.yLabel);return"".concat(n," (").concat(w.call(this,r),")")}}}};e.defaults.violin=e.helpers.merge({},[e.defaults.bar,y,T]),e.defaults.horizontalViolin=e.helpers.merge({},[e.defaults.horizontalBar,_,T]);var V=r({},k,{dataElementType:e.elements.Violin,_elementOptions:function(){return this.chart.options.elements.violin},_updateElementGeometry:function(t,i,r){e.controllers.bar.prototype._updateElementGeometry.call(this,t,i,r);var n=t.custom||{},o=this._elementOptions();t._model.violin=this._calculateViolinValuesPixels(this.index,i,void 0!==n.points?n.points:o.points)},_calculateViolinValuesPixels:function(t,e,i){var r,n=this._getValueScale(),o=this.chart.data.datasets[t].data[e],a=(r=o)?"number"!=typeof r.median||"function"!=typeof r.kde&&!Array.isArray(r.coords)?Array.isArray(r)?(void 0===r.__kde&&(r.__kde=h(r)),r.__kde):void 0:r:null;if(!Array.isArray(o)&&"number"==typeof o&&!Number.isNaN||null==a)return{min:o,max:o,median:o,coords:[{v:o,estimate:Number.NEGATIVE_INFINITY}],maxEstimate:Number.NEGATIVE_INFINITY};for(var l=[],s=(a.max-a.min)/i,u=a.min;u<=a.max&&s>0;u+=s)l.push(u);l[l.length-1]!==a.max&&l.push(a.max);var c=a.coords||a.kde(l).map(function(t){return{v:t[0],estimate:t[1]}}),m={min:n.getPixelForValue(a.min),max:n.getPixelForValue(a.max),median:n.getPixelForValue(a.median),coords:c.map(function(t){var e=t.v,i=t.estimate;return{v:n.getPixelForValue(e),estimate:i}}),maxEstimate:c.reduce(function(t,e){return Math.max(t,e.estimate)},Number.NEGATIVE_INFINITY)};return this._calculateCommonModel(m,o,a,n),m}}),S=(e.controllers.violin=e.controllers.bar.extend(V),e.controllers.horizontalViolin=e.controllers.horizontalBar.extend(V)),E=e.helpers.merge({},[d,e.scaleService.getScaleDefaults("linear")]),B=e.scaleService.getScaleConstructor("linear").extend({getRightValue:function(t){return e.LinearScaleBase.prototype.getRightValue.call(this,f(t))},determineDataLimits:function(){v.call(this),this.handleTickRangeOptions()}});e.scaleService.registerScaleType("arrayLinear",B,E);var A=e.helpers,I=A.merge({},[d,e.scaleService.getScaleDefaults("logarithmic")]),C=e.scaleService.getScaleConstructor("logarithmic").extend({getRightValue:function(t){return e.LinearScaleBase.prototype.getRightValue.call(this,f(t))},determineDataLimits:function(){var t=this,e=this.options.ticks;this.minNotZero=null,v.call(this,function(i){var r=i[e.minStats];0!==r&&(null===t.minNotZero||r<t.minNotZero)&&(t.minNotZero=r)}),this.min=A.valueOrDefault(e.min,this.min-.05*this.min),this.max=A.valueOrDefault(e.max,this.max+.05*this.max),this.min===this.max&&(0!==this.min&&null!==this.min?(this.min=Math.pow(10,Math.floor(A.log10(this.min))-1),this.max=Math.pow(10,Math.floor(A.log10(this.max))+1)):(this.min=1,this.max=10))}});e.scaleService.registerScaleType("arrayLogarithmic",C,I),t.BoxAndWhiskers=g,t.Violin=b,t.ArrayLinearScale=B,t.ArrayLogarithmicScale=C,t.BoxPlot=N,t.HorizontalBoxPlot=P,t.HorizontalViolin=S,Object.defineProperty(t,"__esModule",{value:!0})});'
]

{ #category : #private }
ChartJsPluginBoxPlotLibrary >> github [
	
	^ 'https://github.com/datavisyn/chartjs-chart-box-and-violin-plot'
]

{ #category : #accessing }
ChartJsPluginBoxPlotLibrary >> selectorsToInclude [
	
	^ #(#chartBoxplotMinJs)
]

{ #category : #private }
ChartJsPluginBoxPlotLibrary >> version [
	
	^ '2.1.0'
]
