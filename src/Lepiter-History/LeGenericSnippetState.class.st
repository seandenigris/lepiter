Class {
	#name : #LeGenericSnippetState,
	#superclass : #LeBasicSnippetState,
	#instVars : [
		'attributesByName'
	],
	#category : #'Lepiter-History'
}

{ #category : #adding }
LeGenericSnippetState >> addAttribute: aStateAttribute [ 
	attributesByName 
		at: aStateAttribute attributeName 
		put: aStateAttribute
]

{ #category : #updating }
LeGenericSnippetState >> applyOn: aSnippet [ 
	attributesByName do: [ :anAttribute |
		anAttribute applyOn: aSnippet ]
]

{ #category : #adding }
LeGenericSnippetState >> attributeNamed: anAttributeName setValue: aValue [
	self addAttribute: (LeGenericSnippetStateAttribute new
		attributeName: anAttributeName;
		attributeValue: aValue)
]

{ #category : #accessing }
LeGenericSnippetState >> attributeNames [
	^ attributesByName values collect: [ :anAttribute | anAttribute attributeName ]
]

{ #category : #'gt - extensions' }
LeGenericSnippetState >> gtViewStateAttributesFor: aView [ 
	<gtView>
	
	^ aView columnedList 
		title: 'Attributes';
		items: [ attributesByName values ];
		column: 'Attribute' text: [ :anAttribute | anAttribute attributeName ];
		column: 'Value' text: [ :anAttribute | anAttribute attributeValue ];
		column: 'Type' text: [ :anAttribute | anAttribute className ]
]

{ #category : #initialization }
LeGenericSnippetState >> initialize [ 
	super initialize.
	attributesByName := OrderedDictionary new.
]

{ #category : #accessing }
LeGenericSnippetState >> valueForAttributeNamed: anAttributeName [ 
	^ (attributesByName at: anAttributeName) attributeValue
]