require 'rqrcode'

class QrGenerator
  attr_accessor :url, :code_color, :background_color, :size, :file_name

  def initialize(url:,
                 code_color: "black",
                 background_color: "white",
                 size:300,
                 file_name: "qr_code")
    self.url = url
    self.code_color = code_color
    self.background_color = background_color
    self.size = size
    self.file_name = file_name
    @png = nil
  end

  # getter with validation

  def url=(url)
    unless url.match?(/\A#{URI::regexp(['http', 'https'])}\z/)
      raise TypeError, "url must start with 'http' or 'https'"
    end
    @url = url.to_s
  end

  def valid_color?(variable_name, color)
    color_list = ["black", "white", "red", "green", "blue", "yellow", "purple", "gray", "grey", "silver", "orange", "maroon", "olive", "lime", "aqua", "cyan", "teal", "navy", "fuchsia", "magenta", "pink", "peachpuff", "lavender", "plum", "indigo", "gold", "crimson", "turquoise"]
    if color_list.include?(color)
      instance_variable_set(variable_name, color)
    else
      puts "It is not valid color. Do you want to see the available color list? [Y/N]"
      ans = gets.chomp.upcase
      puts color_list if ans == 'Y'
    end
  end

  def code_color=(color)
    set_color(:@code_color, color)
  end

  def background_color=(color)
    set_color(:@background_color, color)
  end

  def file_name=(file_name)
    name_without_space = file_name.gsub(/\s+/,"_")
    @file_name = name_without_space
  end

  def size=(size)
    unless size.match?(/^\d+$/)
      raise TypeError, "please use number for size"
    end

    @size = size.to_i
  end

  # generating qr code using rqrcode gem
  def setup
    qr_code = RQRCode::QRCode.new(self.url)

    @png = qr_code.as_png(
      color: self.code_color,
      fill: self.background_color,
      size: self.size
    )

  end

  def export
    IO.binwrite(self.file_name, @png.to_s) unless @png.nil?
  end

end

