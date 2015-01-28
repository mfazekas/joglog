clean_errors = (form)->
  form.find('div.form-group.has-error').each () -> 
    $(this).find('span.error-message').remove()
    $(this).removeClass('has-error')
  
ready_callback = ->
  $('#new_time_entry').on('ajax:success', (e,data,status,xhr)->
    $('#new-time-entry-modal').modal('hide');
    Turbolinks.visit('/time_entries')
  ).on "ajax:error", (e,xhr,status,error) ->
    responseObject = $.parseJSON(xhr.responseText)
    clean_errors $(this)
    $.each responseObject.errors, (key, value)=>
      group = $(this).find('div.form-group.'+key)
      group.addClass('has-error')
      error_msg = '<span class="help-block error-message">error:'+value+'</span>'
      field_input = group.find('.field-input')
      if field_input.size()
        field_input.append(error_msg )
      else
        group.append(error_msg)
$(document).ready(ready_callback)
$(document).on('page:load',ready_callback)
