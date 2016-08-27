require_relative '../../test_helper'

class TestPrinter < Minitest::Test
  def setup
    @printer = Escpos::Printer.new
  end

  def test_styles
    require 'erb'
    template = ERB.new(File.open(File.join(__dir__, '../../fixtures/styles.erb')).read)
    @printer.write template.result(Class.new { include Escpos::Helpers }.new.instance_eval { binding })
    @printer.cut!
    #pp @printer.to_base64
    assert_equal @printer.to_base64, 'G0BVbmZvcm1hdHRlZCB0ZXh0CgobdBYKClVURi04IHRvIElTTy04ODU5LTIgdGV4dDogKOy56Pi+/eHt6fr5KQoKGyEATm9ybWFsIHRleHQbIQAKChshEERvdWJsZSBoZWlnaHQgdGV4dBshAAoKGyEgRG91YmxlIHdpZHRoIHRleHQbIQAKChshMFF1YWQgYXJlYSB0ZXh0GyEACgobLQFVbmRlcmxpbmVkIHRleHQbLQAKChstAlVuZGVybGluZWQgdGV4dCAoMikbLQAKChtFAUJvbGQgdGV4dBtFAAoKG2EATGVmdCBhbGlnbmVkIHRleHQbYQAKChthAlJpZ2h0IGFsaWduZWQgdGV4dBthAAoKG2EBQ2VudGVyZWQgdGV4dBthAAoKG2EAG2EACgodQgFJbnZlcnRlZCBjb2xvciB0ZXh0HUIACgodSAAddwMdaDIdawI4NTk0NDA0MDAwNTcyCgoKCgodVgA='
  end

end
