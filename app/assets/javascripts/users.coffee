$(document).ready ->
  $('.share-alert').on 'click', ->
    alert('请点击右上角的分享按钮进行分享！')

  # 切换是否查看所有信息
  url = '/users/set_check_range'
  $('input[type="checkbox"]').on 'click', ->
    type = $(this).data('type')
    if $(this).is(':checked')
      val = 1
      re_val = false
    else
      val = 0
      re_val = true
    $.post url, {val: val, type: type}, (e) ->
      console.log e.msg
      if e.msg == 'failed'
        $(this).prop('checked', re_val)

  # 初始化checked状态
  $('input[type="checkbox"]').each ->
    console.log $(this).data('checked')
    if $(this).data('checked') == true
      $(this).prop('checked', true)
    else
      $(this).prop('checked', false)
