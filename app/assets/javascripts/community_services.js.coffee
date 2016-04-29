$(document).ready ->

  # 是否使用默认地址
  default_addr = $('.input-address').val()
  address = $('.address').text().trim()
  $('.input-address').val(address)
  console.log $('.input-address').val()
  $('input[name="use_default"]').on 'click', ->
    default_addr = $('.input-address').val()
    address = $('.address').text().trim()
    if $(this).is(':checked')
      $('.default-address').removeClass('hidden')
      $('.new-address').addClass('hidden')
      $('.input-address').val(address)
    else
      $('.default-address').addClass('hidden')
      $('.new-address').removeClass('hidden')
      $('.input-address').val('')

  # 不显示默认tag
  $('.service-tag').val('')
