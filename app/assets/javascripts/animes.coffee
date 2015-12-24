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
    data = {order: newOrder}
    getAnimesAjaxRequest(url, data)

  # handle genre selection
  $('.anime-list-header').on 'change', '.genre-select select', (e) ->
    form = $(this).closest('form')
    form.submit()

  # hide genre selection submit button
  $('.genre-select form input[type=submit]').hide()

  # adds a blank selection to the genre selection (first selection)
  $('.genre-select select').prop 'selectedIndex', -1 if urlParamExists("genre_id") is -1

# function to check if an url param exists
# (it returns its index or -1 if it doesn't exists)
urlParamExists = (key) ->
  window.location.search.search(key)

# function to get current url params
getUrlParameters = ->
  window.location.search.substring(1)

# function to get animes by an json-ajax-request
getAnimesAjaxRequest = (url, data) ->
  $.ajax
    type: 'get'
    url: url
    data: data
    dataType: 'json'  # text, xml, html, script, json, jsonp
    error: ->
      console.log("error: get animes ajax request")
    success: (response) ->
      console.log("success: get animes ajax request")
      $('.anime-list').html(response.animes)
