$ ->
  # click on a column-header anchortag to sort and order the list -> ajax request
  $('.anime-list-header').on 'click', 'a', (e) ->
    e.preventDefault()
    url = $(this).attr('href')
    order = $(this).data('order')
    if order == 'asc'
      newOrder = 'desc'
    else
      newOrder = 'asc'
    $(this).data('order', newOrder)
    paramsHash = getParamsAsHash()
    data = {order: newOrder, page: paramsHash.page}
    successCallback = (response) ->
      console.log("success: get animes ajax request")
      $('.anime-list-body').html(response.animes)
      window.history.pushState('params', 'Animes', '/animes?' + response.params)
    getAnimesAjaxRequest(url, data, successCallback)

  # handle genre selection
  $('.anime-list-header').on 'change', '.genre-select select', (e) ->
    form = $(this).closest('form')
    form.submit()

  # hide genre selection submit button
  $('.genre-select form input[type=submit]').hide()

  # adds a blank selection to the genre selection (first selection)
  $('.genre-select select').prop 'selectedIndex', -1 if urlParamExists("genre_id") is -1

  # paginator -> ajax request
  $('.pagination').on 'click', 'a', (e) ->
    e.preventDefault()

    totalPages = parseInt($(this).closest('ul').find('#total_pages').attr('value'))
    selectedPage = parseInt($(this).attr('value'))
    currentPage = parseInt($(this).closest('ul').find('.active').find('a').attr('value'))

    sendReqeust = false

    # check if an arrow or a number was clicked
    if $(this).closest('li').hasClass('right-arrow')
      if currentPage+1 <= totalPages
        target = $(this).closest('ul').find('.active').next().find('a')
        url = target.attr('href')
        sendReqeust = true
    else if $(this).closest('li').hasClass('left-arrow')
      if currentPage-1 > 0
        target = $(this).closest('ul').find('.active').prev().find('a')
        url = target.attr('href')
        sendReqeust = true
    else if (selectedPage > 0) && (selectedPage <= totalPages)
      url = $(this).attr('href')
      target = this
      sendReqeust = true

    if sendReqeust == true
      paramsHash = getParamsAsHash()
      data = {sort: paramsHash.sort, order: paramsHash.order}
      successCallback = (response) ->
        console.log("success: get animes ajax request")
        $('.anime-list-body').html(response.animes)
        window.history.pushState('params', 'Animes', '/animes?' + response.params)
        $(target).closest('ul').find('.active').removeClass('active')
        $(target).closest('li').addClass('active')

      getAnimesAjaxRequest(url, data, successCallback)

# function to get the current url params as hash
getParamsAsHash = ->
  paramsHash = {}
  currentParamsArray = window.location.search.substring(1).split('&')
  for param in currentParamsArray
    currentParamArray = param.split('=')
    paramsHash[currentParamArray[0]] = currentParamArray[1]
  return paramsHash

# function to check if an url param exists
# (it returns its index or -1 if it doesn't exists)
urlParamExists = (key) ->
  window.location.search.search(key)

# function to get current url params
getUrlParameters = ->
  window.location.search.substring(1)

# function to get animes by an json-ajax-request
getAnimesAjaxRequest = (url, data, successCallback) ->
  $.ajax
    type: 'get'
    url: url
    data: data
    dataType: 'json'  # text, xml, html, script, json, jsonp
    error: ->
      console.log("error: get animes ajax request")
    success: successCallback
