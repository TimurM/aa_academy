
class Array

  def uniq
    uniq_array = []

    self.each do |num|
      uniq_array << num unless uniq_array.include?(num)
    end

    uniq_array
  end


end

# p [1, 2, 1, 3, 3].uniq
