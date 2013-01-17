require 'forwardable'

module Soggle
  class WordlistWrapper
    extend Forwardable

    def initialize(file,encoding_options='iso-8859-1:utf-8')
      case file
      when String
        @file=File.open(file, "r:#{encoding_options}")
      else
        @file=file
      end
    end

    def_delegators :@file, :each, :rewind, :close, :closed?
    def_delegators :'words', :any?, :select, :none?

    def words(&block)
      begin
        rewind
        Enumerator.new do |result|
          each do |line|
            formatted_line=line.strip.downcase
            result<<formatted_line
            block.call(formatted_line) if block
          end
        end
      ensure
        rewind
      end
    end

    def any_starts_with? (string)
      words.any?{|line| line.start_with?(string)}
    end

    def words_starting_with(string)
      words.select{|word| word.start_with?(string)}
    end

    def completion_options(string)
      words_starting_with(string).each_with_object([]) do |word, array|
        if word == string then
          array << '!'
        else
          letter=word[string.length]
          array << letter unless array.include?(letter)
        end
      end
    end


  end
end
