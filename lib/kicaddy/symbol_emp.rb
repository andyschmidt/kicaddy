module KiCaddy
=begin
EESchema-LIBRARY Version 2.4
#encoding utf-8
#
# esp32DevKitC
#
DEF esp32DevKitC U 0 40 Y Y 1 F N
F0 "U" 100 1100 50 H V C CNN
F1 "esp32DevKitC" 150 350 50 H V C CNN
F2 "" 100 1100 50 H I C CNN
F3 "" 100 1100 50 H I C CNN
DRAW
S -150 1050 450 400 0 1 0 N
# RECTANGLE
# S startx starty endx endy unit convert thickness cc
# • unit = 0 if common to the parts; if not, number of part (1. .n).
# • convert = 0if common to all parts. If not, number of the part (1. .n).
# • thickness = thickness of the outline.
# • cc = N F or F ( F = filled Rectangle,; f = . filled Rectangle, N = transparent backgroun


X 3v3 1 -250 900 100 R 50 50 1 1 I
# Description of pins
# Format:
# X name number posx posy length orientation Snum Snom unit convert Etype [shape].
# With:
# • orientation = U (up) D (down) R (right) L (left).
# • name = name (without space) of the pin. if ~: no name
# • number = n pin number (4 characters maximum).
# • length = pin length.
# • Snum = pin number text size.
# • Snom = pin name text size.
# • unit = 0 if common to all parts. If not, number of the part (1. .n).
# • convert = 0 if common to the representations, if not 1 or 2.
# • Etype = electric type (1 character)
# • shape = if present: pin shape (clock, inversion…).

X GND 10 550 900 100 L 50 50 1 1 I
X GPIO_0 2 -250 800 100 R 50 50 1 1 I
X GPIO_1 3 -250 700 100 R 50 50 1 1 I
X GPIO_2 4 -250 600 100 R 50 50 1 1 I
X GPIO_3 5 -250 500 100 R 50 50 1 1 I
X VCC 6 550 500 100 L 50 50 1 1 I
X clk 7 550 600 100 L 50 50 1 1 I
X sda 8 550 700 100 L 50 50 1 1 I
X RST 9 550 800 100 L 50 50 1 1 I
ENDDRAW
ENDDEF
#
#End Library
=end
  class SymbolEmp

    attr_accessor :pkg_type, :pins, :pin_len, :pitch, :spacing

    def pin(index, label, x, y, direction='R')
      "X #{label} #{index} #{x} #{-y} #{pin_len} #{direction} 50 50 1 1 I"
    end

    def rectangle()
      sx = pin_len
      sy = pin_len
      ex = spacing - pin_len
      ey = pins.length/2 * pitch + pin_len
      "S #{sx} #{sy} #{ex} #{-ey} 0 1 0 N"
    end

    def header
      h =<<EOS
EESchema-LIBRARY Version 2.4
#encoding utf-8
#
# SYMBOL_NAME
#
DEF SYMBOL_NAME U 0 40 Y Y 1 F N
F0 "U" 100 100 50 H V C CNN
F1 "SYMBOL_NAME" 150 200 50 H V C CNN
F2 "" 100 1100 50 H I C CNN
F3 "" 100 1100 50 H I C CNN
EOS
      h.gsub!(/SYMBOL_NAME/, @name)
      h
    end

    def footer
      f =<<EOS
ENDDEF
#
#End Library
EOS
    end

    def draw
      d = [ "DRAW"]
      d << rectangle

      x = 0
      m = mapping
      m[0..m.length / 2 - 1].each_with_index do |p, i|
        d << pin(p[0], p[1], x, i * pitch, 'R')
      end
      x = spacing
      m[m.length / 2..-1].each_with_index do |p, i|
        d << pin(p[0], p[1], x, i * pitch, 'L')
      end

      d << "ENDDRAW"
      d.join("\n")
    end

    def mapping
      num_pins = pins.length
      if pkg_type == 'DIP'
        map = (1..num_pins / 2).to_a.map{|p| [ p, pins[p-1] ] }
        map.concat (num_pins / 2 + 1..num_pins).to_a.map{|p| [ p, pins[p-1] ] }.reverse
      else

        #@mappings = (1..@num_pads).to_a
      end
      map
    end

    def to_s
      s = [ header ]
      s << draw
      s << footer
    end

    def initialize(name, *pins)
      @name = name
      @pins = pins
      @pkg_type = 'DIP'
      @pitch = 100
      @spacing = 800
      @pin_len = 100
    end
  end
end