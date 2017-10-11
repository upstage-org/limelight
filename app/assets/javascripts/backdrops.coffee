# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

init = () ->
	$(document).on 'change', '#add_stage_path', (e) ->
		stagebtn = $('#stageAssignmentButton')
		stageval = $(this).val()
		if stageval == ''
			stagebtn.attr 'disabled', 'disabled'
			stagebtn.data 'method', 'GET'
		else
			stagebtn.removeAttr 'disabled'
			stagebtn.data 'method', 'PATCH'
		stagebtn.attr 'href', stageval

$(document).on 'turbolinks:load', init