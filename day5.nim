import std/algorithm
import std/strutils
import utils

const filename = "input.txt"

type
  Interval = object
    low: int
    high: int
  ParsingMode = enum
    pmInterval
    pmId

func contains(interval: Interval, n: int): bool =
  return n >= interval.low and n <= interval.high

func combine(self, other: Interval): Interval =
  let low = min(self.low, other.low)
  let high = max(self.high, other.high)
  return Interval(low: low, high: high)

func len(self: Interval): int =
  return (self.high - self.low) + 1

func parseInterval(s: string): Interval =
  let parts = s.split('-')
  return Interval(low: parts[0].parseInt, high: parts[1].parseInt)

# used by sort
func `<`(self, other: Interval): bool =
  return self.low < other.low

func sum(intervals: openArray[Interval]): int =
  for interval in intervals: result += interval.len

proc mergeIntervals(intervals: var seq[Interval]) =
  var i = 1
  while i < intervals.len:
    let current = intervals[i]
    let prev = intervals[i-1]
    if current.low <= prev.high:
      intervals[i] = current.combine(prev)
      intervals.delete(i-1)
    else:
      inc(i)
  
withFile(f, filename, FileMode.fmRead):
  var part1 = 0
  var pm = ParsingMode.pmInterval
  var line: string
  var intervals: seq[Interval]
  while f.readLine(line):
    if line.isEmptyOrWhitespace:
      pm = ParsingMode.pmId
      continue
    case pm:
      of ParsingMode.pmInterval:
        intervals.add(line.parseInterval)
      of ParsingMode.pmId:
        let id = line.parseInt
        for interval in intervals:
          if interval.contains(id):
            inc(part1)
            break
  echo "Part1: ", part1
  sort(intervals)
  intervals.mergeIntervals
  let part2 = intervals.sum
  echo "Part2: ", part2
