if __name__ == '__main__':
    N = int(input())
    array = []
    for _ in range(0,N):
        i = input().split()
        if i[0] == "insert":
            array.insert(int(i[1]),int(i[2]))
        if i[0] == "print":
            print(array)
        if i[0] == "remove":
            array.remove(int(i[1]))
        if i[0] == "append":
            array.append(int(i[1]))
        if i[0] == "sort":
            array.sort()
        if i[0] == "pop":
            array.pop()
        if i[0] == "reverse":
            array.reverse()

        