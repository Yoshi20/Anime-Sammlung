$ ->

# Genre selection to order (include the Turbolink gem)
  $('.genre-select').on 'change', 'form', (e) ->
    @.submit()

  $('.genre-select form input[type=submit]').hide()

# Adds a blank selection (first selection)
  $('.genre-select select').prop 'selectedIndex', -1 if urlParamExists("genre_id") == -1



# function to check if an url param exists
# (it returns its index or -1 if it doesn't exists)
urlParamExists = (key) ->
  window.location.search.search(key)