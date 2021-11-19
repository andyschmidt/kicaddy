# KiCaddy
With KiCaddy you can easily create KiCad symbols and footprints for matrix boards.
All you need is a simple text file with the pin names.

Usage:
       kicaddy [options] <filename>

where [options] are:
  -s, --spacing=<s>    spacing (mm) of pin columns of footprint
  -o, --outdir=<s>     output directory for symbol and footprint file (default: /tmp/kicaddy)
  -n, --name=<s>       module name (default: kicaddy)
  -v, --version        Print version and exit
  -h, --help           Show this message
