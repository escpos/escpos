require_relative '../../test_helper'

class TestReport < Minitest::Test
  def setup
    @printer = Escpos::Printer.new
  end

  def test_styles
    report_klass = Class.new(Escpos::Report)
    report_klass.class_eval do
      def item(text)
        @count ||= 0
        @count += 1
        quad_text "#{@count}. #{text}"
      end
    end
    report = report_klass.new(File.join(__dir__, '../../fixtures/report.erb'))

    @printer.write report.render
    @printer.cut!
    #pp @printer.to_base64
    assert_equal @printer.to_base64, 'G0AbITAxLiBGaXJzdCBpdGVtGyEAChshMDIuIFNlY29uZCBpdGVtGyEAChshMDMuIFRoaXJkIGl0ZW0bIQAKCgoKCh1WAA=='
  end

end
