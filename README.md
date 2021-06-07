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
# with network printer sent directly to printer socket (see example below)
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
# with network printer sent directly to printer socket (see example below)
# with serial port printer it can be sent directly to the serial port

@printer.to_base64 # returns base64 encoded ESC/POS data
```

## Network printing
```ruby
require "socket"

printer = Escpos::Printer.new
printer << "Some text"

# change 1.2.3.4 and 9100 to match IP or host and port of the printer
socket = TCPSocket.new "1.2.3.4", 9100

socket.write printer.to_escpos
socket.close
```

## Available helper methods

| Method name | Description |
| --- | --- |
| **text** | Normal text formatting |
| **encoding, set_encoding, set_printer_encoding** | Set printer encoding (see example below) |
| **encode** | Encode text for the printer (see example below) |
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
| **barcode** | Print barcode (see example below) |
| **partial_cut** | Partially cut the paper (may not be available on all devices) |
| **cut** | Fully cut the paper (may not be available on all devices) |

## Encoding & diacritics

To print diacritics (accented characters) with ESC/POS two things have to be done. First the desired code page must be set on the printer (can be done using an ESC/POS command) and the desired text has to be encoded to the code page set on the printer.

```ruby
printer = Escpos::Printer.new
printer << Escpos::Helpers.set_printer_encoding(Escpos::CP_ISO8859_2)
printer << Escpos::Helpers.encode("This is UTF-8 to ISO-8859-2 text: ěščřžýáíéúů", encoding: "ISO-8859-2")
```
* List of available code pages for `set_printer_encoding`: https://github.com/escpos/escpos/blob/master/lib/escpos.rb#L30
* Options for `encoding` in `encode` helper: Anything listed in `Encoding.constants`

Some printers (e.g. Epson TM line) allow setting a default code page in printer setup, then the `set_printer_encoding` call can be omitted.

## Printing barcodes

The barcode helper accepts barcode data as first argument and an options hash as second.

Possible options:

| Option | Possible values | Description |
| --- | --- | --- |
| **format** | **Escpos::BARCODE_UPC_A**: Barcode type UPC-A <br> **Escpos::BARCODE_UPC_E**: Barcode type UPC-E <br> **Escpos::BARCODE_EAN13**: Barcode type EAN13 <br> **Escpos::BARCODE_EAN8**: Barcode type EAN8 <br> **Escpos::BARCODE_CODE39**: Barcode type CODE39 <br> **Escpos::BARCODE_ITF**: Barcode type ITF <br> **Escpos::BARCODE_NW7**: Barcode type NW7 | Type of barcode |
| **text_position** | **Escpos::BARCODE_TXT_OFF**: no text, only barcode <br> **Escpos::BARCODE_TXT_ABV**: text positioned above the barcode <br> **Escpos::BARCODE_TXT_BLW**: text positioned below the barcode <br> **Escpos::BARCODE_TXT_BTH**: text positioned both above and below the barcode | Text position |
| **height** | 1 to 255 | Barcode height |
| **width** | 2 to 6 | Barcode width |



```ruby
barcode_data = Escpos::Helpers.barcode("12345678", {
  format: Escpos::BARCODE_CODE39,
  text_position: Escpos::BARCODE_TXT_BLW,
  height: 50,
  width: 3
})
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/escpos/escpos.

1. Fork it ( https://github.com/escpos/escpos/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
