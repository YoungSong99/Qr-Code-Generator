require 'minitest/autorun'
require_relative '../qr_generator'

class QrGeneratorTest < Minitest::Test
  def setup
    @qr = QrGenerator.new
  end

  def test_valid_url
    @qr.url = "http://example.com"
    assert_equal "http://example.com", @qr.url
  end

  def test_invalid_url
    assert_output("url must start with 'http' or 'https', try again\n") { @qr.url = "example.com" }
    assert_nil @qr.url
  end

  def test_valid_code_color
    @qr.code_color = "red"
    assert_equal "red", @qr.code_color
  end

  def test_invalid_code_color
    assert_output("It is not a valid color. Try again\n") { @qr.code_color = "invalid_color" }
  end

  def test_valid_background_color
    @qr.background_color = "blue"
    assert_equal "blue", @qr.background_color
  end

  def test_file_name_format
    @qr.file_name = "My QR Code"
    assert_equal "My_QR_Code.png", @qr.file_name
  end
end
