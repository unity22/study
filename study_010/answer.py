if __name__ == '__main__':
    n = int(input())
    arr = map(int, input().split())
    sorted_arr = sorted(arr, reverse = True)
    for i in range(len(sorted_arr)):
        if sorted_arr[i] == sorted_arr[0]:
            continue
        else:
            print(sorted_arr[i])
            break
        