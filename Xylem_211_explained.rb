# As we're starting in upper left corner of the initial character, there is only one route
# which visits every point of the character exactly once and is repeating:
#
#   *   * >
#   v   ^
#   *   *
#   v   ^
#   * > *
#
# We start by encoding each character as a 6-bit number. Together with the route we take,
# the initial encoding scheme is as follows:
#
#   0   5 >
#   v   ^
#   1   4
#   v   ^
#   2 > 3
#
# Then, we create a string with each character of the alphabet being present at the n-th index,
# according to its encoded number. The resulting string is:
#     ' a,b.k-l-ą-ł-u-v-e-h-o-rLę---z---cif-msp-ćś-óxźż-djg-ntq-ńw-Ny--'
# The capital N in the string denotes the "number follows" special character
# and "L" - "letter follows". Dashes are empty codepoints.
# We also create a string with the order of steps required to take after each n-th bit of the
# character:
#     'vv>^^>'
#
# The original lookup string contains two empty codepoints at the end that can be trimmed off,
# resulting in a 62 character long string.
# However, by reshuffling order of bits at which each Braille letter point is encoded, we can
# move more empty codepoints to the end of the string, with 12 orderings being 58 characters
# long. We pick one of the two, which have '>>vv^^' step order:
#     ' -.-ackm,i-sbflp---óąćux-ś-źł-vż----edon-j-thgrqL--Nęńzy-w'

puts ARGV[0]
  .gsub(/\d[,-9]*/,'N\0L') # we substitute each occurrence of a number-like string
                           # (number followed by numbers, periods or commas) with
                           # the same string enclosed with "number follows" and "letter follows"
                           # special characters. We exploit RegExp ranges to save one character
                           # by using [,-9] range (which includes - and / characters) instead of
                           # more correct [\d,.], as we're guaranteed to not have these extra
                           # characters in the input.
  .gsub(/L(?= |$)/,'') # The previous operation added "letter follows" characters where they're
                       # not supposed to be, so we remove them if they're in front of a space
                       # or at the end of the string.
  .tr('0-9','ja-i') # Exploiting range support of `tr` method, we substitute all numbers with
                    # corresponding letters.
  .gsub(/./){|x| # We replace each character of the input with its Braille command.
    '231450'.gsub(/./){|n| # We replace each bit of the given letter with action
                           # (punch or no punch and next step).
      n=n.to_i # Parsing bit number to integer to be able to use it in mathematical operations.
      '*'*(' -.-ackm,i-sbflp---óąćux-ś-źł-vż----edon-j-thgrqL--Nęńzy-w'.index(x)>>n&1)+
          # We lookup the index of the given character and decide if we need to punch or not based
          # on the n-th bit.
      '>v^'[n/2] # By choosing ordering with '>>vv^^' path, we can save one character by exploiting
                 # Ruby's integer division instead of having to use '>>vv^^'[n].
    }
  }
