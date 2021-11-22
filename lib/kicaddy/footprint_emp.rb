module KiCaddy
  class FootprintEmp

    def Pad(num, x, y)
      s = <<EOS
$PAD
Sh "PADNUM" C 900 900 0 0 0
Dr 400 0 0
At STD N 0000FFFF
Ne 0 ""
Po XPOS YPOS
$EndPAD
EOS
      s.gsub!(/PADNUM/, num.to_s)
      s.gsub!(/XPOS/, x.to_s)
      s.gsub!(/YPOS/, y.to_s)
      s
    end

    def to_s
      s = ["PCBNEW-LibModule-V1  07-02-2012 08:54:12"]
      s << "# encoding utf-8"
      s << index
      s << sec_module
      s << "$EndLIBRARY"
#
# End Module
    end

    def initialize(name, prefs)

      @name = name
      @pkg_type = prefs.fetch(:pkg_type) rescue 'DIP'
      @pitch = 2.54.to_tmils

      @padding = prefs.fetch(:padding).to_tmils rescue 2.0.to_tmils.to_i

      @spacing = prefs.fetch(:spacing).to_tmils.round rescue (6 * @pitch)

      @pad_size = 2.28.to_tmils
      @drill_dia = 1.1.to_tmils
      @pads = []


      @num_pads = prefs.fetch(:num_pads) rescue 8
      if @pkg_type == 'DIP'
        @mappings = (1..@num_pads / 2).to_a
        @mappings.concat (@num_pads / 2 + 1..@num_pads).to_a.reverse
      else

        #@mappings = (1..@num_pads).to_a
      end

      @frame_height = ((( @num_pads / 2 -1 ) * @pitch) + @padding).to_i
      @frame_width = (@spacing + @padding).to_i


    end

    def index
      "$INDEX\n#{@name}\n$EndINDEX"
    end

    def sec_module
      m = []
      m << "$MODULE #{@name}"
      m << "Po 0 0 0 15 4F309929 00000000 ~~" # Po Xpos Ypos Orientation(0.1deg) Layer TimeStamp Attribut1 Attribut2
      #      Attribut1 = ~ or 'F' for autoplace (F = Fixed, ~ = moveable)
      #      Attribut2 = ~ or 'P' for autoplace (P = autoplaced)
      m << "Li #{@name}" # module Lib name
      m << "Cd #{@name}" # Comment Description
      m << "Kw #{@pkg_type}" # Keyword
      m << "Sc 00000000" # Timestamp
      m << "AR #{@name}"
      m << "Op 0 0 0" # Rotation cost
      m << "T0 0 -1500 600 600 0 120 N V 21 \"U\"" # T<field number> <Xpos> <Ypos> <Xsize> <Ysize> <rotation> <penWidth> N <visible> <layer> "text"
      m << "T1 0 -500 600 600 0 120 N V 21 \"VAL**\""
      # this part is for drawing the frame
      m << "DS -#{@padding} -#{@padding} #{@frame_width} -#{@padding} 120 21" # (DRAW Segment) DS Xstart Ystart Xend Yend Width Layer
      m << "DS -#{@padding} -#{@padding} -#{@padding} #{@frame_height} 120 21"
      m << "DS -#{@padding} #{@frame_height} #{@frame_width} #{@frame_height} 120 21"
      m << "DS #{@frame_width} -#{@padding} #{@frame_width} #{@frame_height} 120 21"
      m << "DC -1450 0 -1150 0 120 21" # (Draw Circle) DC Xcentre Ycentre Xpoint Ypoint Width Layer
      m << "\n"
      pads { |p| m << p }
      m << "$EndMODULE #{@name}"
      m.join("\n")
    end

    def pads(&block)
      x = 0
      @mappings[0..@mappings.length / 2 - 1].each_with_index do |m, i|
        yield Pad(m, x, i * @pitch)

      end
      x = @spacing
      @mappings[@mappings.length / 2..-1].each_with_index do |m, i|
        yield Pad(m, x, i * @pitch)
      end
    end
  end
end