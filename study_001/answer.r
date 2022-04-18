input <- file('stdin','r')
num <- readLines(input, n = 1)
row <- readLines(input, n = 1)
while (length(row) > 0) {
    s <- strsplit(row, split = " ")[[1]]
    write(paste("hello = ", s[1], " , world = ", s[2], sep = ""),"")
    row <- readLines(input, n = 1)
}
