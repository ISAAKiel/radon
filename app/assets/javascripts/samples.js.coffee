jQuery ->
  $('#sample_culture_id').parent().show()
  $('.javascript_content').show()

  if !($('#sample_phase_id option:selected').val())
    $('#sample_phase_id').parent().hide()

  states = $('#sample_phase_id').html()
  $('#sample_culture_id').change ->
    culture = $('#sample_culture_id :selected').text()
    escaped_culture = culture.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(states).filter("optgroup[label='#{escaped_culture}']").html()
    if options
      $('#sample_phase_id').html(options)
      $('#sample_phase_id').parent().show()
    else
      $('#sample_phase_id').empty()
      $('#sample_phase_id').parent().hide()

#  $(".siteFeature").click ->
#    $('#hidden_site_id').val(this.getAttribute ('data_site_id'))
##    $('#sample_site_id').val(this.getAttribute ("data_site_id"))
#    $('#hidden_site_id').prop('disabled', false);
#    console.log $('#hidden_site_id') 
#    false

  $("#search").keydown= (event) ->
    if(event.keyCode == 13 && jQuery.support.submitBubbles)
      $(this).parents("form").append('&commit=Search').submit();

  $("[data-function='use_last_site']").click (e) ->
    console.log this
    $('#hidden_site_id').val(this.getAttribute ('data_site_id'))
    $('#site_display_name').text(this.getAttribute ('data_site_name'))
    $("[data-input='site_name']").val(this.getAttribute ('data_site_name'))
    false

  $(document).on 'click', 'form .remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()
