require "ffi/aspell"

module Soggle
  class Board
    attr_reader :height, :width

    def initialize(board,speller=::FFI::Aspell::Speller.new("en_US"))
      @board=parse(board)
      @width=@board.first.length
      @height=@board.length
      @speller=speller
    end

    def fetch(x,y)
      @board[y][x]
    end

    def adjacent_coordinates_of(x,y)
      xrange = ([0, x-1].max..[x+1, width-1 ].min)
      yrange = ([0, y-1].max..[y+1, height-1].min)
      [].tap do |coordinates|
        yrange.each do |y|
          xrange.each do |x|
            coordinates << [x,y]
          end
        end
        coordinates.delete [x,y]
      end
    end

    def adjacents_hash(x,y)
      {}.tap do |hash|
        adjacent_coordinates_of(x,y).each do |coordinate|
          hash[coordinate]=fetch(*coordinate)
        end
      end
    end

    def paths_from(x,y,options={})
      max_length=options.fetch(:max_length,width*height)
      ignore=options.fetch(:ignore,[])
      [].tap do |paths|
        case max_length
        when 1
          paths << [[x,y]]
        when 2
          adjs=adjacent_coordinates_of(x,y)-ignore
          adjs.each do |adj|
            paths <<  [[x,y],adj]
          end
          paths << [[x,y]] if adjs.empty?
        else
          adjs=adjacent_coordinates_of(x,y)-ignore
          adjs.each do |adj|
            paths_from(*adj,max_length:max_length-1,ignore:ignore+[[x,y]]).each do |path|
              paths << path.insert(0,[x,y])
            end
          end
          paths << [[x,y]] if adjs.empty?
        end
      end
    end

    def longest_strings_from(x,y,options={})
      max_length=options.fetch(:max_length,width*height)
      paths_from(x,y,max_length:max_length).map do |path|
        path.reduce('') {|string,coordinate|string<<fetch(*coordinate).to_s}
      end
    end

    def all_strings_from(x,y,options={})
      max_length=options.fetch(:max_length,width*height)
      longest_strings=longest_strings_from(x,y,max_length:max_length)
      [].tap do |strings|
        longest_strings.each do |string|
          1.upto(string.length) { |n| strings << string[0,n] }
        end
      end
    end

    def all_strings(options={})
      max_length=options.fetch(:max_length,width*height)
      [].tap do |strings|
        each_coordinate do |x,y|
          strings.push( *all_strings_from(x,y,max_length:max_length) )
        end
      end.uniq!
    end

    def find_words(options={})
      max_length=options.fetch(:max_length,width*height)
      all_strings(max_length:max_length).select do |string|
        check_word(string)
      end
    end

    def each_coordinate
      height.times do |y|
        width.times do |x|
          yield x, y
        end
      end
    end

    protected
    def check_word(string)
      string.gsub!(/q/i,'qu')
      @speller.correct?(string) && (string.length>1 or string=='a') && (string.length>2 or valid_bi_letter(string))
    end

    def valid_bi_letter(string)
      %w[
        AA AB AD AE AG AH AI AL AM AN
        AR AS AT AW AX AY BA BE BI BO
        BY DE DO ED EF EH EL EM EN ER
        ES ET EX FA FE GO HA HE HI HM
        HO ID IF IN IS IT JO KA KI LA
        LI LO MA ME MI MM MO MU MY NA
        NE NO NU OD OE OF OH OI OM ON
        OP OR OS OW OX OY PA PE PI QUI
        RE SH SI SO TA TI TO UH UM UN
        UP US UT WE WO XI XU YA YE YO
        ZA
      ].include?(string.upcase)
    end

    def parse(board)
      case board
      when String
        parse_string board
      when Array
        parse_array board
      else
        raise InvalidBoardError, "board was not a string or array."
      end
    end

    def parse_string(board)
      board.gsub!(/[^a-z\n]/i,'') #clean out non-alpha characters
      raise InvalidBoardError, "empty string." if board.empty?
      [].tap do |array|
        width=nil
        board.each_line do |line|
          line.strip!
          raise InvalidBoardError, "uneven row lengths." if line.length != width||=line.length
          array << parse_row_string(line)
        end
      end
    end

    def parse_array(board)
      raise InvalidBoardError, "empty array" if board.empty?
      case board.first
      when Array
        raise InvalidBoardError, "uneven row lengths" unless check_array_row_lengths(board)
        return board.dup
      when String
        width=nil
        return board.map do |row|
          row.gsub! /[^a-z]/i, ''
          raise InvalidBoardError, "uneven row lengths." if row.length != width||=row.length
          parse_row_string(row)
        end
      end
    end

    def parse_row_string(string)
      string.split ''
    end

    def check_array_row_lengths(board)
      begin
        board.transpose # transpose require even row lengths
      rescue IndexError => e
        if e.message=~/size differs/ then
          return false
        else
          raise e
        end
      else
        true
      end
    end
  end

  class InvalidBoardError < ArgumentError
    def initialize(message='')
      super("invalid board description. " << message)
    end
  end

end
