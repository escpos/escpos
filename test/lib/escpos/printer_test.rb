require_relative '../../test_helper'

class PrinterTest < Minitest::Test

  def setup
    @printer = Escpos::Printer.new
  end

  def test_styles
    require 'erb'
    template = ERB.new(File.open(File.join(__dir__, '../../fixtures/styles.erb')).read)
    result = template.result(Class.new { include Escpos::Helpers }.new.instance_eval { binding })
    @printer << result
    @printer.cut!
    file = File.join(__dir__, "../../results/#{__method__}.txt")
    #@printer.save file

    assert_equal IO.binread(file), @printer.to_escpos
  end

end
