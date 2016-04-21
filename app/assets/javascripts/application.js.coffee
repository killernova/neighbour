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


$(document).ready ->

  $('.order-button').on 'click', ->
    with_order = $(this).data('with')
    orderby = $(this).data('orderby')
    url = location.href.split('?')[0]
    order_url = url + '?order_by=' + orderby + '&with=' + with_order
    location.href = order_url