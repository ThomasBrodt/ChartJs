querying
valuesFor: aCollectionOfXObjects block: aBlock
	aCollectionOfXObjects size = self sequence size
		ifFalse: [ ChartDataWrongFormatException signal: 'Their must be as many values in the dataset that the data x objects' ].
	^ self sequence collect: aBlock