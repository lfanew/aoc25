import std/strutils
import utils

const filename = "input.txt"

# TODO: Better names, address magic constants,
  # break part 2 into procs, comments to remind myself wth I did

block part1:
  type
    DigitPositions = array[10, seq[int]]

  proc highestNumber(positions: DigitPositions): int =
    for digit1 in countdown(positions.len - 1, 0):
      if positions[digit1].len == 0: continue
      let pos1 = positions[digit1][0]
      for digit2 in countdown(positions.len - 1, 0):
        if positions[digit2].len == 0: continue
        let pos2 = positions[digit2][^1]
        if digit1 == digit2 and pos1 == pos2: continue
        elif pos2 > pos1: return (digit1 * 10 + digit2)

  withFile(f, filename, FileMode.fmRead):
    var line: string
    var answer = 0
    while f.readLine(line):
      var positions: DigitPositions
      for idx, ch in line:
        let digit = ch.parseInt
        positions[digit].add(idx)
      answer += highestNumber(positions)
    echo "Part 1: ", answer

block part2:
  withFile(f, filename, FileMode.fmRead):
    var line: string
    var answer = 0
    while f.readLine(line):
      var number = ""
      var remaining = 12
      var idx = 0
      while number.len < 12:
        if remaining >= line.len - idx:
          number.add(line[idx..^1])
          break
        let view = line.toView(idx, line.len - remaining)
        let maxIdx = view.maxIndex
        number.add view[maxIdx]
        idx += maxIdx + 1
        dec remaining
      answer += number.parseInt
    echo "Part 2: ", answer
