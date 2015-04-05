'use strict'

descriptionText = ''
selectTag = ''

angular.module 'myVocabsApp'
.controller 'EditWordCtrl', ($scope, $http, socket, $location) ->
  $scope.editWord = ''
  $scope.newTag = ''
  $scope.roughly = ''
  $scope.priority = 'priority-low-color'

  noSelectTagText = '--------------'

  # markdown
  markdown = this
  this.inputText = ''
  marked.setOptions
    renderer: new marked.Renderer(),
    gfm: true,
    tables: true,
    breaks: false,
    pedantic: false,
    sanitize: false,
    smartLists: true,
    smartypants: false,
    highlight: (code, lang) ->
      if lang
        return hljs.highlight(lang, code).value
      else
        return hljs.highlightAuto(code).value

  $scope.$watch 'marked.inputText', (current, original) ->
    descriptionText = current
    markdown.outputText = marked current

  # get word data
  $http.get('/api/things/' + $location.$$path.split('/')[1]).success (wordData) ->
    console.log wordData
    $scope.editWord = wordData.word
    $scope.roughly = wordData.roughly
    $scope.marked.inputText = wordData.description
    $scope.changePriority wordData.priority

  # get tag data
  $http.get('/api/tags').success (tagData) ->
    $scope.tagData = tagData
    # tag selector
    setTimeout ->
      $('.selecter').selecter
        mobile: true
        callback: selectCallback
    , 0

  # priority
  $scope.changePriority = (color) ->
    $scope.priority = color
    $('.priority-group').removeClass('priority-select')
    $('#priority-low').addClass('priority-select') if color is 'priority-low-color'
    $('#priority-middle').addClass('priority-select') if color is 'priority-middle-color'
    $('#priority-high').addClass('priority-select') if color is 'priority-high-color'
    return true

  selectCallback = (value, index)->
    selectTagText = $('span.selecter-selected').first().text()
    if selectTagText is noSelectTagText 
      selectTag = '' 
    else
      selectTag = selectTagText

  $scope.addTags = ->
    return if $scope.newTag is ''
    $http.post '/api/tags',
      name: $scope.newTag
      value: $scope.newTag
    .success (obj) ->
      $scope.newTag = ''
      alert 'add tag'
      $scope.tagData.push obj
      setTimeout ->
        $('.selecter').selecter('update');
      , 0
    .error ->
      alert 'error'

  $scope.addWord = ->
    return if $scope.editWord is ''
    $http.put '/api/things/'+ $location.$$path.split('/')[1],
      word: $scope.editWord
      roughly: $scope.roughly
      description: descriptionText
      priority: $scope.priority
      date: moment().format().split('T')[0] + ' ' + moment().format().split('T')[1].split('+')[0]
      accessCount: 0
      close: false
      # tag: [selectTag]
    .success (json) ->
      $location.path('/'+$location.$$path.split('/')[1])
    .error (json) ->
      alert 'error'