#
# * reddit-background
# * https://github.com/braxtondiggs/reddit-background
# *
# * Copyright (c) 2016 braxtondiggs
# * Licensed under the MIT license.
#
{CompositeDisposable} = require 'atom'
require 'reddit.js/reddit.js'
request = require 'request'
_ = require 'lodash'
data = undefined
i = 1

class RedditBackgroundView
	constructor: (serializedState) ->
		@background = document.createElement('div')
		@background.classList.add('reddit-background')
		enabled = atom.config.get 'reddit-background.enabled'
		if enabled
			@toggle()
	toggle: ->
		if @refreshInterval
			clearInterval @refreshInterval
		else
			@stop()
			@load()
			refreshDuration = atom.config.get 'reddit-background.refreshDuration'
			@refreshInterval = setInterval @refresh, @refreshDuration*1000

	refresh: ->
		nsfw = atom.config.get 'reddit-background.nsfw'
		if !_.isUndefined(data.children[i])
			if !_.isUndefined(data.children[i].data.preview.images[0].source.url)
				if !nsfw or (nsfw and !data.children[i].data.over_18)
					@getImage data.children[i].data.preview.images[0].source.url
				else
					@skip()
			else
				@skip()
		else
			@load()
	load: ->
		subreddits = _.replace(_.replace(_.join(_.toArray(atom.config.get('reddit-background.subreddits')), '+'), ' ', ''), '/r/', '')
		query = reddit.hot(subreddits).limit(10)
		_this = this
		if !_.isUndefined(data)
			search.after(data.after)
		query.fetch ((res) ->
			if !_.isUndefined(data)
				if !_.isUndefined(res.data.children)
					data.after = res.data.after
					data.children = _.concat(data.children, res.data.children)
			else
				data = res.data
			_this.refresh()
			return
		), ->
			atom.notifications.addError 'Was unable to load image, moving to next available image.', icon: 'alert'
			return
	skip: =>
		i++
		@refresh()

	getImage: (url) ->
		request {url: url, encoding: null}, (err, res, body) =>
			if res && res.statusCode == 200
				contentType = res.headers['content-type']
				base64 = new Buffer(body).toString('base64')
				dataUrl = 'url(\'data:' + contentType + ';base64,'+ base64 + '\')'
				@background.style.background = dataUrl
			else
				atom.notifications.addError('Was unable to load image, moving to next available image.', {icon: 'alert'})
				@refresh()

	stop: ->
		if @refreshInterval
			clearInterval @refreshInterval
	advanced: ->
		blur = atom.config.get 'reddit-background.blur'
		grey = atom.config.get 'reddit-background.grey'
		dim = atom.config.get 'reddit-background.dim'

	serialize: ->

	destroy: ->
		@background.remove()

	getElement: ->
		@background
module.exports = RedditBackgroundView
