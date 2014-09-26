require_relative "../Wordsearch"
require "FileUtils"
require "rspec_candy/helpers"
Dir.chdir(File.dirname(__FILE__))

context "set up" do
    before(:each) do
        FileUtils.rm "../grid.csv" if File.exist?("../grid.csv")
    end
    specify "generate grid should create a new csv" do
        wordsearch = Wordsearch.new
        wordsearch.generate_grid
        expect(File.exist?("./grid.csv")).to eq(true)
    end
end

context "Using the sample wordsearch grid" do
    before(:each) do
        Wordsearch.stub_any_instance(:generate_grid => "./grid_sample.csv")
    end

    specify "The output results file should match the sample output results file" do
        wordsearch = Wordsearch.new.main
        a = File.read("./results.txt")
        b = File.read("./results_sample.txt")
        expect(a == b).to eq(true)
    end
end


context "Individual Methods testing" do
    before(:each) do
        @lookup_array = Wordsearch.new.cleanse_dictionary
    end

    specify "Cleanse dictionary should remove all words larger than specified limit" do
        @lookup_array.each do |word|
            fail if word.length > 10
        end

    end

    specify "find_dictionary_words method should match on dictionary words partially matched in input string" do
        result = Wordsearch.new.find_dictionary_words(%w(XXXTESTXXX), @lookup_array)
        expect(result).to eq([%w(ES TEST)])
    end

    specify "transform_lr_to_rl method should correctly flip input array" do
        result = Wordsearch.new.transform_lr_to_rl(%w(ABANDONERS))
        expect(result).to eq(%w(SRENODNABA))
    end

    specify "transform_vertically method should correctly transfory input array" do
        sample_input= %w(AAAAAAAAAA BBBBBBBBBB CCCCCCCCCC DDDDDDDDDD EEEEEEEEEE FFFFFFFFFF GGGGGGGGGG HHHHHHHHHH IIIIIIIIII JJJJJJJJJJ)
        expected_output= %w(ABCDEFGHIJ ABCDEFGHIJ ABCDEFGHIJ ABCDEFGHIJ ABCDEFGHIJ ABCDEFGHIJ ABCDEFGHIJ ABCDEFGHIJ ABCDEFGHIJ ABCDEFGHIJ)
        result = Wordsearch.new.transform_vertically(sample_input)
        expect(result).to eq(expected_output)
    end
end