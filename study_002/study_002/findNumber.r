#
# Complete the 'findNumber' function below.
#
# The function is expected to return a STRING.
# The function accepts following parameters:
#  1. INTEGER_ARRAY arr
#  2. INTEGER k
#

findNumber <- function(arr, k) {
    # Write your code here

}

stdin <- file('stdin')
open(stdin)

fptr <- file(Sys.getenv("OUTPUT_PATH"))
open(fptr, open = "w")

arrCount <- as.integer(trimws(readLines(stdin, n = 1, warn = FALSE), which = "both"))
arr <- readLines(stdin, n = arrCount, warn = FALSE)
arr <- trimws(arr, which = "both")
arr <- as.integer(arr)

k <- as.integer(trimws(readLines(stdin, n = 1, warn = FALSE), which = "both"))

result <- findNumber(arr, k)

writeLines(result, con = fptr)

close(stdin)
close(fptr)
