class Array

  def two_sum
    positions = []

    (0..self.length-2).each do |i|
      (i+1...self.length).each do |v|
        if self[i] + self[v] == 0
          positions << [i,v]
        end
      end
    end
    positions
  end
end
