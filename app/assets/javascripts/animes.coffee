$ ->

# Genre selection order request (include the Turbolink gem to fix a bug)
  $('.genre-select').on 'change', 'form', (e) ->
    @.submit()

# Hide submit button
  $('.genre-select form input[type=submit]').hide()

# Adds a blank selection to the genre selection (first selection)
  $('.genre-select select').prop 'selectedIndex', -1 if urlParamExists("genre_id") == -1






# function to check if an url param exists
# (it returns its index or -1 if it doesn't exists)
urlParamExists = (key) ->
  window.location.search.search(key)