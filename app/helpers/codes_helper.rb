module CodesHelper
  require 'chunky_png'

  def qrcode_tag(url, options = {})
    qr = ::RQRCode::QRCode.new(url)
    return ChunkyPNG::Image.from_datastream(qr.as_png.resize(250,250).to_datastream).to_data_url
  end
end
