//As we're starting in upper left corner of the initial character, there is only one route
//which visits every point of the character exactly once and is repeating:
//
//  *   * >
//  v   ^
//  *   *
//  v   ^
//  * > *
//
//We start by encoding each character as a 6-bit number. Together with the route we take,
//the initial encoding scheme is as follows:
//
//   0   5 >
//   v   ^
//   1   4
//   v   ^
//   2 > 3
//
// Then, we create a string with each character of the alphabet being present at the n-th index,
// according to its encoded number. The resulting string is:
//     ' a,b.k-l-ą-ł-u-v-e-h-o-rLę---z---cif-msp-ćś-óxźż-djg-ntq-ńw-Ny--'
// The capital N in the string denotes the "number follows" special character
// and "L" - "letter follows". Dashes are empty codepoints.
//     We also create a string with the order of steps required to take after each n-th bit of the
// character:
//     'vv>^^>'
//
// The original lookup string contains two empty codepoints at the end that can be trimmed off,
// resulting in a 62 character long string.
//     However, by reshuffling order of bits at which each Braille letter point is encoded, we can
// move more empty codepoints to the end of the string, with 12 orderings being 58 characters
// long. We can pick any of them, as there are no further optimizations I could find.

r='replace'; // Store the name of the "replace" function as it is used enough times to be worth it
console.log(
    process.argv[2][r](/\d[,-9]*/g,'N$&L') // we substitute each occurrence of a number-like string
                                           // (number followed by numbers, periods or commas) with
                                           // the same string enclosed with "number follows" and "letter follows"
                                           // special characters. We exploit RegExp ranges to save one character
                                           // by using [,-9] range (which includes - and / characters) instead of
                                           // more correct [\d,.], as we're guaranteed to not have these extra
                                           // characters in the input.
    [r](/L(?= |$)/g,'') // The previous operation added "letter follows" characters where they're
                        // not supposed to be, so we remove them if they're in front of a space
                        // or at the end of the string.
    [r](/./g,x=> // We replace each character of the input with its Braille command.
        '152340'[r](/./g,n=> // We replace each bit of the given letter with action
                             // (punch or no punch and next step).
            (' -ac.-km--ąć-óux--ed--onL-ęń-Nzy,ibf-slp-śł--źvż-jhg-trq-w'.search(
                'jabcdefghi'[x]||x // We deal with numbers by using a lookup string.
            )>>n&1?'*':'') // We look at the n-th bit of the index and use it to decide if we need
                           // to punch or not.
            +
            '>v>^^v'[n] // Read the next step for the n-th bit of the character. If there were any
                        // bit orderings with steps repeating in a groups of 3, e.g. '>v^>v^',
                        // this could be improved into '>v^'[n%3], but there are none.
        )
    )
)
