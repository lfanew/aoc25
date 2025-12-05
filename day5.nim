import std/strutils
import utils

const filename = "sample.txt"

type
  Range = object
    low: int
    high: int
  ParsingMode = enum
    pmRange
    pmId

func contains(range: Range, n: int): bool =
  return n >= range.low and n <= range.high

func overlaps(self, other: Range): bool =
  return self.contains(other.low) or self.contains(other.high)

func combine(self, other: Range): Range =
  let low = min(self.low, other.low)
  let high = max(self.high, other.high)
  return Range(low: low, high: high)

func parseRange(s: string): Range =
  let parts = s.split('-')
  return Range(low: parts[0].parseInt, high: parts[1].parseInt)

block part1:
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
    echo "Part1: ", answer

block part2:
  withFile(f, filename, FileMode.fmRead):
    var answer = 0
    var line: string
    var ranges: seq[Range]
    while f.readLine(line):
      if line.isEmptyOrWhitespace:
        break
      ranges.add(line.parseRange)
    for i in 0 ..< ranges.len:
      let range1 = ranges[i]
      for j in i+1 ..< ranges.len:
        let range2 = ranges[j]
        if range1.overlaps(range2):
          echo range1, "|", range2
          echo "Combining..."
          let newRange = range1.combine(range2)
          echo newRange
        
    echo "Part1: ", answer
