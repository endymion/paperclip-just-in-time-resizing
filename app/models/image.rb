require 'uri'

class Image < ActiveRecord::Base
  has_attached_file :attachment,
    :storage => :s3,
    :bucket => ENV['S3_BUCKET_NAME'],
    :s3_credentials => {
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    },
    :styles => Proc.new { |attachment| attachment.instance.styles }
  attr_accessible :attachment
  
  @dynamic_style_format = ''
  def dynamic_style_format_symbol
    URI.escape(@dynamic_style_format).to_sym
  end
  
  def styles
    unless @dynamic_style_format.blank?
      { dynamic_style_format_symbol => @dynamic_style_format }
    else
      {}
    end
  end

  def dynamic_attachment_url(format)
    @dynamic_style_format = format
    attachment.reprocess!(dynamic_style_format_symbol) unless attachment.exists?(dynamic_style_format_symbol)
    attachment.url(dynamic_style_format_symbol)
  end
  
end