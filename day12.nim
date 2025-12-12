import std/pegs
import std/sequtils
import std/strutils
import utils

const filename = "sample.txt"

type
  Shape = Grid[int]
  Region = Grid[int]
  ParsingMode = enum
    pmShape
    pmRegion

block part1:
  var shapes: seq[Shape]
  var regions: seq[Region]
  var regionShapeIndices: seq[seq[int]]
  withFile(f, filename, FileMode.fmRead):
    var line: string
    var pm = pmShape
    while f.readLine(line):
      echo line
      if line.contains('x'): pm = pmRegion
      case pm:
        of pmShape:
          var shape: Shape
          while f.readLine(line) and line != "":
            var row: seq[int]
            for c in line:
              if c == '#': row.add(1)
              else: row.add(0)
            shape.add(row)
          shapes.add(shape)
        of pmRegion:
          # echo "region"
          # echo line
          let parts = line.findAll(peg"\d+")
          let regionParams = map(parts[0..1], parseInt)
          # echo regionParams
          var region: Region
          for r in 0 ..< regionParams[1]:
            region.add(newSeq[int](regionParams[0]))
          regions.add(region)
          # region.print()
          let indices = map(parts[2..^1], parseInt)
          # echo indices
          regionShapeIndices.add(indices)

  assert regions.len == regionShapeIndices.len
  # for i in 0 ..< regions.len:
  #   regions[i].print()
  #   echo regionShapeIndices[i]

  # for shape in shapes:
  #   shape.print()
  #   echo "-------"
