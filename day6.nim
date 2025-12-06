import std/sequtils
import std/strutils
import utils

const filename = "input.txt"

block part1:
  withFile(f, filename, FileMode.fmRead):
    var answer = 0
    var line: string
    var rows: seq[seq[string]]
    while f.readLine(line):
      var row: seq[string]
      for s in line.split:
        if s.isEmptyOrWhitespace: continue
        row.add(s)
      rows.add(row)

    for col in 0 ..< rows[0].len:
      var result = 0
      var nums: seq[int]
      for row in 0 ..< rows.len - 1:
        nums.add(rows[row][col].parseInt)
      case rows[^1][col]:
        of "*":
          inc(result)
          for num in nums:
            result *= num
        of "+":
          for num in nums:
            result += num
        else:
          quit "Oops"
      answer += result
    echo answer

block part2:
  withFile(f, filename, FileMode.fmRead):
    var answer = 0
    var line: string
    var rows: seq[seq[char]]
    while f.readLine(line):
      rows.add(line.toSeq)

    var op = ""
    var numberString = ""
    var numbers: seq[int]
    var blanks = 0
    for col in 0 ..< rows[0].len:
      for row in 0 ..< rows.len:
        let c = rows[row][col]
        if c >= '0' and c <= '9':
          numberString.add(c)
        elif c == ' ':
          inc(blanks)
        else:
          op.add(c)
      if numberString.len > 0:
        numbers.add(numberString.parseInt)
        numberString = ""
      if blanks == rows.len or col == rows[0].len - 1:
        # echo numbers
        var result = 0
        case op:
          of "*":
            inc(result)
            for number in numbers:
              result *= number
          of "+":
            for number in numbers:
              result += number
          else:
            quit "Oops"
        # echo result
        answer += result
        numbers = @[]
        op = ""
        # echo "------"
      blanks = 0
    # echo numbers
    echo answer
