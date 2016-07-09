path = require "path"
{activate, open, ls, dirs, fixtures, wait} = require "./helpers"


describe "TreeView", ->
	[workspace, treeView] = []
	
	
	beforeEach "Activate packages", ->
		workspace = atom.views.getView atom.workspace
		atom.project.setPaths [fixtures]
		
		activate("tree-view", "file-icons").then ->
			atom.packages.emitter.emit "did-activate-initial-packages"
			atom.commands.dispatch workspace, "tree-view:toggle"
			treeView = atom.workspace.getLeftPanels()[0].getItem()
	
	
	describe "Icon assignment", ->
		beforeEach -> open "project-1"
	
		it "displays the correct icons for files", ->
			f = ls treeView
			
			f[".default-config"].should.have.class "name icon"
			f[".default-gear"  ].should.have.class "gear-icon"
			f[".gitignore"     ].should.have.class "git-icon"
			f["data.json"      ].should.have.class "database-icon"
			f["image.gif"      ].should.have.class "image-icon"
			f["markdown.md"    ].should.have.class "markdown-icon"
			f["package.json"   ].should.have.class "npm-icon"
			f["README.md"      ].should.have.class "book-icon"
			f["text.txt"       ].should.have.class "icon-file-text"
		
		
		it "displays the correct icons for directories", (done) ->
			wait(100).then ->
				try
					d = ls treeView, "directory"
					d["Dropbox"].should.have.class      "name icon dropbox-icon"
					d["node_modules"].should.have.class "node-icon"
					d["subfolder"].should.have.class    "icon-file-directory"
					done()
				catch error
					done error
			

	
	describe "Colour handling", ->
		[expectedClasses, f] = []
		
		beforeEach "Open first project folder", ->
			open "project-1"
			f = ls treeView
			expectedClasses =
				".gitignore":   "medium-red"
				"data.json":    "medium-yellow"
				"image.gif":    "medium-yellow"
				"markdown.md":  "medium-blue"
				"package.json": "medium-red"
				"README.md":    "medium-blue"
				"text.txt":     "medium-blue"
		
		
		it "displays icons in colour", ->
			for file, colour of expectedClasses
				f[file].should.have.class colour
		
		
		it "doesn't show colours if colourless icons are enabled", (done) ->
			atom.config.get("file-icons.coloured").should.be.true
			atom.commands.dispatch workspace, "file-icons:toggle-colours"
			atom.config.get("file-icons.coloured").should.be.false
			
			wait(100).then ->
				try
					for file, colour of expectedClasses
						f[file].should.not.have.class colour
					done()
				catch error
					done error
