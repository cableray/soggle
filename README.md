# Soggle

'Soggle' is a portmanteau of 'Solve' and 'Boggle'.
Soggle solves boggle boards, and finds all possible
word combinations. Soggle has both a gem library and
an executable.

Soggle has a few technical challenges regarding graph-traversal
and other problems, and makes a good example of how dynamic-programming
techniques can improve algorithm performance.

## Installation

Add this line to your application's Gemfile:

    gem 'soggle'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install soggle

## Usage

To use the command line utility interactively:

    $ soggle enter grid

for more information:

    $ soggle help [command]

To use the soggle library:

    require 'soggle'  # unless you're using bundler

    #board format can be an array of strings, a multi-line string, or an array of arrays
    #strings are automatically stripped of non-alpha characters
    board=%w[
      abc
      def
      hij
      ]

    soggle=Soggle::Board.new(board)
    words=soggle.find_words


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
