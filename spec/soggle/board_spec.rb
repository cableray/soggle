require 'spec_helper'

describe Soggle::Board do
  describe "initializing" do
    context "when board is empty" do
      context "when board is string" do
        board=""
        it "should raise exception" do
          expect{Soggle::Board.new board}.to raise_error ArgumentError
        end
      end
      context "when board is array" do
        board=""
        it "should raise exception" do
          expect{Soggle::Board.new board}.to raise_error ArgumentError
        end
      end
    end
    context "when board has uneven rows" do
      context "when board is string" do
        board= <<-BOARD
          abd
          defg
          hig
          BOARD
        it "should raise exception" do
          expect{Soggle::Board.new board}.to raise_error ArgumentError, /uneven row/
        end
      end
      context "when board is array" do
        board= [%w[a b c],
                %w[d e f g],
                %w[h i j]
                ]
        it "should raise exception" do
          expect{Soggle::Board.new board}.to raise_error ArgumentError, /uneven row/
        end
      end
      context "when board is string array" do
        board=%w[ abc
                  defg
                  hij
                ]
        it "should raise exception" do
          expect{Soggle::Board.new board}.to raise_error ArgumentError, /uneven row/
        end
      end
    end
    context "when board is valid string" do
      board= <<-BOARD
        abc
        def
        ghi
      BOARD
      it "should init without errors" do
        expect {Soggle::Board.new board}.to_not raise_error
      end
      subject {Soggle::Board.new board}
      its(:width){should be 3}
      its(:height){should be 3}

    end
  end
  describe "#fetch" do
    board=%w[ab
             cd]
    2.times do |j|
      2.times do |i|
        context "at coordinates #{i},#{j}" do
          let(:y){j}; let(:x){i}
          subject{Soggle::Board.new(board).fetch(x,y)}
          it{should eq(board[j][i]), "#{x},#{y}"}
        end
      end
    end
  end
  describe "#adjacent_coordinates_of" do
    board=%w[ abc
              def
              ghi]
    subject{Soggle::Board.new(board).adjacent_coordinates_of(x,y)}
    context "when coordinates 0,0" do
      let(:x){0};let(:y){0}
      it{should =~ [[0,1],[1,1],[1,0]]}
    end
    context "when coordinates 0,1" do
      let(:x){0};let(:y){1}
      it{should =~ [[0,0],[1,1],[1,0],[1,2],[0,2]]}
    end
    context "when coordinates 1,1" do
      let(:x){1};let(:y){1}
      it{should =~ [[0,0],[0,1],[0,2],[1,0],[1,2],[2,0],[2,1],[2,2]]}
    end
    context "when coordinates 2,2" do
      let(:x){2};let(:y){2}
      it{should =~ [[1,1],[2,1],[1,2]]}
    end
  end
  describe "#adjacents_hash" do
    board=%w[ abc
              def
              ghi ]
    subject{Soggle::Board.new(board).adjacents_hash(x,y)}
    context "when coordinates 1,1" do
      let(:x){1};let(:y){1}
      it{should eq({[0,0]=>'a',[0,1]=>'d',[0,2]=>'g',[1,0]=>'b',[1,2]=>'h',[2,0]=>'c',[2,1]=>'f',[2,2]=>'i'}) }
    end
  end
  describe "#paths_from" do
    board=%w[ ab
              cd ]
    subject{Soggle::Board.new(board).paths_from(0,0,max_length:max,ignore:ign)}
    context "when ignore:[]" do
      let(:ign){[]}
      context "when max_length:1" do
        let(:max){1}
        it{should =~ [[[0,0]]]}
      end
      context "when max_length:2" do
        let(:max){2}
        it{should =~ [ [[0,0],[0,1]], [[0,0],[1,0]], [[0,0],[1,1]], ]}
      end
      context "when max_length:3" do
        let(:max){3}
        it{should =~ [ [[0,0],[0,1],[1,0]], [[0,0],[0,1],[1,1]], [[0,0],[1,0],[0,1]], [[0,0],[1,0],[1,1]], [[0,0],[1,1],[0,1]], [[0,0],[1,1],[1,0]], ]}
      end
    end
    context "when ignore:[[1,1]]" do
      let(:ign){[[1,1]]}
      context "when max_length:2" do
        let(:max){2}
        it{should =~ [ [[0,0],[0,1]], [[0,0],[1,0]], ]}
      end
    end

  end
  describe "#longest_strings_from" do
    board=%w[ ab
              cd ]
    subject{Soggle::Board.new(board).longest_strings_from(0,0)}
    it {should =~ %w[abcd abdc acdb acbd adcb adbc]}
  end
  describe "#all_strings_from" do
    board="abcd"
    subject{Soggle::Board.new(board).all_strings_from(0,0)}
    it {should =~ %w[a ab abc abcd]}
  end
  describe "#all_strings" do
    board="abcd"
    subject{Soggle::Board.new(board).all_strings}
    it {should =~ %w[a ab abc abcd b ba bc bcd c cb cba cd d dc dcb dcba]}
  end
  describe "#find_words" do
    board="abigcatqit"
    subject{Soggle::Board.new(board).find_words}
    it {should =~ %w[ta ab bi big cat quit at it ti]}
  end
end
