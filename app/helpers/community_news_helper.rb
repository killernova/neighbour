module CommunityNewsHelper
  def community_news_tag tag
    case tag
    when 'billboard'
      '居委告示'
    when 'notice'
      '物业通知'
    when 'activity'
      '社区活动'
    end
  end
end
