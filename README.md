# file-type-pattern-matching-bash-script
Recursively counts number of files in dir arg passed from command line, matching subsequent command line passed arg patterns (i.e. $: .py 672 python files)

***Example:***

$:  ./count_matching.sh ../ py cpp java js text
$:
$:   py 51 files, 19594 lines, 138502 words, 4323947 chars
$:   cpp 91 files, 13122 lines, 40369 words, 351899 chars
$:   java 29 files, 3841 lines, 29779 words, 144317 chars
$:   js 2 files, 4 lines, 606 words, 16384 chars
$:   text 603 files, 379819 lines, 585516 words, 6469001 chars

***NOTE: the "text" pattern will consider every ascii file valid*** 

***So "py", "java", "cpp", etc. are each subsets of "text"***
