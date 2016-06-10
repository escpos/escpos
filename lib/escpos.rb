require "escpos/version"
require "escpos/printer"
require "escpos/helpers"
require "escpos/report"

module Escpos

  # Printer hardware
  HW_INIT                      = [ 0x1b, 0x40 ]             # Clear data in buffer and reset modes
  HW_SELECT                    = [ 0x1b, 0x3d, 0x01 ]       # Printer select
  HW_RESET                     = [ 0x1b, 0x3f, 0x0a, 0x00 ] # Reset printer hardware

  # Feed control sequences
  CTL_LF                       = [ 0x0a ]                   # Print and line feed
  CTL_FF                       = [ 0x0c ]                   # Form feed
  CTL_CR                       = [ 0x0d ]                   # Carriage return
  CTL_HT                       = [ 0x09 ]                   # Horizontal tab
  CTL_VT                       = [ 0x0b ]                   # Vertical tab

  # Paper
  PAPER_FULL_CUT               = [ 0x1d, 0x56, 0x00 ]			   # Full paper cut 
  PAPER_PARTIAL_CUT            = [ 0x1d, 0x56, 0x01 ]			   # Partial paper cut

  # Cash Drawer
  CD_KICK_2                    = [ 0x1b, 0x70, 0x00 ]			   # Send pulse to pin 2
  CD_KICK_5                    = [ 0x1b, 0x70, 0x01 ]			   # Send pulse to pin 5

  # Text formating
  TXT_NORMAL                   = [ 0x1b, 0x21, 0x00 ]        # Normal text
  TXT_2HEIGHT                  = [ 0x1b, 0x21, 0x10 ]        # Double height text
  TXT_2WIDTH                   = [ 0x1b, 0x21, 0x20 ]        # Double width text
  TXT_4SQUARE                  = [ 0x1b, 0x21, 0x30 ]        # Quad area text
  TXT_UNDERL_OFF               = [ 0x1b, 0x2d, 0x00 ]        # Underline font OFF
  TXT_UNDERL_ON                = [ 0x1b, 0x2d, 0x01 ]        # Underline font 1
  TXT_UNDERL2_ON               = [ 0x1b, 0x2d, 0x02 ]        # Underline font 2
  TXT_BOLD_OFF                 = [ 0x1b, 0x45, 0x00 ]        # Bold font OFF
  TXT_BOLD_ON                  = [ 0x1b, 0x45, 0x01 ]        # Bold font ON
  TXT_FONT_A                   = [ 0x1b, 0x4d, 0x00 ]        # Font type A
  TXT_FONT_B                   = [ 0x1b, 0x4d, 0x01 ]        # Font type B
  TXT_ALIGN_LT                 = [ 0x1b, 0x61, 0x00 ]        # Left justification
  TXT_ALIGN_CT                 = [ 0x1b, 0x61, 0x01 ]        # Centering
  TXT_ALIGN_RT                 = [ 0x1b, 0x61, 0x02 ]        # Right justification

  # Barcodes
  BARCODE_TXT_OFF             = [ 0x1d, 0x48, 0x00 ]         # HRI barcode chars OFF
  BARCODE_TXT_ABV             = [ 0x1d, 0x48, 0x01 ]         # HRI barcode chars above
  BARCODE_TXT_BLW             = [ 0x1d, 0x48, 0x02 ]         # HRI barcode chars below
  BARCODE_TXT_BTH             = [ 0x1d, 0x48, 0x03 ]         # HRI barcode chars both above and below
  BARCODE_FONT_A              = [ 0x1d, 0x66, 0x00 ]         # Font type A for HRI barcode chars
  BARCODE_FONT_B              = [ 0x1d, 0x66, 0x01 ]         # Font type B for HRI barcode chars
  BARCODE_HEIGHT              = [ 0x1d, 0x68 ]               # Barcode Height (1 - 255)
  BARCODE_WIDTH               = [ 0x1d, 0x77 ]               # Barcode Width (2 - 6)
  BARCODE_UPC_A               = [ 0x1d, 0x6b, 0x00 ]         # Barcode type UPC-A
  BARCODE_UPC_E               = [ 0x1d, 0x6b, 0x01 ]         # Barcode type UPC-E
  BARCODE_EAN13               = [ 0x1d, 0x6b, 0x02 ]         # Barcode type EAN13
  BARCODE_EAN8                = [ 0x1d, 0x6b, 0x03 ]         # Barcode type EAN8
  BARCODE_CODE39              = [ 0x1d, 0x6b, 0x04 ]         # Barcode type CODE39
  BARCODE_ITF                 = [ 0x1d, 0x6b, 0x05 ]         # Barcode type ITF
  BARCODE_NW7                 = [ 0x1d, 0x6b, 0x06 ]         # Barcode type NW7

  # Images
  IMAGE                      = [ 0x1d, 0x76, 0x30, 0x00 ]    # Start image pixel data

  # Transforms an array of codes into a string
  def sequence(arr_sequence)
    arr_sequence.pack('U*')
  end
  module_function :sequence

end
