{CompositeDisposable} = require 'atom'
RedditBackgroundView = require "./reddit-background-view"
configSchema = require "./config-schema"

module.exports = RedditBackground =
	redditBackgroundView: null
	subscriptions: null
	config: configSchema

	activate: (state) ->
		@redditBackgroundView = new RedditBackgroundView(state.redditBackgroundViewState)
		document.body.appendChild @redditBackgroundView.getElement()

		@subscriptions = new CompositeDisposable
		@subscriptions.add atom.commands.add 'atom-workspace', 'reddit-background:toggle': @redditBackgroundView.toggle
		@subscriptions.add atom.commands.add 'atom-workspace', 'reddit-background:skip': @redditBackgroundView.skip

	deactivate: ->
		@subscriptions.dispose()
		@redditBackgroundView.destroy()

	serialize: ->
		redditBackgroundViewState: @redditBackgroundView.serialize()
