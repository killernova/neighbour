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
    else if $(this).data('checked') == false
      $(this).prop('checked', false)

  #设置权限
  $('.set-role').on 'change', ->
    that = $(this)
    id = that.data('id')
    url = that.data('url')
    val = that.val()
    switch val
      when '会员' then role = '0'
      when '超级管理员' then role = '1'
      when '管理员' then role = '2'
    $.post url, {user_id: id, role: role}, (e) ->
      if e.msg == 'ok'
        alert '设置成功'
      else
        that.val(e.role)
        alert e.msg
