import std/strutils
import utils

const filename = "input.txt"

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
