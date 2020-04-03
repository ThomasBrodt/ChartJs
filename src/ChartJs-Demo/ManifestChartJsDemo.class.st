"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestChartJsDemo,
	#superclass : #PackageManifest,
	#category : #'ChartJs-Demo-Manifest'
}

{ #category : #'code-critics' }
ManifestChartJsDemo class >> ruleRBClassNotReferencedRuleV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#'ChartJs-Demo')) #'2020-04-03T22:25:04.614271+02:00') )
]
