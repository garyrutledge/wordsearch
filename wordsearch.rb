#!/usr/bin/env ruby
class Wordsearch
    def initialize
        require 'csv'
        @dictionary = "./dict.txt"
        @word_length = 10
        Dir.chdir(File.dirname(__FILE__))
    end

    def random_char
        (65 + rand(25)).chr
    end

    def generate_grid
        grid_path = "./grid.csv"
        CSV.open(grid_path, 'w') do |output_csv|
            @word_length.times do
                output_csv << Array.new(@word_length) { random_char }
            end
        grid_path
        end

    end


    def retrieve_first_word(string)
        string.match("[^\s]+")[0]
    end

    def cleanse_dictionary
        lookup_array = []
        File.open(@dictionary).each do |line|
            dictionary_word = retrieve_first_word(line)
            lookup_array << dictionary_word unless dictionary_word.size > @word_length
        end
        lookup_array
    end

    def retrieve_words_from_grid(grid_path)
        horizontal_l_to_r_words = []
        CSV.read(grid_path).each do |row|
            horizontal_l_to_r_words << row.join(",").gsub(",", "")
        end
        horizontal_l_to_r_words
    end

    def partial_include?(reference_array, input_string)
        x = []
        reference_array.each do |e|
            x << e if input_string.include?(e.to_s)
        end
        x
    end

    def find_dictionary_words(grid_words, lookup_array)
        matched_words = []
        grid_words.each do |grid_word|
            matched_words << partial_include?(lookup_array, grid_word) if partial_include?(lookup_array, grid_word)
        end
        matched_words
    end

    def transform_lr_to_rl(l_to_r_words)
        r_to_l_words = []
        l_to_r_words.each do |l_to_r_word|
            r_to_l_words << l_to_r_word.reverse
        end
        r_to_l_words
    end

    def transform_vertically(horizontal_words)
        vertical_words = []
        i = 0
        @word_length.times do
            single_word = []
            horizontal_words.each do |l|
                single_word << l[i]
            end
            vertical_words << single_word.join(",").gsub(",", "")
            i = i + 1
        end
        vertical_words
    end

    def write_results_to_file(horizontal_l_to_r, horizontal_l_to_r_matches, horizontal_r_to_l_matches, vertical_l_to_r_matches, vertical_r_to_l_matches)
        File.open("./results.txt", 'w') { |f|
            f.puts "Word Search #{@word_length} * #{@word_length} \n\n"
            f.puts horizontal_l_to_r
            f.puts ""
            f.puts "Horizontal Left To Right Words Found:"
            f.puts horizontal_l_to_r_matches
            f.puts ""
            f.puts "Horizontal Right To Left Words Found:"
            f.puts horizontal_r_to_l_matches
            f.puts ""
            f.puts "Vertical Left To Right Words Found:"
            f.puts vertical_l_to_r_matches
            f.puts ""
            f.puts "Vertical Right To Left Words Found:"
            f.puts vertical_r_to_l_matches
        }
    end

    def main
        grid_path = generate_grid
        lookup_array = cleanse_dictionary

        horizontal_l_to_r = retrieve_words_from_grid(grid_path)
        horizontal_r_to_l = transform_lr_to_rl(horizontal_l_to_r)
        vertical_l_to_r = transform_vertically(horizontal_l_to_r)
        vertical_r_to_l = transform_lr_to_rl(vertical_l_to_r)

        horizontal_l_to_r_matches = find_dictionary_words(horizontal_l_to_r, lookup_array)
        horizontal_r_to_l_matches = find_dictionary_words(horizontal_r_to_l, lookup_array)
        vertical_l_to_r_matches = find_dictionary_words(vertical_l_to_r, lookup_array)
        vertical_r_to_l_matches = find_dictionary_words(vertical_r_to_l, lookup_array)

        write_results_to_file(horizontal_l_to_r, horizontal_l_to_r_matches, horizontal_r_to_l_matches,
                              vertical_l_to_r_matches, vertical_r_to_l_matches)

    end
end

word_search = Wordsearch.new
word_search.main
