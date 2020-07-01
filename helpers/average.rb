require "mini_magick"
require 'yaml'

"""
    Returns the average colour of all pixels
"""
def average(img)
    pixels = img.get_pixels

    tot = [0, 0, 0]
    num_pixels = img.height * img.width
    for row in pixels
        for p in row
            tot[0] += p[0]
            tot[1] += p[1]
            tot[2] += p[2]
        end
    end

    tot[0] /= num_pixels
    tot[1] /= num_pixels
    tot[2] /= num_pixels

    return tot
end

"""
    Recalculates the averages for the specified files
"""
def re_average(files)
    new_avg = {}
    for f in files
        img = MiniMagick::Image.open("imgs/" + f)
        new_avg[f] = average(img)
    end

    old_avg = YAML.load_file("averages.yml")

    combined = (old_avg == false) ? new_avg : (old_avg.merge new_avg)

    # write it all
    File.write('averages.yml', combined.to_yaml)
end

"""
    Makes sure the average.yaml file is up to date.
    Returns true if it is, and the name of the new files to hash if not
"""
def check_avg
    from_file = YAML.load(File.read("averages.yml"))

    file_names = Dir.entries("imgs/")
    file_names.delete "."
    file_names.delete ".."

    # if yaml empty
    if not from_file 
        return file_names.to_a
    end

    diff = file_names.to_a - from_file.keys
    
    return diff.length == 0 ? true : diff
end