require "mini_magick"
require 'fileutils'

if ARGV.length == 0
    puts "provide a source dir"
    exit
end

src_folder = ARGV[0]
dest_folder = "./imgs/"

if not src_folder.end_with? "/" 
    src_folder += "/"
end

Dir.foreach(src_folder) do |fn|
    next if fn == '.' or fn == '..' or not fn.end_with? "png"
    # Do work on the remaining files & directories
    filename = src_folder + "/" + fn
    image = MiniMagick::Image.open(filename)
    
    next if image.height != image.width
    pixels = image.get_pixels

    transparent = false
    for p in pixels
        if p.include? [0,0,0]
            transparent = true 
            break
        end
    end

    if not transparent
        puts "Moving #{fn}"
        FileUtils.mv(filename, dest_folder + fn)
    end
end