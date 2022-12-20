Class {
	#name : #LeMoveUpSnippetCommandExamples,
	#superclass : #LeContentCommandExamples,
	#category : #'Lepiter-History-Examples'
}

{ #category : #testing }
LeMoveUpSnippetCommandExamples class >> isAbstract [ 
	^ self name = #LeMoveUpSnippetCommandExamples
]

{ #category : #'examples - commands' }
LeMoveUpSnippetCommandExamples >> createMoveUpSnippetCommand [
	<gtExample>
	| targetSnippet command |
	
	targetSnippet := self targetSnippet.
	command := targetSnippet commandBuilder moveUpSnippetCommand.
	
	self assertCommand: command forSnippet: targetSnippet.
	
	^ command
]

{ #category : #'examples - execution' }
LeMoveUpSnippetCommandExamples >> executeMoveUpSnippetCommand [
	<gtExample>
	| command page initialTargetSnippet result |
	
	command := self createMoveUpSnippetCommand.
	page := self targetPage.
	initialTargetSnippet := self targetSnippet.

	result := command execute.
	
	self assert: page children size equals: 2.
	self assert: page editHistory eventStore size equals: 1.
	
	self assert:  self targetSnippet == initialTargetSnippet.
	
	self 
		assertStructure: self modifiedPageStructure 
		forContent: page.

	^ page
]

{ #category : #accessing }
LeMoveUpSnippetCommandExamples >> modifiedPageStructure [
	^ self subclassResponsibility
]

{ #category : #'examples - setup' }
LeMoveUpSnippetCommandExamples >> targetSnippet [
	<gtExample>
	self targetPage allChildrenBreadthFirstDo: [ :aSnippet |
		aSnippet string = 'Target' ifTrue: [ ^ aSnippet ] ].
	
	NotFound signal.
]