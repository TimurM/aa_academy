class WordChainer

  attr_accessor :dictionary

  def initialize(dictionary = File.readlines('dictionary.txt'))
    @dictionary = dictionary.map {|word| word.chomp }
    @start_time = Time.now
  end

  def adjacent_words(word)
    adjacent_words = []

    i = 0
    while i < word.length

      @dictionary.each do |dword|
        if dword.length == word.length
            if (dword[0...i] + dword[i+1..-1]) == (word[0...i] + word[i+1..-1])
              adjacent_words << dword
            end
        end
      end
      i += 1
    end
    adjacent_words.uniq
  end

  def run(source, target)
    @current_words = [source]
    @all_seen_words = {source => nil}

    until @current_words.empty?
      new_current_words = []

      explore_current_words(new_current_words)

      # new_current_words.each do |new_word|
      #   puts "The word #{new_word} came from: #{@all_seen_words[new_word]}"
      # end

      # print new_current_words
      @current_words = new_current_words
    end
    puts "Buildings a chain"
    puts build_path(target)
    end_time = Time.now
    puts "#{end_time - @start_time} seconds ---"
  end

  def explore_current_words(new_current_words)

    @current_words.each do |word|
      # p @current_words
      adjacent_words_list = adjacent_words(word)
      # p adjacent_words_list
      adjacent_words_list.each do |adjacent_word|
        unless @all_seen_words.include?(adjacent_word)
          # p @all_seen_words
          new_current_words << adjacent_word
          @all_seen_words[adjacent_word] = word
        end
      end
    end
    new_current_words
  end

  def build_path(target)
    path = [target]

    until @all_seen_words[target] == nil
      a = @all_seen_words[target]
      path << a
      target = a
    end

    path.reverse!
  end
end

a1 = WordChainer.new
# # a1.dictionary
# adjacent = a1.adjacent_words("duck")
# p adjacent
a1.run('duck', 'ruby')
