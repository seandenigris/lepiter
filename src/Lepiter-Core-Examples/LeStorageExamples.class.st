"
Examples to test equality and storeStrings for pages and snippets.
"
Class {
	#name : #LeStorageExamples,
	#superclass : #Object,
	#category : #'Lepiter-Core-Examples-Content'
}

{ #category : #accessing }
LeStorageExamples >> assertPageEqualsEvaluatedStoreString: aPage [

	"Workaround to avoid breaking = for pages."

	| pageSnippets restoredSnippets |
	pageSnippets := aPage children children.
	restoredSnippets := (Smalltalk compiler evaluate: aPage storeString)
		                    children children.
	restoredSnippets withIndexDo: [ :snippet :n | 
		self
			assert: snippet contentAsString
			equals: (pageSnippets at: n) contentAsString ]
]

{ #category : #accessing }
LeStorageExamples >> assertSnippetEqualsEvaluatedStoreString: aSnippet [

	"Workaround to avoid breaking = for snippets."

	self
		assert:
		(Smalltalk compiler evaluate: aSnippet storeString) contentAsString
		equals: aSnippet contentAsString
]

{ #category : #accessing }
LeStorageExamples >> emptyPharoSnippet [
	<gtExample>
	|snippet|
	snippet := LePharoSnippet code: ''.
	self assertSnippetEqualsEvaluatedStoreString: snippet.
	^ snippet
]

{ #category : #accessing }
LeStorageExamples >> emptyTextSnippet [

	<gtExample>
	| snippet |
	snippet := LeTextSnippet string: ''.
	self assertSnippetEqualsEvaluatedStoreString: snippet.
	^ snippet
]

{ #category : #accessing }
LeStorageExamples >> pharoSnippet [
	<gtExample>
	|snippet|
	snippet := LePharoSnippet code: '3+4'.
	self assertSnippetEqualsEvaluatedStoreString: snippet.
	^ snippet
]

{ #category : #accessing }
LeStorageExamples >> pharoSnippetWithQuotes [
	<gtExample>
	|snippet|
	snippet := LePharoSnippet code: '''hello world'''.
	self assertSnippetEqualsEvaluatedStoreString: snippet.
	^ snippet
]

{ #category : #accessing }
LeStorageExamples >> textSnippet [
	<gtExample>
	|snippet|
	snippet := LeTextSnippet string: 'Everything is an object.'.
	self assertSnippetEqualsEvaluatedStoreString: snippet.
	^ snippet
]

{ #category : #accessing }
LeStorageExamples >> textSnippetWithQuotes [
	<gtExample>
	|snippet|
	snippet := LeTextSnippet string: '''Everything'' is an ''object''.'.
	self assertSnippetEqualsEvaluatedStoreString: snippet.
	^ snippet
]

{ #category : #accessing }
LeStorageExamples >> unnamedPageWithTextAndPharoSnippets [
	<gtExample>
	| page |
	page := LePage unnamedPage.
	page addSnippet: self textSnippet.
	page addSnippet: self pharoSnippet.
	self assertPageEqualsEvaluatedStoreString: page.
	^ page
]