jQuery ->
  $('.toggle_literature_fields').each ->
    $(@).click()
    
  for autocomplete_field in $('[data-autocomplete="literature"]')
    do ->
      my_fieldset = $(autocomplete_field).closest('fieldset')
      my_hidden_field = my_fieldset.find('[data-hidden_field_for="literature"]')
      $(autocomplete_field).autocomplete
        source: $(autocomplete_field).data('autocomplete-source')
        select: (event,ui) ->
          $(my_hidden_field).val(ui.item.id)
          $.ajax({
              type: 'get',
              url: '/literatures/'+ui.item.id,
              data: 'pure=true',
              success: (data) ->
                my_fieldset.find('.show_literature_div').html(data);
          });
#      console.log

$(document).on 'click', 'form .add_fields', (event) ->
  time = new Date().getTime()
  regexp = new RegExp($(this).data('id'), 'g')
  inserted = $(this).data('fields').replace(regexp, time)
  my_id = $(inserted).find('[data-autocomplete="literature"]').attr('id')
  my_hidden_field_id = $(inserted).find('[data-hidden_field_for="literature"]').attr('id')
  auto_field = $(inserted).find('#'+my_id).autocomplete
    source: $(inserted).find('#'+my_id).data('autocomplete-source')
    select: (event,ui) ->
      $('#'+my_hidden_field_id).val(ui.item.id)
      $.ajax({
          type: 'get',
          url: '/literatures/'+ui.item.id,
          data: 'pure=true',
          success: (data) ->
            $('#'+my_hidden_field_id).closest('fieldset').find('.show_literature_div').html(data);
      });
  $(this).before(inserted)
  $(this).prev().find('[data-autocomplete="literature"]').replaceWith(auto_field) # ALLE?
  $(this).prev().find('.toggle_literature_fields').click()
  event.preventDefault()

$(document).on 'click', 'form .toggle_literature_fields', (event) ->
  
  my_fieldset = $(this).closest('fieldset')
  new_lit_div=my_fieldset.find('.new_literature')
  existing_lit_div = my_fieldset.find('.existing_literature')
  if $(this).data('litStatus') == true
    new_lit_div.hide()
    existing_lit_div.show()
    new_lit_div.find('input, textarea').each ->
      $(this).attr({'disabled': 'disabled'})
    existing_lit_div.find('input, textarea').each ->
      $(this).removeAttr('disabled')
    $(this).html("or enter new Literature")
    $(this).data('litStatus', false) 
  else
    existing_lit_div.hide()
    new_lit_div.show()
    existing_lit_div.find('input, textarea').each ->
      $(this).attr({'disabled': 'disabled'})
    new_lit_div.find('input, textarea').each ->
      $(this).removeAttr('disabled')
    $(this).html("or choose existing Literature")
    $(this).data('litStatus', true)
  event.preventDefault()
