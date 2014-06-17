activate_datepicker = ->
  $('[data-behaviour~=datepicker]').datepicker()
  $('.input-daterange').datepicker()

$(document).ready(activate_datepicker)
$(document).on('page:load',activate_datepicker)

