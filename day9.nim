import std/math
import std/strutils
import utils

const filename = "input.txt"

func parsePoint(s: string): Point =
  var i = 0
  for numString in s.split(','):
    var num = numString.parseInt
    case i:
      of 0: result[0] = num
      of 1: result[1] = num
      else: raise newException(IndexDefect, "Invalid Point index")
    inc(i)

block part1:
  var points: seq[Point]
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

type
  # type alias for problem readability
  Polygon = seq[Point]
  Edge = (Point, Point)

iterator edges(polygon: Polygon): Edge =
  for i in 1 ..< polygon.len:
    let p1 = polygon[i-1]
    let p2 = polygon[i]

    yield (p1, p2)

iterator points(edge: Edge): Point =
  var current = edge[0]
  let stop = edge[1]
  let dx = stop[0] - current[0]
  let dy = stop[1] - current[1] 
  let divisor = gcd(dx, dy)
  let step: Point = (dx div divisor, dy div divisor)
  while current != stop:
    yield current
    current = current + step
  yield current

func containsPoint(polygon: Polygon, point: Point): bool =
  var count = 0
  let (xp, yp) = point
  for edge in polygon.edges:
    let ((x1, y1), (x2, y2)) = edge
    if (yp < y1) != (yp < y2) and
      float(xp) < (float(x1) + ((yp-y1)/(y2-y1)) * float(x2-x1)):
        inc(count)
  return count mod 2 == 1

block part2:
  var polygon: Polygon
  withFile(f, filename, FileMode.fmRead):
    var line: string
    while f.readLine(line):
      polygon.add(line.parsePoint)

  var answer = 0

  for i, p in polygon:
    for j, q in polygon:
      if i == j: continue
      let (x1, y1) = p
      let (x2, y2) = q
      let width = abs(x1 - x2) + 1
      let height = abs(y1 - y2) + 1
      let area = width * height
      if area > answer:
        var valid = true
        let edge: Edge = (p, q)
        for point in edge.points:
          if not polygon.containsPoint(point):
            valid = false
            break
        if valid: answer = area

  echo answer
