import std/strutils
import utils

# Shared
const filename = "input.txt"

type
  Dial = range[0..99]

proc left(dial: var Dial, amount: int): int =
  result += amount div (Dial.high + 1)
  let amount = amount mod (Dial.high + 1)
  for _ in 0 ..< amount:
    if dial == Dial.low: dial = Dial.high
    else: dec(dial)
    if dial == Dial.low: inc(result)

proc right(dial: var Dial, amount: int): int =
  result += amount div (Dial.high + 1)
  let amount = amount mod (Dial.high + 1)
  for _ in 0 ..< amount:
    if dial == Dial.high: dial = Dial.low
    else: inc(dial)
    if dial == Dial.low: inc(result)

var dial: Dial = 50
var
  part1 = 0
  part2 = 0

withFile(txt, filename, FileMode.fmRead):
  var line: string
  while txt.readLine(line):
    let op = line[0]
    let amt: int = (line[1..^1]).parseInt
    case op:
      of 'L':
        part2 += dial.left(amt)
      of 'R':
        part2 += dial.right(amt)
      else:
        quit "Invalid operation: " & op
    if dial == 0: inc(part1)

echo "Part 1: ", part1
echo "Part 2: ", part2
