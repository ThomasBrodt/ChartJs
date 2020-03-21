"
I represent a bar chart where the bars are left to right instead of bottom to top
"
Class {
	#name : #ChartHorizontalBar,
	#superclass : #ChartType,
	#category : #'ChartJs-Core-Types'
}

{ #category : #testing }
ChartHorizontalBar class >> isMultiDataSet [
	^ true
]

{ #category : #accessing }
ChartHorizontalBar class >> styleSheetKeys [
	^ #(#backgroundColor #borderColor #hoverBackgroundColor #hoverBorderColor #fill #borderWidth)
]

{ #category : #accessing }
ChartHorizontalBar class >> typeName [
	^ 'horizontalBar'
]
