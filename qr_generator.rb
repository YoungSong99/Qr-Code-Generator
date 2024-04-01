require 'rqrcode'

class QrGenerator
  attr_accessor :url, :code_color, :background_color, :size, :file_name

  def initialize(url: nil,
                 code_color: "black",
                 background_color: "white",
                 size:300,
                 file_name: "qr_code")
    self.url = nil
    self.code_color = code_color
    self.background_color = background_color
    self.size = size
    self.file_name = file_name
    @png = nil
  end

  # getter with validation

  def url=(url)
    return if url.nil?
    if not url.match?(/\A#{URI::regexp(['http', 'https'])}\z/)
      puts "url must start with 'http' or 'https', try again"
    else
      @url = url
    end
  end

  def valid_color?(color)
    color_list = ["black", "white", "red", "green", "blue", "yellow", "purple", "gray", "grey", "silver", "orange", "maroon", "olive", "lime", "aqua", "cyan", "teal", "navy", "fuchsia", "magenta", "pink", "peachpuff", "lavender", "plum", "indigo", "gold", "crimson", "turquoise"]
    color_list.include?(color)
  end

  def code_color=(color)
    if not valid_color?(color)
      puts "It is not a valid color. Try again"
    else
      @code_color = color
    end
  end

  def background_color=(color)
    if not valid_color?(color)
      puts "It is not a valid color. Try again"
    else
      @background_color = color
    end
  end

  def file_name=(file_name)
    name_without_space = file_name.gsub(/\s+/,"_")
    @file_name = name_without_space + ".png"
  end

  def size=(size)
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

  def run
    loop do
      puts "\nWelcome to the Qr Code Generator!"
      puts "\nColors and size are optional."
      puts "If you don't specify them, you will receive a code in black with a white background and a size of 300px."
      puts "\n1. Enter the url"
      puts "2. Enter the color of code"
      puts "3. Enter the color of background"
      puts "4. Enter the size of qr code image"
      puts "5. Enter the image file name"
      puts "6. Generate!"
      puts "7. Exit"
      print "Choose an option: "
      option = gets.chomp.to_i
      puts "\n"

      case option
      when 1
        puts "Enter your URL:"
        self.url = gets.chomp.downcase

      when 2
        puts "Available color options:"
        puts "black, white, red, green, blue, yellow, purple, gray, grey, silver, orange, maroon, olive, lime, aqua, cyan, teal, navy, fuchsia, magenta, pink, peachpuff, lavender, plum, indigo, gold, crimson, turquoise"
        puts "\nEnter the color of the code:"
        self.code_color = gets.chomp.downcase

      when 3
        puts "Available color options:"
        puts "black, white, red, green, blue, yellow, purple, gray, grey, silver, orange, maroon, olive, lime, aqua, cyan, teal, navy, fuchsia, magenta, pink, peachpuff, lavender, plum, indigo, gold, crimson, turquoise"
        puts "\nEnter the color of the background:"
        self.background_color = gets.chomp.downcase

      when 4
        puts "Enter the size of the QR code image:"
        self.size = gets.chomp.to_i

      when 5
        puts "Enter the file name:"
        self.file_name = gets.chomp

      when 6
        if @url.nil?
          puts "Please enter a URL first."
        else
          setup
          export
          puts "QR code generated and saved as #{@file_name}."
        end

      when 7
        puts "Existing..."
        break
      else
        puts "Invalid option. Please try again"
      end
    end
  end
end
