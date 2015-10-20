$ ->

# Genre selection order ajax request (include the Turbolink gem to fix a bug)
  $('.genre-select').on 'change', 'select', (e) ->
    form = $(this)
    url = form.data("url")

    $.ajax
      type: 'get'
      url: url                # '/animes'
      data: form.serialize()  # same as -> genre_id: $(this).val()
      dataType: 'text'        # text, xml, html, script, json, jsonp
      error: ->
        console.log("error")
      success: (response) ->
        console.log("success")
        $('.anime-list').html(response)
        
# Hide submit button
  $('.genre-select form input[type=submit]').hide()

# Adds a blank selection to the genre selection (first selection)
  $('.genre-select select').prop 'selectedIndex', -1 if urlParamExists("genre_id") is -1



# function to check if an url param exists
# (it returns its index or -1 if it doesn't exists)
urlParamExists = (key) -> window.location.search.search(key)