PDFKit.configure do |config|
  config.wkhtmltopdf = `which wkhtmltopdf`.gsub(/\n/, '')
  config.default_options = {
    encoding: 'UTF-8',
    page_size: 'A4',
    orientation: 'Portrait'
  }
end