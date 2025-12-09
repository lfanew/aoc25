import std/strutils
import utils

const filename = "input.txt"

var points: seq[Point]

func parsePoint(s: string): Point =
  var i = 0
  for numString in s.split(','):
    var num = numString.parseInt
    case i:
      of 0: result[0] = num
      of 1: result[1] = num
      else: raise newException(IndexDefect, "Invalid Vector3 index")
    inc(i)

withFile(f, filename, FileMode.fmRead):
  var line: string
  while f.readLine(line):
    points.add(line.parsePoint)

# echo points

var answer = 0

for i, p in points:
  for j, q in points:
    if i == j: continue
    let (x1, y1) = p
    let (x2, y2) = q
    let width = abs(x1 - x2) + 1
    let height = abs(y1 - y2) + 1
    let area = width * height
    if area > answer: answer = area

echo answer
