import std/strutils
import utils

# Shared
const filename = "input.txt"

const
  DIAL_LOW = 0
  DIAL_HIGH = 99
  OVERFLOW = 100

block part1:
  proc left(dial: int, amount: int): int =
    let amount = amount mod OVERFLOW
    result = dial - amount
    if result < DIAL_LOW: result += OVERFLOW

  proc right(dial: int, amount: int): int =
    let amount = amount mod OVERFLOW
    result = dial + amount
    if result > DIAL_HIGH: result -= OVERFLOW

  var dial = 50
  var answer = 0

  withFile(txt, filename, FileMode.fmRead):
    var line: string
    while txt.readLine(line):
      let op = line[0]
      let amt: int = (line[1..^1]).parseInt
      case op:
        of 'L':
          dial = left(dial, amt)
        of 'R':
          dial = right(dial, amt)
        else:
          quit "Invalid operation: " & op
      if dial == 0: inc(answer)

  echo answer

# Part 2

block part2:
  proc left(dial: int, amount: int): (int, int) =
    var
      clicks = amount div OVERFLOW
      position = dial
    let amount = amount mod OVERFLOW

    for i in 1 .. amount:
      dec(position)
      if position < DIAL_LOW: position = DIAL_HIGH
      if position == DIAL_LOW: inc(clicks)

    return (position, clicks)

  proc right(dial: int, amount: int): (int, int) =
    var
      clicks = amount div OVERFLOW
      position = dial
    let amount = amount mod OVERFLOW

    for i in 1 .. amount:
      inc(position)
      if position > DIAL_HIGH: position = DIAL_LOW
      if position == DIAL_HIGH: inc(clicks)

    return (position, clicks)

  var dial = 50
  var answer = 0

  withFile(txt, filename, FileMode.fmRead):
    var line: string
    while txt.readLine(line):
      let op = line[0]
      let amt: int = (line[1..^1]).parseInt
      case op:
        of 'L':
          let (new, clicks) = left(dial, amt)
          dial = new
          answer += clicks
        of 'R':
          let (new, clicks) = right(dial, amt)
          dial = new
          answer += clicks
        else:
          quit "Invalid operation: " & op
  echo answer
