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
err = 0
blur = 0
grey = 0
contrast = 0

class RedditBackgroundView
  constructor: (serializedState) ->
    _this = this
    @background = document.createElement('div')
    @background.classList.add('reddit-background')
    atom.config.observe 'reddit-background.pause', (val) ->
      _this.toggle()
    atom.config.observe 'reddit-background.blur', (val) ->
      blur = val
      _this.filter()
    atom.config.observe 'reddit-background.grey', (val) ->
      grey = val
      _this.filter()
    atom.config.observe 'reddit-background.contrast', (val) ->
      contrast = val
      _this.filter()
  toggle: ->
    _this = this
    if @refreshInterval
      clearInterval @refreshInterval
    else
      @stop()
      @load()
      @refreshDuration = atom.config.get 'reddit-background.refreshDuration'
      if (!@pause)
        @refreshInterval = setInterval((->
          _this.skip()
          return
        ), 1000 * @refreshDuration)

  refresh: ->
    nsfw = atom.config.get 'reddit-background.nsfw'
    if !_.isUndefined(data and data.children and data.children[i])
      if !_.isUndefined(data.children[i].data.preview and
      data.children[i].data.preview.images[0] and
      data.children[i].data.preview.images[0].source.url)
        if !nsfw or (nsfw and !data.children[i].data.over_18)
          @getImage data.children[i].data.preview.images[0].source.url
        else
          @skip()
      else
        @skip()
    else
      @load()
  filter: ->
    @background.style.webkitFilter = 'blur(' + blur + 'px)
    grayscale(' + grey + '%)
    contrast(' + contrast + '%)'
  load: ->
    if err <= 5
      err++
      subreddits = _.replace(
        _.replace(
          _.join(
            _.toArray(
              atom.config.get('reddit-background.subreddits')
            ), '+')
          , ' ', '')
        , '/r/'
      , '')
      query = reddit.hot(subreddits).limit(10)
      _this = this
      if !_.isUndefined(data)
        query.after(data.after)
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
        atom.notifications.addError(
          'Was unable to load image, moving to next available image.',
          icon: 'alert'
        )
    else
      atom.notifications.addError(
        'Seems like we couldn\'t find any images to
        load in your collection of subreddits.
        Please add more or configure your list to
        include subreddits with many image posts.',
        icon: 'alert'
      )
      @stop()
    return
  skip: =>
    i++
    @refresh()

  getImage: (url) ->
    request {url: url, encoding: null}, (err, res, body) =>
      if res && res.statusCode == 200
        err = 0
        contentType = res.headers['content-type']
        base64 = new Buffer(body).toString('base64')
        dataUrl = 'url(\'data:' + contentType + ';base64,'+ base64 + '\')'
        @background.style.backgroundImage = dataUrl
      else
        atom.notifications.addError(
          'Was unable to load image, moving to next available image.',
          {icon: 'alert'}
        )
        @refresh()

  stop: ->
    if @refreshInterval
      clearInterval @refreshInterval

  serialize: ->

  destroy: ->
    @stop()
    @background.remove()

  getElement: ->
    @background
module.exports = RedditBackgroundView
