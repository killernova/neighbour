#= require jquery
#= require jquery_ujs
#= require jquery.remotipart
#= require dropzone
#= require jquery.iframe-transport
#= require jquery.remotipart
#= require foundation/foundation
#= require foundation/foundation.offcanvas
#= require foundation/foundation.tab
#= require sweetalert.min
#= require zepto
#= require zepto.touch
#= require wangEditor-mobile
#= require_tree .
#= require_self

validate_mobile = (mobile) ->
  if !isNaN(parseInt mobile) && mobile.length == 11
    true
  else
    false

$(document).ready ->

  $('.order-button').on 'click', ->
    with_order = $(this).data('with')
    orderby = $(this).data('orderby')
    url = location.href.split('?')[0]
    order_url = url + '?order_by=' + orderby + '&with=' + with_order
    location.href = order_url


  # 提交补充个人信息的form
  $('.cancel-add-info-button').on 'click', ->
    $('.add-info-div').addClass 'hidden'

  $('.submit-add-info-button').on 'click', ->
    mobile = $('.mobile-input').val().trim()
    if $('.location-input').val().trim().length > 5 && $('.community-name-input').val().trim().length > 2 && validate_mobile(mobile)
      $('.add-info-form').submit()


  # 如果需要先完善信息，则跳出form
  $('.need-add-info-first').on 'click', (e) ->
    e.preventDefault()
    $('.off-canvas-wrap').foundation('offcanvas', 'hide', 'move-right')
    url = $(this).data('url')
    $('.add-info-div').removeClass('hidden')
    $('.add-info .to-url').val(url)

    # form 居中对齐
    # div_width = $('.add-info').width()
    # doc_width = $(document).width()
    # set_left = (doc_width - div_width) / 2
    # $('.add-info').css('left', set_left + 'px')
    # console.log set_left
    # console.log $('.add-info').css('left')
