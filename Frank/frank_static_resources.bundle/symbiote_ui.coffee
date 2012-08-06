setupDropdowns = ->
  $extraActionsList = $('.action-buttons .extra-actions')
  $se_option_list = $('ul#selector_engine_options')
  $se_option_input = $('input#selector_engine')

  $('button#selector_engine_dropdown').on 'click', (e)->
    e.stopPropagation()
    $se_option_list.toggleClass('shown')

  $('li', $se_option_list).on 'click', (e)->
    $se_option_input.val( $(e.target).text() )

  $('.action-buttons .drop-indicator').on 'click', (e)->
    e.stopPropagation()
    $extraActionsList.toggleClass('shown')

  $('button',$extraActionsList).on 'click', ->
    $selectedButton = $(this)
    $currentTopButton = $('.action-buttons > button')

    return if $selectedButton[0] == $currentTopButton[0]

    # shove the button that was just selected into the 'top'
    # action button area
    $currentTopButton.after($selectedButton)
    # push the current top button to the top of the 'extra'
    # action button area. This will also remove it from the 'top' area
    $extraActionsList.prepend($currentTopButton)
    

    # remove button from top and but to top of extra buttons
    # move tapped butotn

  $('body').on 'click', ->
    $extraActionsList.removeClass('shown')
    $se_option_list.removeClass('shown')

$ -> 
  setupDropdowns()
