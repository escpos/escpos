module Escpos
  module Helpers

    # Encodes UTF-8 string to encoding acceptable for the printer
    # The printer must be set to that encoding, defaults to ISO-8859-2
    # Available encodings can be listed in console using Encoding.constants
    def encode(data, opts = {})
      data.encode(opts.fetch(:encoding, 'ISO-8859-2'), 'UTF-8', {
        invalid: opts.fetch(:invalid, :replace),
        undef: opts.fetch(:undef, :replace),
        replace: opts.fetch(:replace, '?')        
      })
    end

    def text(data)
      [
        Escpos.sequence(TXT_NORMAL),
        data,
        Escpos.sequence(TXT_NORMAL),
      ].join
    end

    def double_height(data)
      [
        Escpos.sequence(TXT_2HEIGHT),
        data,
        Escpos.sequence(TXT_NORMAL),
      ].join
    end

    def quad_text(data)
      [
        Escpos.sequence(TXT_4SQUARE),
        data,
        Escpos.sequence(TXT_NORMAL),
      ].join
    end
    alias :big :quad_text
    alias :title :quad_text
    alias :header :quad_text
    alias :double_width_double_height :quad_text
    alias :double_height_double_width :quad_text

    def double_width(data)
      [
        Escpos.sequence(TXT_2WIDTH),
        data,
        Escpos.sequence(TXT_NORMAL),
      ].join
    end

    def underline(data)
      [
        Escpos.sequence(TXT_UNDERL_ON),
        data,
        Escpos.sequence(TXT_UNDERL_OFF),
      ].join
    end
    alias :u :underline

    def underline2(data)
      [
        Escpos.sequence(TXT_UNDERL2_ON),
        data,
        Escpos.sequence(TXT_UNDERL_OFF),
      ].join
    end
    alias :u2 :underline2

    def bold(data)
      [
        Escpos.sequence(TXT_BOLD_ON),
        data,
        Escpos.sequence(TXT_BOLD_OFF),
      ].join
    end
    alias :b :bold

    def left(data)
      [
        Escpos.sequence(TXT_ALIGN_LT),
        data,
        Escpos.sequence(TXT_ALIGN_LT),
      ].join
    end

    def right(data)
      [
        Escpos.sequence(TXT_ALIGN_RT),
        data,
        Escpos.sequence(TXT_ALIGN_LT),
      ].join
    end

    def center(data)
      [
        Escpos.sequence(TXT_ALIGN_CT),
        data,
        Escpos.sequence(TXT_ALIGN_LT),
      ].join
    end

    def barcode(data, opts = {})
      text_position = opts.fetch(:text_position, BARCODE_TXT_OFF)
      unless [BARCODE_TXT_OFF, BARCODE_TXT_ABV, BARCODE_TXT_BLW, BARCODE_TXT_BTH].include?(text_position)
        raise ArgumentError("Text position must be one of the following: BARCODE_TXT_OFF, BARCODE_TXT_ABV, BARCODE_TXT_BLW, BARCODE_TXT_BTH.")
      end
      height = opts.fetch(:height, 50)
      raise ArgumentError("Height must be in range from 1 to 255.") if height && (height < 1 || height > 255)
      width = opts.fetch(:width, 3)
      raise ArgumentError("Width must be in range from 2 to 6.") if width && (width < 2 || width > 6)
      [
        Escpos.sequence(text_position),
        Escpos.sequence(BARCODE_WIDTH),
        Escpos.sequence([width]),
        Escpos.sequence(BARCODE_HEIGHT),
        Escpos.sequence([height]),
        Escpos.sequence(opts.fetch(:format, BARCODE_EAN13)),
        data
      ].join
    end

    def partial_cut
      Escpos.sequence(PAPER_PARTIAL_CUT)
    end

    def cut
      Escpos.sequence(PAPER_FULL_CUT)
    end

  end
end
