Class {
	#name : #ChartJsPluginDatalabelsLibrary,
	#superclass : #ChartJsPluginLibrary,
	#category : #'ChartJs-Library'
}

{ #category : #'uploaded metadata' }
ChartJsPluginDatalabelsLibrary >> chartjsPluginDatalabelsJs [
	
	^ WAFileLibraryResource
		filepath: 'chartjs-plugin-datalabels.js'
		mimeType: (WAMimeType main: 'application' sub: 'javascript')
		cacheDuration:
			(Duration
				days: 0
				hours: 0
				minutes: 30
				seconds: 0)
		contents: (GRDelayedSend receiver: self selector: #chartjsPluginDatalabelsJsContent)
]

{ #category : #uploaded }
ChartJsPluginDatalabelsLibrary >> chartjsPluginDatalabelsJsContent [
	
	^ '/*!
 * chartjs-plugin-datalabels v0.6.0
 * https://chartjs-plugin-datalabels.netlify.com
 * (c) 2019 Chart.js Contributors
 * Released under the MIT license
 */
(function (global, factory) {
typeof exports === ''object'' && typeof module !== ''undefined'' ? module.exports = factory(require(''chart.js'')) :
typeof define === ''function'' && define.amd ? define([''chart.js''], factory) :
(global = global || self, global.ChartDataLabels = factory(global.Chart));
}(this, function (Chart) { ''use strict'';

Chart = Chart && Chart.hasOwnProperty(''default'') ? Chart[''default''] : Chart;

var helpers = Chart.helpers;

var devicePixelRatio = (function() {
	if (typeof window !== ''undefined'') {
		if (window.devicePixelRatio) {
			return window.devicePixelRatio;
		}

		// devicePixelRatio is undefined on IE10
		// https://stackoverflow.com/a/20204180/8837887
		// https://github.com/chartjs/chartjs-plugin-datalabels/issues/85
		var screen = window.screen;
		if (screen) {
			return (screen.deviceXDPI || 1) / (screen.logicalXDPI || 1);
		}
	}

	return 1;
}());

var utils = {
	// @todo move this in Chart.helpers.toTextLines
	toTextLines: function(inputs) {
		var lines = [];
		var input;

		inputs = [].concat(inputs);
		while (inputs.length) {
			input = inputs.pop();
			if (typeof input === ''string'') {
				lines.unshift.apply(lines, input.split(''\n''));
			} else if (Array.isArray(input)) {
				inputs.push.apply(inputs, input);
			} else if (!helpers.isNullOrUndef(inputs)) {
				lines.unshift('''' + input);
			}
		}

		return lines;
	},

	// @todo move this method in Chart.helpers.canvas.toFont (deprecates helpers.fontString)
	// @see https://developer.mozilla.org/en-US/docs/Web/CSS/font
	toFontString: function(font) {
		if (!font || helpers.isNullOrUndef(font.size) || helpers.isNullOrUndef(font.family)) {
			return null;
		}

		return (font.style ? font.style + '' '' : '''')
			+ (font.weight ? font.weight + '' '' : '''')
			+ font.size + ''px ''
			+ font.family;
	},

	// @todo move this in Chart.helpers.canvas.textSize
	// @todo cache calls of measureText if font doesn''t change?!
	textSize: function(ctx, lines, font) {
		var items = [].concat(lines);
		var ilen = items.length;
		var prev = ctx.font;
		var width = 0;
		var i;

		ctx.font = font.string;

		for (i = 0; i < ilen; ++i) {
			width = Math.max(ctx.measureText(items[i]).width, width);
		}

		ctx.font = prev;

		return {
			height: ilen * font.lineHeight,
			width: width
		};
	},

	// @todo move this method in Chart.helpers.options.toFont
	parseFont: function(value) {
		var global = Chart.defaults.global;
		var size = helpers.valueOrDefault(value.size, global.defaultFontSize);
		var font = {
			family: helpers.valueOrDefault(value.family, global.defaultFontFamily),
			lineHeight: helpers.options.toLineHeight(value.lineHeight, size),
			size: size,
			style: helpers.valueOrDefault(value.style, global.defaultFontStyle),
			weight: helpers.valueOrDefault(value.weight, null),
			string: ''''
		};

		font.string = utils.toFontString(font);
		return font;
	},

	/**
	 * Returns value bounded by min and max. This is equivalent to max(min, min(value, max)).
	 * @todo move this method in Chart.helpers.bound
	 * https://doc.qt.io/qt-5/qtglobal.html#qBound
	 */
	bound: function(min, value, max) {
		return Math.max(min, Math.min(value, max));
	},

	/**
	 * Returns an array of pair [value, state] where state is:
	 * * -1: value is only in a0 (removed)
	 * *  1: value is only in a1 (added)
	 */
	arrayDiff: function(a0, a1) {
		var prev = a0.slice();
		var updates = [];
		var i, j, ilen, v;

		for (i = 0, ilen = a1.length; i < ilen; ++i) {
			v = a1[i];
			j = prev.indexOf(v);

			if (j === -1) {
				updates.push([v, 1]);
			} else {
				prev.splice(j, 1);
			}
		}

		for (i = 0, ilen = prev.length; i < ilen; ++i) {
			updates.push([prev[i], -1]);
		}

		return updates;
	},

	/**
	 * https://github.com/chartjs/chartjs-plugin-datalabels/issues/70
	 */
	rasterize: function(v) {
		return Math.round(v * devicePixelRatio) / devicePixelRatio;
	}
};

function orient(point, origin) {
	var x0 = origin.x;
	var y0 = origin.y;

	if (x0 === null) {
		return {x: 0, y: -1};
	}
	if (y0 === null) {
		return {x: 1, y: 0};
	}

	var dx = point.x - x0;
	var dy = point.y - y0;
	var ln = Math.sqrt(dx * dx + dy * dy);

	return {
		x: ln ? dx / ln : 0,
		y: ln ? dy / ln : -1
	};
}

function aligned(x, y, vx, vy, align) {
	switch (align) {
	case ''center'':
		vx = vy = 0;
		break;
	case ''bottom'':
		vx = 0;
		vy = 1;
		break;
	case ''right'':
		vx = 1;
		vy = 0;
		break;
	case ''left'':
		vx = -1;
		vy = 0;
		break;
	case ''top'':
		vx = 0;
		vy = -1;
		break;
	case ''start'':
		vx = -vx;
		vy = -vy;
		break;
	case ''end'':
		// keep natural orientation
		break;
	default:
		// clockwise rotation (in degree)
		align *= (Math.PI / 180);
		vx = Math.cos(align);
		vy = Math.sin(align);
		break;
	}

	return {
		x: x,
		y: y,
		vx: vx,
		vy: vy
	};
}

// Line clipping (Cohenâ€“Sutherland algorithm)
// https://en.wikipedia.org/wiki/Cohenâ€“Sutherland_algorithm

var R_INSIDE = 0;
var R_LEFT = 1;
var R_RIGHT = 2;
var R_BOTTOM = 4;
var R_TOP = 8;

function region(x, y, rect) {
	var res = R_INSIDE;

	if (x < rect.left) {
		res |= R_LEFT;
	} else if (x > rect.right) {
		res |= R_RIGHT;
	}
	if (y < rect.top) {
		res |= R_TOP;
	} else if (y > rect.bottom) {
		res |= R_BOTTOM;
	}

	return res;
}

function clipped(segment, area) {
	var x0 = segment.x0;
	var y0 = segment.y0;
	var x1 = segment.x1;
	var y1 = segment.y1;
	var r0 = region(x0, y0, area);
	var r1 = region(x1, y1, area);
	var r, x, y;

	// eslint-disable-next-line no-constant-condition
	while (true) {
		if (!(r0 | r1) || (r0 & r1)) {
			// both points inside or on the same side: no clipping
			break;
		}

		// at least one point is outside
		r = r0 || r1;

		if (r & R_TOP) {
			x = x0 + (x1 - x0) * (area.top - y0) / (y1 - y0);
			y = area.top;
		} else if (r & R_BOTTOM) {
			x = x0 + (x1 - x0) * (area.bottom - y0) / (y1 - y0);
			y = area.bottom;
		} else if (r & R_RIGHT) {
			y = y0 + (y1 - y0) * (area.right - x0) / (x1 - x0);
			x = area.right;
		} else if (r & R_LEFT) {
			y = y0 + (y1 - y0) * (area.left - x0) / (x1 - x0);
			x = area.left;
		}

		if (r === r0) {
			x0 = x;
			y0 = y;
			r0 = region(x0, y0, area);
		} else {
			x1 = x;
			y1 = y;
			r1 = region(x1, y1, area);
		}
	}

	return {
		x0: x0,
		x1: x1,
		y0: y0,
		y1: y1
	};
}

function compute(range, config) {
	var anchor = config.anchor;
	var segment = range;
	var x, y;

	if (config.clamp) {
		segment = clipped(segment, config.area);
	}

	if (anchor === ''start'') {
		x = segment.x0;
		y = segment.y0;
	} else if (anchor === ''end'') {
		x = segment.x1;
		y = segment.y1;
	} else {
		x = (segment.x0 + segment.x1) / 2;
		y = (segment.y0 + segment.y1) / 2;
	}

	return aligned(x, y, range.vx, range.vy, config.align);
}

var positioners = {
	arc: function(vm, config) {
		var angle = (vm.startAngle + vm.endAngle) / 2;
		var vx = Math.cos(angle);
		var vy = Math.sin(angle);
		var r0 = vm.innerRadius;
		var r1 = vm.outerRadius;

		return compute({
			x0: vm.x + vx * r0,
			y0: vm.y + vy * r0,
			x1: vm.x + vx * r1,
			y1: vm.y + vy * r1,
			vx: vx,
			vy: vy
		}, config);
	},

	point: function(vm, config) {
		var v = orient(vm, config.origin);
		var rx = v.x * vm.radius;
		var ry = v.y * vm.radius;

		return compute({
			x0: vm.x - rx,
			y0: vm.y - ry,
			x1: vm.x + rx,
			y1: vm.y + ry,
			vx: v.x,
			vy: v.y
		}, config);
	},

	rect: function(vm, config) {
		var v = orient(vm, config.origin);
		var x = vm.x;
		var y = vm.y;
		var sx = 0;
		var sy = 0;

		if (vm.horizontal) {
			x = Math.min(vm.x, vm.base);
			sx = Math.abs(vm.base - vm.x);
		} else {
			y = Math.min(vm.y, vm.base);
			sy = Math.abs(vm.base - vm.y);
		}

		return compute({
			x0: x,
			y0: y + sy,
			x1: x + sx,
			y1: y,
			vx: v.x,
			vy: v.y
		}, config);
	},

	fallback: function(vm, config) {
		var v = orient(vm, config.origin);

		return compute({
			x0: vm.x,
			y0: vm.y,
			x1: vm.x,
			y1: vm.y,
			vx: v.x,
			vy: v.y
		}, config);
	}
};

var helpers$1 = Chart.helpers;
var rasterize = utils.rasterize;

function boundingRects(model) {
	var borderWidth = model.borderWidth || 0;
	var padding = model.padding;
	var th = model.size.height;
	var tw = model.size.width;
	var tx = -tw / 2;
	var ty = -th / 2;

	return {
		frame: {
			x: tx - padding.left - borderWidth,
			y: ty - padding.top - borderWidth,
			w: tw + padding.width + borderWidth * 2,
			h: th + padding.height + borderWidth * 2
		},
		text: {
			x: tx,
			y: ty,
			w: tw,
			h: th
		}
	};
}

function getScaleOrigin(el) {
	var horizontal = el._model.horizontal;
	var scale = el._scale || (horizontal && el._xScale) || el._yScale;

	if (!scale) {
		return null;
	}

	if (scale.xCenter !== undefined && scale.yCenter !== undefined) {
		return {x: scale.xCenter, y: scale.yCenter};
	}

	var pixel = scale.getBasePixel();
	return horizontal ?
		{x: pixel, y: null} :
		{x: null, y: pixel};
}

function getPositioner(el) {
	if (el instanceof Chart.elements.Arc) {
		return positioners.arc;
	}
	if (el instanceof Chart.elements.Point) {
		return positioners.point;
	}
	if (el instanceof Chart.elements.Rectangle) {
		return positioners.rect;
	}
	return positioners.fallback;
}

function drawFrame(ctx, rect, model) {
	var bgColor = model.backgroundColor;
	var borderColor = model.borderColor;
	var borderWidth = model.borderWidth;

	if (!bgColor && (!borderColor || !borderWidth)) {
		return;
	}

	ctx.beginPath();

	helpers$1.canvas.roundedRect(
		ctx,
		rasterize(rect.x) + borderWidth / 2,
		rasterize(rect.y) + borderWidth / 2,
		rasterize(rect.w) - borderWidth,
		rasterize(rect.h) - borderWidth,
		model.borderRadius);

	ctx.closePath();

	if (bgColor) {
		ctx.fillStyle = bgColor;
		ctx.fill();
	}

	if (borderColor && borderWidth) {
		ctx.strokeStyle = borderColor;
		ctx.lineWidth = borderWidth;
		ctx.lineJoin = ''miter'';
		ctx.stroke();
	}
}

function textGeometry(rect, align, font) {
	var h = font.lineHeight;
	var w = rect.w;
	var x = rect.x;
	var y = rect.y + h / 2;

	if (align === ''center'') {
		x += w / 2;
	} else if (align === ''end'' || align === ''right'') {
		x += w;
	}

	return {
		h: h,
		w: w,
		x: x,
		y: y
	};
}

function drawTextLine(ctx, text, cfg) {
	var shadow = ctx.shadowBlur;
	var stroked = cfg.stroked;
	var x = rasterize(cfg.x);
	var y = rasterize(cfg.y);
	var w = rasterize(cfg.w);

	if (stroked) {
		ctx.strokeText(text, x, y, w);
	}

	if (cfg.filled) {
		if (shadow && stroked) {
			// Prevent drawing shadow on both the text stroke and fill, so
			// if the text is stroked, remove the shadow for the text fill.
			ctx.shadowBlur = 0;
		}

		ctx.fillText(text, x, y, w);

		if (shadow && stroked) {
			ctx.shadowBlur = shadow;
		}
	}
}

function drawText(ctx, lines, rect, model) {
	var align = model.textAlign;
	var color = model.color;
	var filled = !!color;
	var font = model.font;
	var ilen = lines.length;
	var strokeColor = model.textStrokeColor;
	var strokeWidth = model.textStrokeWidth;
	var stroked = strokeColor && strokeWidth;
	var i;

	if (!ilen || (!filled && !stroked)) {
		return;
	}

	// Adjust coordinates based on text alignment and line height
	rect = textGeometry(rect, align, font);

	ctx.font = font.string;
	ctx.textAlign = align;
	ctx.textBaseline = ''middle'';
	ctx.shadowBlur = model.textShadowBlur;
	ctx.shadowColor = model.textShadowColor;

	if (filled) {
		ctx.fillStyle = color;
	}
	if (stroked) {
		ctx.lineJoin = ''round'';
		ctx.lineWidth = strokeWidth;
		ctx.strokeStyle = strokeColor;
	}

	for (i = 0, ilen = lines.length; i < ilen; ++i) {
		drawTextLine(ctx, lines[i], {
			stroked: stroked,
			filled: filled,
			w: rect.w,
			x: rect.x,
			y: rect.y + rect.h * i
		});
	}
}

var Label = function(config, ctx, el, index) {
	var me = this;

	me._config = config;
	me._index = index;
	me._model = null;
	me._rects = null;
	me._ctx = ctx;
	me._el = el;
};

helpers$1.extend(Label.prototype, {
	/**
	 * @private
	 */
	_modelize: function(display, lines, config, context) {
		var me = this;
		var index = me._index;
		var resolve = helpers$1.options.resolve;
		var font = utils.parseFont(resolve([config.font, {}], context, index));
		var color = resolve([config.color, Chart.defaults.global.defaultFontColor], context, index);

		return {
			align: resolve([config.align, ''center''], context, index),
			anchor: resolve([config.anchor, ''center''], context, index),
			area: context.chart.chartArea,
			backgroundColor: resolve([config.backgroundColor, null], context, index),
			borderColor: resolve([config.borderColor, null], context, index),
			borderRadius: resolve([config.borderRadius, 0], context, index),
			borderWidth: resolve([config.borderWidth, 0], context, index),
			clamp: resolve([config.clamp, false], context, index),
			clip: resolve([config.clip, false], context, index),
			color: color,
			display: display,
			font: font,
			lines: lines,
			offset: resolve([config.offset, 0], context, index),
			opacity: resolve([config.opacity, 1], context, index),
			origin: getScaleOrigin(me._el),
			padding: helpers$1.options.toPadding(resolve([config.padding, 0], context, index)),
			positioner: getPositioner(me._el),
			rotation: resolve([config.rotation, 0], context, index) * (Math.PI / 180),
			size: utils.textSize(me._ctx, lines, font),
			textAlign: resolve([config.textAlign, ''start''], context, index),
			textShadowBlur: resolve([config.textShadowBlur, 0], context, index),
			textShadowColor: resolve([config.textShadowColor, color], context, index),
			textStrokeColor: resolve([config.textStrokeColor, color], context, index),
			textStrokeWidth: resolve([config.textStrokeWidth, 0], context, index)
		};
	},

	update: function(context) {
		var me = this;
		var model = null;
		var rects = null;
		var index = me._index;
		var config = me._config;
		var value, label, lines;

		// We first resolve the display option (separately) to avoid computing
		// other options in case the label is hidden (i.e. display: false).
		var display = helpers$1.options.resolve([config.display, true], context, index);

		if (display) {
			value = context.dataset.data[index];
			label = helpers$1.valueOrDefault(helpers$1.callback(config.formatter, [value, context]), value);
			lines = helpers$1.isNullOrUndef(label) ? [] : utils.toTextLines(label);

			if (lines.length) {
				model = me._modelize(display, lines, config, context);
				rects = boundingRects(model);
			}
		}

		me._model = model;
		me._rects = rects;
	},

	geometry: function() {
		return this._rects ? this._rects.frame : {};
	},

	rotation: function() {
		return this._model ? this._model.rotation : 0;
	},

	visible: function() {
		return this._model && this._model.opacity;
	},

	model: function() {
		return this._model;
	},

	draw: function(chart, center) {
		var me = this;
		var ctx = chart.ctx;
		var model = me._model;
		var rects = me._rects;
		var area;

		if (!this.visible()) {
			return;
		}

		ctx.save();

		if (model.clip) {
			area = model.area;
			ctx.beginPath();
			ctx.rect(
				area.left,
				area.top,
				area.right - area.left,
				area.bottom - area.top);
			ctx.clip();
		}

		ctx.globalAlpha = utils.bound(0, model.opacity, 1);
		ctx.translate(rasterize(center.x), rasterize(center.y));
		ctx.rotate(model.rotation);

		drawFrame(ctx, rects.frame, model);
		drawText(ctx, model.lines, rects.text, model);

		ctx.restore();
	}
});

var helpers$2 = Chart.helpers;

var MIN_INTEGER = Number.MIN_SAFE_INTEGER || -9007199254740991;
var MAX_INTEGER = Number.MAX_SAFE_INTEGER || 9007199254740991;

function rotated(point, center, angle) {
	var cos = Math.cos(angle);
	var sin = Math.sin(angle);
	var cx = center.x;
	var cy = center.y;

	return {
		x: cx + cos * (point.x - cx) - sin * (point.y - cy),
		y: cy + sin * (point.x - cx) + cos * (point.y - cy)
	};
}

function projected(points, axis) {
	var min = MAX_INTEGER;
	var max = MIN_INTEGER;
	var origin = axis.origin;
	var i, pt, vx, vy, dp;

	for (i = 0; i < points.length; ++i) {
		pt = points[i];
		vx = pt.x - origin.x;
		vy = pt.y - origin.y;
		dp = axis.vx * vx + axis.vy * vy;
		min = Math.min(min, dp);
		max = Math.max(max, dp);
	}

	return {
		min: min,
		max: max
	};
}

function toAxis(p0, p1) {
	var vx = p1.x - p0.x;
	var vy = p1.y - p0.y;
	var ln = Math.sqrt(vx * vx + vy * vy);

	return {
		vx: (p1.x - p0.x) / ln,
		vy: (p1.y - p0.y) / ln,
		origin: p0,
		ln: ln
	};
}

var HitBox = function() {
	this._rotation = 0;
	this._rect = {
		x: 0,
		y: 0,
		w: 0,
		h: 0
	};
};

helpers$2.extend(HitBox.prototype, {
	center: function() {
		var r = this._rect;
		return {
			x: r.x + r.w / 2,
			y: r.y + r.h / 2
		};
	},

	update: function(center, rect, rotation) {
		this._rotation = rotation;
		this._rect = {
			x: rect.x + center.x,
			y: rect.y + center.y,
			w: rect.w,
			h: rect.h
		};
	},

	contains: function(point) {
		var me = this;
		var margin = 1;
		var rect = me._rect;

		point = rotated(point, me.center(), -me._rotation);

		return !(point.x < rect.x - margin
			|| point.y < rect.y - margin
			|| point.x > rect.x + rect.w + margin * 2
			|| point.y > rect.y + rect.h + margin * 2);
	},

	// Separating Axis Theorem
	// https://gamedevelopment.tutsplus.com/tutorials/collision-detection-using-the-separating-axis-theorem--gamedev-169
	intersects: function(other) {
		var r0 = this._points();
		var r1 = other._points();
		var axes = [
			toAxis(r0[0], r0[1]),
			toAxis(r0[0], r0[3])
		];
		var i, pr0, pr1;

		if (this._rotation !== other._rotation) {
			// Only separate with r1 axis if the rotation is different,
			// else it''s enough to separate r0 and r1 with r0 axis only!
			axes.push(
				toAxis(r1[0], r1[1]),
				toAxis(r1[0], r1[3])
			);
		}

		for (i = 0; i < axes.length; ++i) {
			pr0 = projected(r0, axes[i]);
			pr1 = projected(r1, axes[i]);

			if (pr0.max < pr1.min || pr1.max < pr0.min) {
				return false;
			}
		}

		return true;
	},

	/**
	 * @private
	 */
	_points: function() {
		var me = this;
		var rect = me._rect;
		var angle = me._rotation;
		var center = me.center();

		return [
			rotated({x: rect.x, y: rect.y}, center, angle),
			rotated({x: rect.x + rect.w, y: rect.y}, center, angle),
			rotated({x: rect.x + rect.w, y: rect.y + rect.h}, center, angle),
			rotated({x: rect.x, y: rect.y + rect.h}, center, angle)
		];
	}
});

function coordinates(view, model, geometry) {
	var point = model.positioner(view, model);
	var vx = point.vx;
	var vy = point.vy;

	if (!vx && !vy) {
		// if aligned center, we don''t want to offset the center point
		return {x: point.x, y: point.y};
	}

	var w = geometry.w;
	var h = geometry.h;

	// take in account the label rotation
	var rotation = model.rotation;
	var dx = Math.abs(w / 2 * Math.cos(rotation)) + Math.abs(h / 2 * Math.sin(rotation));
	var dy = Math.abs(w / 2 * Math.sin(rotation)) + Math.abs(h / 2 * Math.cos(rotation));

	// scale the unit vector (vx, vy) to get at least dx or dy equal to
	// w or h respectively (else we would calculate the distance to the
	// ellipse inscribed in the bounding rect)
	var vs = 1 / Math.max(Math.abs(vx), Math.abs(vy));
	dx *= vx * vs;
	dy *= vy * vs;

	// finally, include the explicit offset
	dx += model.offset * vx;
	dy += model.offset * vy;

	return {
		x: point.x + dx,
		y: point.y + dy
	};
}

function collide(labels, collider) {
	var i, j, s0, s1;

	// IMPORTANT Iterate in the reverse order since items at the end of the
	// list have an higher weight/priority and thus should be less impacted
	// by the overlapping strategy.

	for (i = labels.length - 1; i >= 0; --i) {
		s0 = labels[i].$layout;

		for (j = i - 1; j >= 0 && s0._visible; --j) {
			s1 = labels[j].$layout;

			if (s1._visible && s0._box.intersects(s1._box)) {
				collider(s0, s1);
			}
		}
	}

	return labels;
}

function compute$1(labels) {
	var i, ilen, label, state, geometry, center;

	// Initialize labels for overlap detection
	for (i = 0, ilen = labels.length; i < ilen; ++i) {
		label = labels[i];
		state = label.$layout;

		if (state._visible) {
			geometry = label.geometry();
			center = coordinates(label._el._model, label.model(), geometry);
			state._box.update(center, geometry, label.rotation());
		}
	}

	// Auto hide overlapping labels
	return collide(labels, function(s0, s1) {
		var h0 = s0._hidable;
		var h1 = s1._hidable;

		if ((h0 && h1) || h1) {
			s1._visible = false;
		} else if (h0) {
			s0._visible = false;
		}
	});
}

var layout = {
	prepare: function(datasets) {
		var labels = [];
		var i, j, ilen, jlen, label;

		for (i = 0, ilen = datasets.length; i < ilen; ++i) {
			for (j = 0, jlen = datasets[i].length; j < jlen; ++j) {
				label = datasets[i][j];
				labels.push(label);
				label.$layout = {
					_box: new HitBox(),
					_hidable: false,
					_visible: true,
					_set: i,
					_idx: j
				};
			}
		}

		// TODO New `z` option: labels with a higher z-index are drawn
		// of top of the ones with a lower index. Lowest z-index labels
		// are also discarded first when hiding overlapping labels.
		labels.sort(function(a, b) {
			var sa = a.$layout;
			var sb = b.$layout;

			return sa._idx === sb._idx
				? sa._set - sb._set
				: sb._idx - sa._idx;
		});

		this.update(labels);

		return labels;
	},

	update: function(labels) {
		var dirty = false;
		var i, ilen, label, model, state;

		for (i = 0, ilen = labels.length; i < ilen; ++i) {
			label = labels[i];
			model = label.model();
			state = label.$layout;
			state._hidable = model && model.display === ''auto'';
			state._visible = label.visible();
			dirty |= state._hidable;
		}

		if (dirty) {
			compute$1(labels);
		}
	},

	lookup: function(labels, point) {
		var i, state;

		// IMPORTANT Iterate in the reverse order since items at the end of
		// the list have an higher z-index, thus should be picked first.

		for (i = labels.length - 1; i >= 0; --i) {
			state = labels[i].$layout;

			if (state && state._visible && state._box.contains(point)) {
				return {
					dataset: state._set,
					label: labels[i]
				};
			}
		}

		return null;
	},

	draw: function(chart, labels) {
		var i, ilen, label, state, geometry, center;

		for (i = 0, ilen = labels.length; i < ilen; ++i) {
			label = labels[i];
			state = label.$layout;

			if (state._visible) {
				geometry = label.geometry();
				center = coordinates(label._el._view, label.model(), geometry);
				state._box.update(center, geometry, label.rotation());
				label.draw(chart, center);
			}
		}
	}
};

var helpers$3 = Chart.helpers;

var formatter = function(value) {
	if (helpers$3.isNullOrUndef(value)) {
		return null;
	}

	var label = value;
	var keys, klen, k;
	if (helpers$3.isObject(value)) {
		if (!helpers$3.isNullOrUndef(value.label)) {
			label = value.label;
		} else if (!helpers$3.isNullOrUndef(value.r)) {
			label = value.r;
		} else {
			label = '''';
			keys = Object.keys(value);
			for (k = 0, klen = keys.length; k < klen; ++k) {
				label += (k !== 0 ? '', '' : '''') + keys[k] + '': '' + value[keys[k]];
			}
		}
	}

	return '''' + label;
};

/**
 * IMPORTANT: make sure to also update tests and TypeScript definition
 * files (`/test/specs/defaults.spec.js` and `/types/options.d.ts`)
 */

var defaults = {
	align: ''center'',
	anchor: ''center'',
	backgroundColor: null,
	borderColor: null,
	borderRadius: 0,
	borderWidth: 0,
	clamp: false,
	clip: false,
	color: undefined,
	display: true,
	font: {
		family: undefined,
		lineHeight: 1.2,
		size: undefined,
		style: undefined,
		weight: null
	},
	formatter: formatter,
	listeners: {},
	offset: 4,
	opacity: 1,
	padding: {
		top: 4,
		right: 4,
		bottom: 4,
		left: 4
	},
	rotation: 0,
	textAlign: ''start'',
	textStrokeColor: undefined,
	textStrokeWidth: 0,
	textShadowBlur: 0,
	textShadowColor: undefined
};

/**
 * @see https://github.com/chartjs/Chart.js/issues/4176
 */

var helpers$4 = Chart.helpers;
var EXPANDO_KEY = ''$datalabels'';

function configure(dataset, options) {
	var override = dataset.datalabels;
	var config = {};

	if (override === false) {
		return null;
	}
	if (override === true) {
		override = {};
	}

	return helpers$4.merge(config, [options, override]);
}

function dispatchEvent(chart, listeners, target) {
	var callback = listeners && listeners[target.dataset];
	if (!callback) {
		return;
	}

	var label = target.label;
	var context = label.$context;

	if (helpers$4.callback(callback, [context]) === true) {
		// Users are allowed to tweak the given context by injecting values that can be
		// used in scriptable options to display labels differently based on the current
		// event (e.g. highlight an hovered label). That''s why we update the label with
		// the output context and schedule a new chart render by setting it dirty.
		chart[EXPANDO_KEY]._dirty = true;
		label.update(context);
	}
}

function dispatchMoveEvents(chart, listeners, previous, target) {
	var enter, leave;

	if (!previous && !target) {
		return;
	}

	if (!previous) {
		enter = true;
	} else if (!target) {
		leave = true;
	} else if (previous.label !== target.label) {
		leave = enter = true;
	}

	if (leave) {
		dispatchEvent(chart, listeners.leave, previous);
	}
	if (enter) {
		dispatchEvent(chart, listeners.enter, target);
	}
}

function handleMoveEvents(chart, event) {
	var expando = chart[EXPANDO_KEY];
	var listeners = expando._listeners;
	var previous, target;

	if (!listeners.enter && !listeners.leave) {
		return;
	}

	if (event.type === ''mousemove'') {
		target = layout.lookup(expando._labels, event);
	} else if (event.type !== ''mouseout'') {
		return;
	}

	previous = expando._hovered;
	expando._hovered = target;
	dispatchMoveEvents(chart, listeners, previous, target);
}

function handleClickEvents(chart, event) {
	var expando = chart[EXPANDO_KEY];
	var handlers = expando._listeners.click;
	var target = handlers && layout.lookup(expando._labels, event);
	if (target) {
		dispatchEvent(chart, handlers, target);
	}
}

// https://github.com/chartjs/chartjs-plugin-datalabels/issues/108
function invalidate(chart) {
	if (chart.animating) {
		return;
	}

	// `chart.animating` can be `false` even if there is animation in progress,
	// so let''s iterate all animations to find if there is one for the `chart`.
	var animations = Chart.animationService.animations;
	for (var i = 0, ilen = animations.length; i < ilen; ++i) {
		if (animations[i].chart === chart) {
			return;
		}
	}

	// No render scheduled: trigger a "lazy" render that can be canceled in case
	// of hover interactions. The 1ms duration is a workaround to make sure an
	// animation is created so the controller can stop it before any transition.
	chart.render({duration: 1, lazy: true});
}

Chart.defaults.global.plugins.datalabels = defaults;

var plugin = {
	id: ''datalabels'',

	beforeInit: function(chart) {
		chart[EXPANDO_KEY] = {
			_actives: []
		};
	},

	beforeUpdate: function(chart) {
		var expando = chart[EXPANDO_KEY];
		expando._listened = false;
		expando._listeners = {};     // {event-type: {dataset-index: function}}
		expando._datasets = [];      // per dataset labels: [[Label]]
		expando._labels = [];        // layouted labels: [Label]
	},

	afterDatasetUpdate: function(chart, args, options) {
		var datasetIndex = args.index;
		var expando = chart[EXPANDO_KEY];
		var labels = expando._datasets[datasetIndex] = [];
		var visible = chart.isDatasetVisible(datasetIndex);
		var dataset = chart.data.datasets[datasetIndex];
		var config = configure(dataset, options);
		var elements = args.meta.data || [];
		var ilen = elements.length;
		var ctx = chart.ctx;
		var i, el, label;

		ctx.save();

		for (i = 0; i < ilen; ++i) {
			el = elements[i];

			if (visible && el && !el.hidden && !el._model.skip) {
				labels.push(label = new Label(config, ctx, el, i));
				label.update(label.$context = {
					active: false,
					chart: chart,
					dataIndex: i,
					dataset: dataset,
					datasetIndex: datasetIndex
				});
			} else {
				label = null;
			}

			el[EXPANDO_KEY] = label;
		}

		ctx.restore();

		// Store listeners at the chart level and per event type to optimize
		// cases where no listeners are registered for a specific event
		helpers$4.merge(expando._listeners, config.listeners || {}, {
			merger: function(key, target, source) {
				target[key] = target[key] || {};
				target[key][args.index] = source[key];
				expando._listened = true;
			}
		});
	},

	afterUpdate: function(chart, options) {
		chart[EXPANDO_KEY]._labels = layout.prepare(
			chart[EXPANDO_KEY]._datasets,
			options);
	},

	// Draw labels on top of all dataset elements
	// https://github.com/chartjs/chartjs-plugin-datalabels/issues/29
	// https://github.com/chartjs/chartjs-plugin-datalabels/issues/32
	afterDatasetsDraw: function(chart) {
		layout.draw(chart, chart[EXPANDO_KEY]._labels);
	},

	beforeEvent: function(chart, event) {
		// If there is no listener registered for this chart, `listened` will be false,
		// meaning we can immediately ignore the incoming event and avoid useless extra
		// computation for users who don''t implement label interactions.
		if (chart[EXPANDO_KEY]._listened) {
			switch (event.type) {
			case ''mousemove'':
			case ''mouseout'':
				handleMoveEvents(chart, event);
				break;
			case ''click'':
				handleClickEvents(chart, event);
				break;
			default:
			}
		}
	},

	afterEvent: function(chart) {
		var expando = chart[EXPANDO_KEY];
		var previous = expando._actives;
		var actives = expando._actives = chart.lastActive || [];  // public API?!
		var updates = utils.arrayDiff(previous, actives);
		var i, ilen, update, label;

		for (i = 0, ilen = updates.length; i < ilen; ++i) {
			update = updates[i];
			if (update[1]) {
				label = update[0][EXPANDO_KEY];
				if (label) {
					label.$context.active = (update[1] === 1);
					label.update(label.$context);
				}
			}
		}

		if (expando._dirty || updates.length) {
			layout.update(expando._labels);
			invalidate(chart);
		}

		delete expando._dirty;
	}
};

// TODO Remove at version 1, we shouldn''t automatically register plugins.
// https://github.com/chartjs/chartjs-plugin-datalabels/issues/42
Chart.plugins.register(plugin);

return plugin;

}));
'
]

{ #category : #'uploaded metadata' }
ChartJsPluginDatalabelsLibrary >> chartjsPluginDatalabelsMinJs [
	
	^ WAFileLibraryResource
		filepath: 'chartjs-plugin-datalabels.min.js'
		mimeType: (WAMimeType main: 'application' sub: 'javascript')
		cacheDuration:
			(Duration
				days: 0
				hours: 0
				minutes: 30
				seconds: 0)
		contents: (GRDelayedSend receiver: self selector: #chartjsPluginDatalabelsMinJsContent)
]

{ #category : #uploaded }
ChartJsPluginDatalabelsLibrary >> chartjsPluginDatalabelsMinJsContent [
	
	^ '/*!
 * chartjs-plugin-datalabels v0.6.0
 * https://chartjs-plugin-datalabels.netlify.com
 * (c) 2019 Chart.js Contributors
 * Released under the MIT license
 */
!function(t,e){"object"==typeof exports&&"undefined"!=typeof module?module.exports=e(require("chart.js")):"function"==typeof define&&define.amd?define(["chart.js"],e):(t=t||self).ChartDataLabels=e(t.Chart)}(this,function(t){"use strict";var e=(t=t&&t.hasOwnProperty("default")?t.default:t).helpers,r=function(){if("undefined"!=typeof window){if(window.devicePixelRatio)return window.devicePixelRatio;var t=window.screen;if(t)return(t.deviceXDPI||1)/(t.logicalXDPI||1)}return 1}(),n={toTextLines:function(t){var r,n=[];for(t=[].concat(t);t.length;)"string"==typeof(r=t.pop())?n.unshift.apply(n,r.split("\n")):Array.isArray(r)?t.push.apply(t,r):e.isNullOrUndef(t)||n.unshift(""+r);return n},toFontString:function(t){return!t||e.isNullOrUndef(t.size)||e.isNullOrUndef(t.family)?null:(t.style?t.style+" ":"")+(t.weight?t.weight+" ":"")+t.size+"px "+t.family},textSize:function(t,e,r){var n,i=[].concat(e),a=i.length,o=t.font,l=0;for(t.font=r.string,n=0;n<a;++n)l=Math.max(t.measureText(i[n]).width,l);return t.font=o,{height:a*r.lineHeight,width:l}},parseFont:function(r){var i=t.defaults.global,a=e.valueOrDefault(r.size,i.defaultFontSize),o={family:e.valueOrDefault(r.family,i.defaultFontFamily),lineHeight:e.options.toLineHeight(r.lineHeight,a),size:a,style:e.valueOrDefault(r.style,i.defaultFontStyle),weight:e.valueOrDefault(r.weight,null),string:""};return o.string=n.toFontString(o),o},bound:function(t,e,r){return Math.max(t,Math.min(e,r))},arrayDiff:function(t,e){var r,n,i,a,o=t.slice(),l=[];for(r=0,i=e.length;r<i;++r)a=e[r],-1===(n=o.indexOf(a))?l.push([a,1]):o.splice(n,1);for(r=0,i=o.length;r<i;++r)l.push([o[r],-1]);return l},rasterize:function(t){return Math.round(t*r)/r}};function i(t,e){var r=e.x,n=e.y;if(null===r)return{x:0,y:-1};if(null===n)return{x:1,y:0};var i=t.x-r,a=t.y-n,o=Math.sqrt(i*i+a*a);return{x:o?i/o:0,y:o?a/o:-1}}var a=0,o=1,l=2,s=4,u=8;function d(t,e,r){var n=a;return t<r.left?n|=o:t>r.right&&(n|=l),e<r.top?n|=u:e>r.bottom&&(n|=s),n}function f(t,e){var r,n,i=e.anchor,a=t;return e.clamp&&(a=function(t,e){for(var r,n,i,a=t.x0,f=t.y0,c=t.x1,h=t.y1,x=d(a,f,e),y=d(c,h,e);x|y&&!(x&y);)(r=x||y)&u?(n=a+(c-a)*(e.top-f)/(h-f),i=e.top):r&s?(n=a+(c-a)*(e.bottom-f)/(h-f),i=e.bottom):r&l?(i=f+(h-f)*(e.right-a)/(c-a),n=e.right):r&o&&(i=f+(h-f)*(e.left-a)/(c-a),n=e.left),r===x?x=d(a=n,f=i,e):y=d(c=n,h=i,e);return{x0:a,x1:c,y0:f,y1:h}}(a,e.area)),"start"===i?(r=a.x0,n=a.y0):"end"===i?(r=a.x1,n=a.y1):(r=(a.x0+a.x1)/2,n=(a.y0+a.y1)/2),function(t,e,r,n,i){switch(i){case"center":r=n=0;break;case"bottom":r=0,n=1;break;case"right":r=1,n=0;break;case"left":r=-1,n=0;break;case"top":r=0,n=-1;break;case"start":r=-r,n=-n;break;case"end":break;default:i*=Math.PI/180,r=Math.cos(i),n=Math.sin(i)}return{x:t,y:e,vx:r,vy:n}}(r,n,t.vx,t.vy,e.align)}var c={arc:function(t,e){var r=(t.startAngle+t.endAngle)/2,n=Math.cos(r),i=Math.sin(r),a=t.innerRadius,o=t.outerRadius;return f({x0:t.x+n*a,y0:t.y+i*a,x1:t.x+n*o,y1:t.y+i*o,vx:n,vy:i},e)},point:function(t,e){var r=i(t,e.origin),n=r.x*t.radius,a=r.y*t.radius;return f({x0:t.x-n,y0:t.y-a,x1:t.x+n,y1:t.y+a,vx:r.x,vy:r.y},e)},rect:function(t,e){var r=i(t,e.origin),n=t.x,a=t.y,o=0,l=0;return t.horizontal?(n=Math.min(t.x,t.base),o=Math.abs(t.base-t.x)):(a=Math.min(t.y,t.base),l=Math.abs(t.base-t.y)),f({x0:n,y0:a+l,x1:n+o,y1:a,vx:r.x,vy:r.y},e)},fallback:function(t,e){var r=i(t,e.origin);return f({x0:t.x,y0:t.y,x1:t.x,y1:t.y,vx:r.x,vy:r.y},e)}},h=t.helpers,x=n.rasterize;function y(t){var e=t._model.horizontal,r=t._scale||e&&t._xScale||t._yScale;if(!r)return null;if(void 0!==r.xCenter&&void 0!==r.yCenter)return{x:r.xCenter,y:r.yCenter};var n=r.getBasePixel();return e?{x:n,y:null}:{x:null,y:n}}function v(t,e,r){var n=t.shadowBlur,i=r.stroked,a=x(r.x),o=x(r.y),l=x(r.w);i&&t.strokeText(e,a,o,l),r.filled&&(n&&i&&(t.shadowBlur=0),t.fillText(e,a,o,l),n&&i&&(t.shadowBlur=n))}var _=function(t,e,r,n){var i=this;i._config=t,i._index=n,i._model=null,i._rects=null,i._ctx=e,i._el=r};h.extend(_.prototype,{_modelize:function(e,r,i,a){var o,l=this._index,s=h.options.resolve,u=n.parseFont(s([i.font,{}],a,l)),d=s([i.color,t.defaults.global.defaultFontColor],a,l);return{align:s([i.align,"center"],a,l),anchor:s([i.anchor,"center"],a,l),area:a.chart.chartArea,backgroundColor:s([i.backgroundColor,null],a,l),borderColor:s([i.borderColor,null],a,l),borderRadius:s([i.borderRadius,0],a,l),borderWidth:s([i.borderWidth,0],a,l),clamp:s([i.clamp,!1],a,l),clip:s([i.clip,!1],a,l),color:d,display:e,font:u,lines:r,offset:s([i.offset,0],a,l),opacity:s([i.opacity,1],a,l),origin:y(this._el),padding:h.options.toPadding(s([i.padding,0],a,l)),positioner:(o=this._el,o instanceof t.elements.Arc?c.arc:o instanceof t.elements.Point?c.point:o instanceof t.elements.Rectangle?c.rect:c.fallback),rotation:s([i.rotation,0],a,l)*(Math.PI/180),size:n.textSize(this._ctx,r,u),textAlign:s([i.textAlign,"start"],a,l),textShadowBlur:s([i.textShadowBlur,0],a,l),textShadowColor:s([i.textShadowColor,d],a,l),textStrokeColor:s([i.textStrokeColor,d],a,l),textStrokeWidth:s([i.textStrokeWidth,0],a,l)}},update:function(t){var e,r,i,a=this,o=null,l=null,s=a._index,u=a._config,d=h.options.resolve([u.display,!0],t,s);d&&(e=t.dataset.data[s],r=h.valueOrDefault(h.callback(u.formatter,[e,t]),e),(i=h.isNullOrUndef(r)?[]:n.toTextLines(r)).length&&(l=function(t){var e=t.borderWidth||0,r=t.padding,n=t.size.height,i=t.size.width,a=-i/2,o=-n/2;return{frame:{x:a-r.left-e,y:o-r.top-e,w:i+r.width+2*e,h:n+r.height+2*e},text:{x:a,y:o,w:i,h:n}}}(o=a._modelize(d,i,u,t)))),a._model=o,a._rects=l},geometry:function(){return this._rects?this._rects.frame:{}},rotation:function(){return this._model?this._model.rotation:0},visible:function(){return this._model&&this._model.opacity},model:function(){return this._model},draw:function(t,e){var r,i=t.ctx,a=this._model,o=this._rects;this.visible()&&(i.save(),a.clip&&(r=a.area,i.beginPath(),i.rect(r.left,r.top,r.right-r.left,r.bottom-r.top),i.clip()),i.globalAlpha=n.bound(0,a.opacity,1),i.translate(x(e.x),x(e.y)),i.rotate(a.rotation),function(t,e,r){var n=r.backgroundColor,i=r.borderColor,a=r.borderWidth;(n||i&&a)&&(t.beginPath(),h.canvas.roundedRect(t,x(e.x)+a/2,x(e.y)+a/2,x(e.w)-a,x(e.h)-a,r.borderRadius),t.closePath(),n&&(t.fillStyle=n,t.fill()),i&&a&&(t.strokeStyle=i,t.lineWidth=a,t.lineJoin="miter",t.stroke()))}(i,o.frame,a),function(t,e,r,n){var i,a=n.textAlign,o=n.color,l=!!o,s=n.font,u=e.length,d=n.textStrokeColor,f=n.textStrokeWidth,c=d&&f;if(u&&(l||c))for(r=function(t,e,r){var n=r.lineHeight,i=t.w,a=t.x;return"center"===e?a+=i/2:"end"!==e&&"right"!==e||(a+=i),{h:n,w:i,x:a,y:t.y+n/2}}(r,a,s),t.font=s.string,t.textAlign=a,t.textBaseline="middle",t.shadowBlur=n.textShadowBlur,t.shadowColor=n.textShadowColor,l&&(t.fillStyle=o),c&&(t.lineJoin="round",t.lineWidth=f,t.strokeStyle=d),i=0,u=e.length;i<u;++i)v(t,e[i],{stroked:c,filled:l,w:r.w,x:r.x,y:r.y+r.h*i})}(i,a.lines,o.text,a),i.restore())}});var b=t.helpers,p=Number.MIN_SAFE_INTEGER||-9007199254740991,g=Number.MAX_SAFE_INTEGER||9007199254740991;function m(t,e,r){var n=Math.cos(r),i=Math.sin(r),a=e.x,o=e.y;return{x:a+n*(t.x-a)-i*(t.y-o),y:o+i*(t.x-a)+n*(t.y-o)}}function w(t,e){var r,n,i,a,o,l=g,s=p,u=e.origin;for(r=0;r<t.length;++r)i=(n=t[r]).x-u.x,a=n.y-u.y,o=e.vx*i+e.vy*a,l=Math.min(l,o),s=Math.max(s,o);return{min:l,max:s}}function k(t,e){var r=e.x-t.x,n=e.y-t.y,i=Math.sqrt(r*r+n*n);return{vx:(e.x-t.x)/i,vy:(e.y-t.y)/i,origin:t,ln:i}}var M=function(){this._rotation=0,this._rect={x:0,y:0,w:0,h:0}};function S(t,e,r){var n=e.positioner(t,e),i=n.vx,a=n.vy;if(!i&&!a)return{x:n.x,y:n.y};var o=r.w,l=r.h,s=e.rotation,u=Math.abs(o/2*Math.cos(s))+Math.abs(l/2*Math.sin(s)),d=Math.abs(o/2*Math.sin(s))+Math.abs(l/2*Math.cos(s)),f=1/Math.max(Math.abs(i),Math.abs(a));return u*=i*f,d*=a*f,u+=e.offset*i,d+=e.offset*a,{x:n.x+u,y:n.y+d}}b.extend(M.prototype,{center:function(){var t=this._rect;return{x:t.x+t.w/2,y:t.y+t.h/2}},update:function(t,e,r){this._rotation=r,this._rect={x:e.x+t.x,y:e.y+t.y,w:e.w,h:e.h}},contains:function(t){var e=this._rect;return!((t=m(t,this.center(),-this._rotation)).x<e.x-1||t.y<e.y-1||t.x>e.x+e.w+2||t.y>e.y+e.h+2)},intersects:function(t){var e,r,n,i=this._points(),a=t._points(),o=[k(i[0],i[1]),k(i[0],i[3])];for(this._rotation!==t._rotation&&o.push(k(a[0],a[1]),k(a[0],a[3])),e=0;e<o.length;++e)if(r=w(i,o[e]),n=w(a,o[e]),r.max<n.min||n.max<r.min)return!1;return!0},_points:function(){var t=this._rect,e=this._rotation,r=this.center();return[m({x:t.x,y:t.y},r,e),m({x:t.x+t.w,y:t.y},r,e),m({x:t.x+t.w,y:t.y+t.h},r,e),m({x:t.x,y:t.y+t.h},r,e)]}});var C={prepare:function(t){var e,r,n,i,a,o=[];for(e=0,n=t.length;e<n;++e)for(r=0,i=t[e].length;r<i;++r)a=t[e][r],o.push(a),a.$layout={_box:new M,_hidable:!1,_visible:!0,_set:e,_idx:r};return o.sort(function(t,e){var r=t.$layout,n=e.$layout;return r._idx===n._idx?r._set-n._set:n._idx-r._idx}),this.update(o),o},update:function(t){var e,r,n,i,a,o=!1;for(e=0,r=t.length;e<r;++e)i=(n=t[e]).model(),(a=n.$layout)._hidable=i&&"auto"===i.display,a._visible=n.visible(),o|=a._hidable;o&&function(t){var e,r,n,i,a,o;for(e=0,r=t.length;e<r;++e)(i=(n=t[e]).$layout)._visible&&(a=n.geometry(),o=S(n._el._model,n.model(),a),i._box.update(o,a,n.rotation()));(function(t,e){var r,n,i,a;for(r=t.length-1;r>=0;--r)for(i=t[r].$layout,n=r-1;n>=0&&i._visible;--n)(a=t[n].$layout)._visible&&i._box.intersects(a._box)&&e(i,a)})(t,function(t,e){var r=t._hidable,n=e._hidable;r&&n||n?e._visible=!1:r&&(t._visible=!1)})}(t)},lookup:function(t,e){var r,n;for(r=t.length-1;r>=0;--r)if((n=t[r].$layout)&&n._visible&&n._box.contains(e))return{dataset:n._set,label:t[r]};return null},draw:function(t,e){var r,n,i,a,o,l;for(r=0,n=e.length;r<n;++r)(a=(i=e[r]).$layout)._visible&&(o=i.geometry(),l=S(i._el._view,i.model(),o),a._box.update(l,o,i.rotation()),i.draw(t,l))}},z=t.helpers,A={align:"center",anchor:"center",backgroundColor:null,borderColor:null,borderRadius:0,borderWidth:0,clamp:!1,clip:!1,color:void 0,display:!0,font:{family:void 0,lineHeight:1.2,size:void 0,style:void 0,weight:null},formatter:function(t){if(z.isNullOrUndef(t))return null;var e,r,n,i=t;if(z.isObject(t))if(z.isNullOrUndef(t.label))if(z.isNullOrUndef(t.r))for(i="",n=0,r=(e=Object.keys(t)).length;n<r;++n)i+=(0!==n?", ":"")+e[n]+": "+t[e[n]];else i=t.r;else i=t.label;return""+i},listeners:{},offset:4,opacity:1,padding:{top:4,right:4,bottom:4,left:4},rotation:0,textAlign:"start",textStrokeColor:void 0,textStrokeWidth:0,textShadowBlur:0,textShadowColor:void 0},O=t.helpers,D="$datalabels";function $(t,e,r){var n=e&&e[r.dataset];if(n){var i=r.label,a=i.$context;!0===O.callback(n,[a])&&(t[D]._dirty=!0,i.update(a))}}function P(t,e){var r,n,i=t[D],a=i._listeners;if(a.enter||a.leave){if("mousemove"===e.type)n=C.lookup(i._labels,e);else if("mouseout"!==e.type)return;r=i._hovered,i._hovered=n,function(t,e,r,n){var i,a;(r||n)&&(r?n?r.label!==n.label&&(a=i=!0):a=!0:i=!0,a&&$(t,e.leave,r),i&&$(t,e.enter,n))}(t,a,r,n)}}t.defaults.global.plugins.datalabels=A;var N={id:"datalabels",beforeInit:function(t){t[D]={_actives:[]}},beforeUpdate:function(t){var e=t[D];e._listened=!1,e._listeners={},e._datasets=[],e._labels=[]},afterDatasetUpdate:function(t,e,r){var n,i,a,o=e.index,l=t[D],s=l._datasets[o]=[],u=t.isDatasetVisible(o),d=t.data.datasets[o],f=function(t,e){var r=t.datalabels;return!1===r?null:(!0===r&&(r={}),O.merge({},[e,r]))}(d,r),c=e.meta.data||[],h=c.length,x=t.ctx;for(x.save(),n=0;n<h;++n)i=c[n],u&&i&&!i.hidden&&!i._model.skip?(s.push(a=new _(f,x,i,n)),a.update(a.$context={active:!1,chart:t,dataIndex:n,dataset:d,datasetIndex:o})):a=null,i[D]=a;x.restore(),O.merge(l._listeners,f.listeners||{},{merger:function(t,r,n){r[t]=r[t]||{},r[t][e.index]=n[t],l._listened=!0}})},afterUpdate:function(t,e){t[D]._labels=C.prepare(t[D]._datasets,e)},afterDatasetsDraw:function(t){C.draw(t,t[D]._labels)},beforeEvent:function(t,e){if(t[D]._listened)switch(e.type){case"mousemove":case"mouseout":P(t,e);break;case"click":!function(t,e){var r=t[D],n=r._listeners.click,i=n&&C.lookup(r._labels,e);i&&$(t,n,i)}(t,e)}},afterEvent:function(e){var r,i,a,o,l=e[D],s=l._actives,u=l._actives=e.lastActive||[],d=n.arrayDiff(s,u);for(r=0,i=d.length;r<i;++r)(a=d[r])[1]&&(o=a[0][D])&&(o.$context.active=1===a[1],o.update(o.$context));(l._dirty||d.length)&&(C.update(l._labels),function(e){if(!e.animating){for(var r=t.animationService.animations,n=0,i=r.length;n<i;++n)if(r[n].chart===e)return;e.render({duration:1,lazy:!0})}}(e)),delete l._dirty}};return t.plugins.register(N),N});
'
]

{ #category : #private }
ChartJsPluginDatalabelsLibrary >> github [
	
	^ 'https://github.com/chartjs/chartjs-plugin-datalabels'
]

{ #category : #accessing }
ChartJsPluginDatalabelsLibrary >> selectorsToInclude [
	
	^ #(#chartjsPluginDatalabelsMinJs)
]

{ #category : #private }
ChartJsPluginDatalabelsLibrary >> version [
	
	^ '0.6.0'
]
