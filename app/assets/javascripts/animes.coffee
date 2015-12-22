$ ->
# Genre selection -> ajax request (include the Turbolink gem to fix a bug)
  $('.genre-select').on 'change', 'select', (e) ->
    form = $(this)
    url = form.data("url")
    data = form.serialize() + '&' + getUrlParameters()

    getAnimesAjaxRequest(url, data)
        
  # Hide submit button
  $('.genre-select form input[type=submit]').hide()

  # Adds a blank selection to the genre selection (first selection)
  $('.genre-select select').prop 'selectedIndex', -1 if urlParamExists("genre_id") is -1

# Order by letter -> ajax request
  $('.letter-list').on 'click', '.letter', (e) ->
    e.preventDefault()

    href = $(this).attr('href')
    url = href.split('?')[0]
    param = href.split('?')[1]
    data = param + '&' + getUrlParameters()

    getAnimesAjaxRequest(url, data)

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
    url: url + '.json'
    data: data
    dataType: 'json'  # text, xml, html, script, json, jsonp
    error: ->
      console.log("error")
    success: (response) ->
      console.log("success")
      $('.anime-list').html(response.animes)
      $('.pagination').html(response.pagination)


# Clock-Updater (every 60s or by a refresh)
# $ ->
#   window.setInterval(clockFunction, 60000)

# clockFunction = ->
#   time = new Date()
#   h = time.getHours()
#   h = if (h < 10) then "0"+h else h
#   m = time.getMinutes()
#   m = if (m < 10) then "0"+m else m

#   $('.clock').text(h+':'+m)
#   console.log "time updated -> #{h}:#{m}"


# $ ->
  # $('.myPicture').on 'click', (e) ->
  #   e.preventDefault()
  #   getUrlParameters()