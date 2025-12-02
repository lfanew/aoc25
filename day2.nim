import std/strutils
import utils

const filename = "input.txt"

withFile(f, filename, FileMode.fmRead):
  var line: string
  var answer: BiggestInt = 0
  while f.readLine(line):
    for idRange in line.split(','):
      let idRangeParts = idRange.split('-')
      let idRangeStart = idRangeParts[0].parseBiggestInt
      let idRangeEnd = idRangeParts[1].parseBiggestInt
      for id in idRangeStart .. idRangeEnd:
        var idString = $id
        if idString.len mod 2 == 1: continue
        let midpoint = idString.len div 2
        let left = idString[0 ..< midPoint]       
        let right = idString[midPoint ..< idString.len]       
        if left == right: answer += id

  echo answer
