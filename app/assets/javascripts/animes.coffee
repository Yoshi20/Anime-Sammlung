$ ->
  # a click on a column-header anchortag sends an ajax-request to sort and order the list
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
      $('.anime-list-body').html(response.animes)
      window.history.pushState('params', 'Animes', '/animes?' + response.params)
      hideRateButtons()
    getAnimesAjaxRequest(url, data, successCallback)

  # handle genre selection
  $('.anime-list-header').on 'change', '.genre-select select', (e) ->
    form = $(this).closest('form')
    form.submit()

  # hide genre selection submit button
  $('.genre-select form input[type=submit]').hide()

  # adds a blank selection to the genre selection (first selection)
  $('.genre-select select').prop 'selectedIndex', -1 if urlParamExists("genre_id") is -1

  # handle target_audience selection
  $('.anime-list-header').on 'change', '.target-audience-select select', (e) ->
    form = $(this).closest('form')
    form.submit()

  # hide target_audience selection submit button
  $('.target-audience-select form input[type=submit]').hide()

  # adds a blank selection to the target_audience selection (first selection)
  $('.target-audience-select select').prop 'selectedIndex', -1 if urlParamExists("target_audience_id") is -1

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
        $('.anime-list-body').html(response.animes)
        window.history.pushState('params', 'Animes', '/animes?' + response.params)
        $(target).closest('ul').find('.active').removeClass('active')
        $(target).closest('li').addClass('active')
        hideRateButtons()
      getAnimesAjaxRequest(url, data, successCallback)

  # a click on a rating sends an ajax-request and creates or updates a rating
  $('.anime-list').on 'click', '.ratings input[type=radio]', (e) ->
    e.preventDefault()
    $t = $(this)
    $form = $t.closest('form')
    url = $form.attr('action')
    data =
      rating: $t.attr('value')
      anime_id: $form.find('.hidden-anime-id').attr('value')
    $.ajax
      method: if $form.hasClass('edit_rating') then 'patch' else 'post'
      url: url
      data: data
      dataType: 'json'
      error: ->
        console.log("error: set rating ajax request")
      success: (response) ->
        $t.prop('checked', true)
        $tr = $form.closest('tr')
        if response.rating_id
          # new rating created
          $form.removeClass('new_rating').addClass('edit_rating')
          $form.attr('action', url + '/' + response.rating_id)
          ratingsCount = parseInt($tr.find('.ratings-count').text())
          $tr.find('.ratings-count').text(ratingsCount+1)
        $tr.find('.avg-rating').text(response.avg_rating.toFixed(1))
        $tr.find('.my-rating').text(data.rating)

  hideRateButtons()

# hide the rate submit buttons
hideRateButtons = ->
  $('.ratings input[type=submit]').hide()

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
