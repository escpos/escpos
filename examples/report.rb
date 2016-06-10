require 'escpos'

class MyReport < Escpos::Report
  def item(text)
    @count ||= 0
    @count += 1
    quad_text "#{@count}. #{text}"
  end
end

report = MyReport.new File.join(__dir__, 'report.erb')
@printer.write report.render
@printer.cut!

# @printer.to_escpos or @printer.to_base64 contains resulting ESC/POS data
