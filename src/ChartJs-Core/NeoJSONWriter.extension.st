Extension { #name : #NeoJSONWriter }

{ #category : #'*ChartJs-Core' }
NeoJSONWriter >> chartJsWriteJavascript: aString [ 
	writeStream nextPutAll: aString

]
