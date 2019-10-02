[Build Status](https://gitlab.com/escpos/escpos/pipelines)

# Escpos

A ruby implementation of ESC/POS (thermal) printer command specification.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'escpos'

# see https://github.com/escpos/escpos-image
gem 'escpos-image' # add this if you want to print images
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install escpos

## Image support

To keep this gem lightweight and modular image support was implemented in another gem:

https://github.com/escpos/escpos-image

```ruby
# Add this line to your application's Gemfile if you want to print images
gem 'escpos-image'
# And depending on your image processor of choice
gem 'mini_magick'
# or
gem 'chunky_png'
```
Or install it yourself as:
```
gem install escpos-image
# and then depending on your image processor of choice
gem install mini_magick
# or
gem install chunky_png
```

__For more information about image processors, their options and supported formats please see https://github.com/escpos/escpos-image readme file.__

## Examples

![](https://github.com/escpos/escpos/blob/master/examples/IMG_20160608_001339_HDR.jpg)
![](https://github.com/escpos/escpos/blob/master/examples/IMG_20160610_161302_HDR.jpg)
![](https://github.com/escpos/escpos/blob/master/examples/IMG_20160610_204358_HDR.jpg)
![](https://github.com/escpos/escpos-image/blob/master/examples/IMG_20160610_232415_HDR.jpg)

## Basic usage

```ruby
@printer = Escpos::Printer.new
@printer << "Some text"
@printer << Escpos::Helpers.big "Big text"

@printer.to_escpos # returns ESC/POS data ready to be sent to printer
# on linux this can be piped directly to /dev/usb/lp0
# with network printer sent directly to printer socket
# with serial port printer it can be sent directly to the serial port

@printer.to_base64 # returns base64 encoded ESC/POS data
```

## Report class usage

```ruby
# my_report.rb:

class MyReport < Escpos::Report
  def item(text)
    @count ||= 0
    @count += 1
    bold "#{@count}. #{text}"
  end

  def order
    options[:order]
  end
end
```

```erb
<% # my_report.erb: %>

<%= big "Order number #{order[:number]}" %>
<%= item "First item" %>
<%= item "Second item" %>
<%= item "Third item" %>
```

```ruby
report = MyReport.new 'path/to/my_report.erb', {
  order: { number: 123 }
}
@printer << report.render
@printer.cut!

@printer.to_escpos # returns ESC/POS data ready to be sent to printer
# on linux this can be piped directly to /dev/usb/lp0
# with network printer sent directly to printer socket
# with serial port printer it can be sent directly to the serial port

@printer.to_base64 # returns base64 encoded ESC/POS data
```

## Available helper methods

| Method name | Description |
| --- | --- |
| **text** | Normal text formatting |
| **encode** | Encode text for the printer |
| **encoding, set_encoding, set_printer_encoding** | Set printer encoding |
| **double_height** | Double height text |
| **quad_text, big, title, header, double_width_double_height, double_height_double_width** | Double width & Double height text |
| **double_width** |Double width text |
| **underline, u** | Underlined text |
| **underline2, u2** | Stronger underlined text |
| **bold, b** | Bold text |
| **left** | Align to left |
| **right** | Align to right |
| **center** | Align to center |
| **invert, inverted** | Color inverted text |
| **black, default_color, color_black, black_color** | Default Color (Usually black) |
| **red, alt_color, alternative_color, color_red, red_color** | Alternative Color (Usually Red) |
| **barcode** | Print barcode |
| **partial_cut** | Partially cut the paper (may not be available on all devices) |
| **cut** | Fully cut the paper (may not be available on all devices) |

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/escpos/escpos.

1. Fork it ( https://github.com/escpos/escpos/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
