import utils

const filename = "input.txt"

proc parseInt(c: char): int =
  assert c >= '0' and c <= '9'
  return ord(c) - ord('0')

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
    # for i, p in positions:
    #   echo i, ": ", p
