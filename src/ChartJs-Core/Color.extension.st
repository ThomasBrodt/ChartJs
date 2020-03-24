Extension { #name : #Color }

{ #category : #'*ChartJs-Core' }
Color >> blendWith: aColor [
	"Answer a new Color which is a 50% blend of the receiver and the
	supplied Color."
	"Simply interpolates in RGB space."

	^self blendWith: aColor weight: 0.5
]

{ #category : #'*ChartJs-Core' }
Color >> blendWith: aColorValue weight: wt [
	"Answer a new ColorValue which is a weighted blend of the receiver and the
	supplied ColorValue."

	"Simply interpolates in RGB space."

	| rv gv bv invWt |
	invWt := 1 - wt.
	rv := (self red * invWt + (aColorValue red * wt)).
	gv := (self green * invWt + (aColorValue green * wt)).
	bv := (self blue * invWt + (aColorValue blue * wt)).
	^ self class r: rv g: gv b: bv
]

{ #category : #'*ChartJs-Core' }
Color >> forChartJs [
	^ String
		streamContents: [ :s | 
			s
				nextPutAll: 'rgba(';
				nextPutAll: (self red * 255) asInteger asString;
				nextPut: $,;
				nextPutAll: (self green * 255) asInteger asString;
				nextPut: $,;
				nextPutAll: (self blue * 255) asInteger asString;
				nextPut: $,;
				nextPutAll: self alpha asString;
				nextPut: $) ]
]
