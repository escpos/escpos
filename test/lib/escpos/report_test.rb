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

    @printer.write report.render
    @printer.cut!
    #pp @printer.to_base64
    assert_equal @printer.to_base64, 'G0AbITBPcmRlciBudW1iZXIgMTIzGyEACgobRQExLiBGaXJzdCBpdGVtG0UAChtFATIuIFNlY29uZCBpdGVtG0UAChtFATMuIFRoaXJkIGl0ZW0bRQAKCgoKCh1WAA=='
  end

end
