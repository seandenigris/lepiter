Class {
	#name : #LeDatabaseNavigationModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'page',
		'database',
		'databaseViewModel'
	],
	#category : #'Lepiter-UI-! UI - Database'
}

{ #category : #announcer }
LeDatabaseNavigationModel >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
LeDatabaseNavigationModel >> database [
	^ database
]

{ #category : #accessing }
LeDatabaseNavigationModel >> database: anObject [
	database := anObject.
	self database weak
		when: LeDatabasePageAdded
			send: #onDatabaseChanged:
			to: self;
		when: LeDatabasePageRemoved
			send: #onDatabaseChanged:
			to: self;
		when: LePageUnloadAnnouncement 
			send: #onDatabaseChanged:
			to: self;
		when: LeDatabaseTableOfContentsUUIDChanged
			send: #onDatabaseChanged:
			to: self.
	self onDatabaseChanged: anObject
]

{ #category : #accessing }
LeDatabaseNavigationModel >> databaseViewModel [
	^ databaseViewModel
]

{ #category : #accessing }
LeDatabaseNavigationModel >> databaseViewModel: anObject [
	databaseViewModel := anObject.
	self onDatabaseViewModelChanged
]

{ #category : #accessing }
LeDatabaseNavigationModel >> gtAddPageFor: anAction [
	<leNavigationAction>
	self hasDatabase ifFalse: [ ^ anAction noAction ].

	^ anAction button
		icon: BrGlamorousVectorIcons add;
		tooltip: 'Add Page';
		action: [ | aPage |
			aPage := LePage unnamedPage.
			self database addPage: aPage.
			self page: aPage asContentUIModel ]
]

{ #category : #accessing }
LeDatabaseNavigationModel >> gtSearchPageFor: anAction [
	<leNavigationAction>
	self hasDatabase ifFalse: [ ^ anAction noAction ].

	^ anAction explicit
		stencil: [
			GtSpotterDropdownButtonStencil new
				valuable: (LeDatabaseSpotterStart new navigationModel: self);
				tooltip: 'Search Code';
				actOn: [ :anActOnEvent :anItem :theButton | 
					self page: anItem asContentUIModel.
					anActOnEvent beActed.
					theButton fireEvent: BrDropdownHideWish new ];
				asElement ]
]

{ #category : #accessing }
LeDatabaseNavigationModel >> gtViewPagesFor: aView [
	<gtView>
	<leDatabaseView>
	^ aView groupedList
		title: 'Pages';
		priority: 2;
		itemStencil: [ :aNodeType | 
			LePageTitleAndSummaryElement new
				hMatchParent;
				vFitContent ];
		itemDataBinder: [ :anItemElement :aPage | anItemElement contentViewModel: aPage asContentUIModel ];
		groupHeaderStencil: [ BrLabel new
				beSmallSize;
				aptitude: (BrGlamorousLabelAptitude new foreground: Color gray);
				hMatchParent;
				vFitContent;
				margin: (BlInsets top: 10 left: 9) ];
		groupHeaderDataBinder: [ :aLabelElement :aGroup | aLabelElement text: aGroup domainObject asString ];
		groupedItems: [ self database dailyNotesGroup
				collect: [ :aDailyNote | aDailyNote date -> aDailyNote children ] ];
		send: [ :aGroupedListItem | 
			self announce: (LeUIPageSelected new page: aGroupedListItem itemObject asContentUIModel) ]
]

{ #category : #accessing }
LeDatabaseNavigationModel >> gtViewToCFor: aView [
	<gtView>
	<leDatabaseView>
	(self hasDatabase not or: [ self database tableOfContents isNil ])
		ifTrue: [ ^ aView empty ].

	^ aView explicit
		title: 'ToC';
		priority: 1;
		stencil: [ LeDatabaseSidebarListElement new
				selectionBlock: [ self database tableOfContentsNodes ];
				expandSuchThat: [ :eachNode | eachNode value isToCNode ] ]
]

{ #category : #testing }
LeDatabaseNavigationModel >> hasDatabase [
	^ database notNil
]

{ #category : #testing }
LeDatabaseNavigationModel >> hasPage [
	^ page notNil
]

{ #category : #accessing }
LeDatabaseNavigationModel >> initialize [
	super initialize.

	self announcer
		when: LeUIPageSelectionRequest
		send: #onSelection:
		to: self
]

{ #category : #accessing }
LeDatabaseNavigationModel >> onDatabaseChanged: anAnnouncement [
	self onNavigationModelChanged
]

{ #category : #accessing }
LeDatabaseNavigationModel >> onDatabaseViewModelChanged [
	self onNavigationModelChanged
]

{ #category : #accessing }
LeDatabaseNavigationModel >> onNavigationModelChanged [
	self announce: LeUIDatabaseNavigationModelChanged new
]

{ #category : #accessing }
LeDatabaseNavigationModel >> onSelection: anAnnouncement [
	self
		assert: [ anAnnouncement page isKindOf: LePageViewModel ]
		description: [ 'Must be a UI model' ].

	page = anAnnouncement page ifTrue: [ ^ self ].

	self page: anAnnouncement page
]

{ #category : #accessing }
LeDatabaseNavigationModel >> page [
	^ page
]

{ #category : #accessing }
LeDatabaseNavigationModel >> page: anObject [
	page := anObject.
	
	self announce: (LeUIPageSelected new page: page)
]

{ #category : #accessing }
LeDatabaseNavigationModel >> pages [
	^ self database pages
]