require_relative '../../test_helper'

class TestReport < Minitest::Test

  def setup
    @printer = Escpos::Printer.new
  end

  def test_report
    report_klass = Class.new(Escpos::Report)
    report_klass.class_eval do
      def item(text)
        @count ||= 0
        @count += 1
        bold "#{@count}. #{text}"
      end
      def order
        options[:order]
      end
    end
    report = report_klass.new File.join(__dir__, '../../fixtures/report.erb'), {
      order: { number: 123 }
    }

    @printer << report.render
    @printer.cut!
    file = File.join(__dir__, "../../results/#{__method__}.txt")
    #@printer.save file

    assert_equal IO.binread(file), @printer.to_escpos
  end

end
