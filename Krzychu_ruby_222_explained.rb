
ARGV[0]
  .gsub(/(\d[\d,\.]*)([a-ż]*)/){|s|"#"+$1+($2==""?"":"!"+$2)}
  # Find all sequences of characters which are treated as numbers (starting with 0-9 and followed by [0-9 , .])
  # and inject special character # which is later translated into "number follows" Braille character at the beginning
  # and inject special character ! which is later translated into "letter follows" Braille character at the end, but
  # only if the next character is a letter

  .chars.map{|c|
  # Split string into separate charcters. As we injected all required special characters in the previous step we
  # now only need to translate each character into its Braille counterpart.


    (0..5).map{|i|
    # For simplicity, we always move head using the same pattern down, down, right, up, up, right [vv>^^>],
    # and before each move we decide should we emboss a dot [*].

      print("qS!QbcrIsESGibe@u!XU!g!|w!lWjfK!v!My!O!z!nm!}Bo]!ADC!!arqYAQCc!as"[((c.ord*1289)>>9)%65].ord>>i&1>0?"*":"",
      # We use a special lookup table to determine when we should emboss a dot.
      #
      # Dots for given Braille character are encoded as the 6 lowest prioity bits of the ascii code of a charcter from
      # the table.
      #
      # To convert an input character to a position in the lookup table we use so called "perfect hashing" concept
      # https://en.wikipedia.org/wiki/Perfect_hash_function
      # To find the order of charcters and values of constants for index calculation a separate script was used, which
      # search for them using brute force method.
      # Note that some space in the lookup table is not used, so it is quite possible to find even shorter table with
      # some other hashing function.

        "vv>^^>"[i])
        # Move head to the next position
    }
  }
  