#= require foundation-datepicker.min

#--------时间选择插件----------#
$(document).ready ->
  $('.fdatepicker').fdatepicker {
    language: 'zh-CN',
    format: 'yyyy-mm-dd hh:ii',
    disableDblClickSelection: true,
    pickTime: true
  }
