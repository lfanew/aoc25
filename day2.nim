import std/strutils
import utils

const filename = "input.txt"

block part1:
  withFile(f, filename, FileMode.fmRead):
    var line: string
    var answer: BiggestInt = 0
    while f.readLine(line):
      for idRange in line.split(','):
        let idRangeParts = idRange.split('-')
        # TODO: Test performance with mod digit parsing instead of string allocations
        let idRangeStart = idRangeParts[0].parseBiggestInt
        let idRangeEnd = idRangeParts[1].parseBiggestInt
        for id in idRangeStart .. idRangeEnd:
          var idString = $id
          if idString.len mod 2 == 1: continue
          let midpoint = idString.len div 2
          # let left = idString[0 ..< midPoint]
          let left = idString.toStringView(0, midPoint - 1)
          let right = idString.toStringView(midPoint, idString.len - 1)
          if left == right: answer += id

    echo answer

block part2:
  proc isInvalid(id: BiggestInt): bool =
    var idString = $id
    let midpoint = idString.len div 2
    for point in countdown(midpoint, 1):
      if idString.len mod point != 0:
        continue
      var previous: StringView
      var valid = false
      for i in countup(0, idString.len - 1, point):
        if i == 0:
          previous = idString.toStringView(i, i + point - 1)
          continue
        let current = idString.toStringView(i, i + point - 1)
        if current != previous:
          valid = true
          break
      if not valid: return true

    return false

  withFile(f, filename, FileMode.fmRead):
    var line: string
    var answer: BiggestInt = 0
    while f.readLine(line):
      for idRange in line.split(','):
        let idRangeParts = idRange.split('-')
        # TODO: Test performance with mod digit parsing instead of string allocations
        let idRangeStart = idRangeParts[0].parseBiggestInt
        let idRangeEnd = idRangeParts[1].parseBiggestInt
        for id in idRangeStart .. idRangeEnd:
          if id.isInvalid: answer += id

    echo answer
