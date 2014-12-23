require 'rspec'
require 'two_sum'

describe Array do

  describe 'two_sum' do

    it 'two_sum method return an an empty array if no array is given' do
      expect([].two_sum).to eq([])
    end

    it 'should return an empty array if none of els sum up to zero' do
      expect([-1,0,2,-1].two_sum).to eq([])
    end

    it 'should return an array of pairs that sum up to zero' do
      expect([-1, 0, 2, -2, 1].two_sum).to eq([[0,4], [2,3]])
    end
  end
end
