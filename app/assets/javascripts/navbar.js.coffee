ready_callback = ->
  $('.date-range-search button').click ->
    console.log "hello"
$(document).ready(ready_callback)
$(document).on('page:load',ready_callback)