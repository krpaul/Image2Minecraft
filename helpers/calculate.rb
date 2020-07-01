"""
    Returns the closest image match to a given pixel using RMS Scoring
"""
def closest_match(pixel, averages)
    fname = ""
    delta = 256 # highest possible rms

    averages.each do |filename, avg|
        rms = Math.sqrt(avg.subtract(pixel).square_each.calc_mean)

        if rms < delta
            delta = rms 
            fname = filename
        end
    end

    return fname
end

# helper methods
class Array
    def subtract(other_ary)
        self.map.with_index {|v, i| v-other_ary[i]}
    end  

    def square_each
        self.map {|v| v * v}
    end

    def calc_mean
        sum = 0
        self.each do |v|
            sum += v
        end

        return sum.to_f / self.length
    end
end  