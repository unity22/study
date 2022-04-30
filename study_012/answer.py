def print_formatted(number):
    length = len(bin(number)[2:])
    for i in range(1, number+1):
        formatting = ""
        for character in "doXb":
            if formatting:
                formatting += " "
            formatting += "{:>" + str(length) + character + "}"
        print(formatting.format(i, i, i, i))
    
        
        
    
    

if __name__ == '__main__':
    n = int(input())
    print_formatted(n)
