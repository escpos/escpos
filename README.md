# Escpos

A ruby implementation of ESC/POS (thermal) printer command specification.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'escpos'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install escpos

## Usage

```ruby
@printer = Escpos::Printer.new
@printer.write "Some text"

@printer.to_escpos # returns ESC/POS data ready to be sent to printer
# on linux this can be piped directly to /dev/usb/lp0
# with network printer sent directly to printer socket
# with serial port printer it can be sent directly to the serial port

@printer.to_base64 # returns base64 encoded ESC/POS data

# using report class

# my_report.rb:
class MyReport < Escpos::Report
  def item(text)
    @count ||= 0
    @count += 1
    quad_text "#{@count}. #{text}"
  end
end

```

```erb
<% # my_report.erb: %>
<%= item "First item" %>
<%= item "Second item" %>
<%= item "Third item" %>
```

```ruby
# usage:

report = MyReport.new 'path/to/my_report.erb'
@printer.write report.render
@printer.cut!
# @printer.to_escpos or @printer.to_base64 contains resulting ESC/POS data
```

## Available helpers

- text: Normal text formatting
- double_height: Double height text
- quad_text, big, title, header, double_width_double_height, double_height_double_width: Double width & Double height text
- double_width: Double width text
- underline, u: Underlined text
- underline2, u2: Stronger underlined text
- bold, b: Bold text
- left: Align to left
- right: Align to right
- center: Align to center
- barcode: Print barcode
- partial_cut: Partially cut the paper (may not be available on all devices)
- cut: Fully cut the paper (may not be available on all devices)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/escpos/escpos.

1. Fork it ( https://github.com/escpos/escpos/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
