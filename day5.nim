import std/algorithm
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

func combine(self, other: Range): Range =
  let low = min(self.low, other.low)
  let high = max(self.high, other.high)
  return Range(low: low, high: high)

func len(self: Range): int =
  return (self.high - self.low) + 1

func parseRange(s: string): Range =
  let parts = s.split('-')
  return Range(low: parts[0].parseInt, high: parts[1].parseInt)

# used by sort
func `<`(self, other: Range): bool =
  return self.low < other.low

func sum(ranges: openArray[Range]): int =
  for range in ranges: result += range.len

proc mergeRanges(ranges: var seq[Range]) =
  var i = 1
  while i < ranges.len:
    let current = ranges[i]
    let prev = ranges[i-1]
    if current.low <= prev.high:
      ranges[i] = current.combine(prev)
      ranges.delete(i-1)
    else:
      inc(i)
  
withFile(f, filename, FileMode.fmRead):
  var part1 = 0
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
            inc(part1)
            break
  echo "Part1: ", part1
  sort(ranges)
  ranges.mergeRanges
  let part2 = ranges.sum
  echo "Part2: ", part2
