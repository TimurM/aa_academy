require 'rspec'
require 'remove_dups.rb'


describe Array do

  describe 'remove_dups' do

      it 'should have a method uniq that removes duplicates' do
      end


      it 'should return an empty array if array is empty' do

        expect([].uniq).to eq([])
      end

      it 'should return an array with no duplicates' do
        expect([1, 2, 1, 3, 3].uniq).to eq([1, 2, 3])
      end

  end

end
