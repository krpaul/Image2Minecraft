require "mini_magick"
require "yaml"

require './helpers/average.rb'
require './helpers/calculate.rb'

if ARGV.length != 2
    puts "Please provide two command-line arguments"
    exit
end

$src_image = ARGV[0]
$dest_image = ARGV[1]

def main
    # check if our averages are up to date
    check = check_avg
    if check != true
        # if not up to date recalculate
        puts "=== Calculating colour averages ==="
        re_average check
    end

    # load the colours
    c_avgs = YAML.load_file("averages.yml")

    # load the image
    puts "=== Loading image ==="
    image = MiniMagick::Image.open $src_image
    pixels = image.get_pixels
    
    # load averages
    averages = YAML.load_file "averages.yml"

    puts "=== Calculating new image ==="
    # new_pixels = Array.new(image.height) {Array.new(image.height)}
    new_pixels = []

    for row in 0...pixels.length
        for col in 0...pixels[row].length
            next if not pixels[row][col] 
            # calc new pixel
            new_pixels.append "imgs/" + (closest_match pixels[row][col], averages)
        end
    end

    puts "=== Constructing new image ==="
    MiniMagick::Tool::Montage.new do |montage|
        montage << "-mode" << "concatenate"
        montage << "-tile" << "#{image.width}x"
        montage.merge! new_pixels
        montage << $dest_image
    end
end

main