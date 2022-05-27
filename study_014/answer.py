def minion_game(string):
    vowels = ['A','E','I','O','U']
    lenstring = len(string)
    kevin = sum(lenstring-i for i in range(lenstring) if string[i] in vowels)
    stuart = lenstring*(lenstring + 1)/2 - kevin
    if kevin == stuart:
        print ('Draw')
    elif kevin > stuart:
        print ('Kevin %d' % kevin)
    else:
        print ('Stuart %d' % stuart)


if __name__ == '__main__':
    s = input()
    minion_game(s)
