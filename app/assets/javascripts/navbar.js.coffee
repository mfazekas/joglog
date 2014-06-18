ready_callback = ->
  $('button.range-search').click (event)->
    Turbolinks.visit('/time_entries?start='+encodeURI($('input.from-date').val())+'&end='+encodeURI($('input.to-date').val()) )
    event.preventDefault()
$(document).ready(ready_callback)
$(document).on('page:load',ready_callback)