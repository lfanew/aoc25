import std/strutils
import utils

const filename = "input.txt"

type
  Range = object
    low: int
    high: int
  ParsingMode = enum
    pmRange
    pmId

func contains(range: Range, n: int): bool =
  return n >= range.low and n <= range.high

func parseRange(s: string): Range =
  let parts = s.split('-')
  return Range(low: parts[0].parseInt, high: parts[1].parseInt)

withFile(f, filename, FileMode.fmRead):
  var answer = 0
  var pm = ParsingMode.pmRange
  var line: string
  var ranges: seq[Range]
  while f.readLine(line):
    if line.isEmptyOrWhitespace:
      pm = ParsingMode.pmId
      continue
    case pm:
      of ParsingMode.pmRange:
        ranges.add(line.parseRange)
      of ParsingMode.pmId:
        let id = line.parseInt
        for range in ranges:
          if range.contains(id):
            inc(answer)
            break
  echo answer
