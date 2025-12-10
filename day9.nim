# Shoutout to EgoMoose's great 2d raycasting video
# https://www.youtube.com/watch?v=c065KoXooSw

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
  yield (polygon[0], polygon[^1])

func intersects(line1, line2: Edge): bool =
  ## not a lore accurate intersection function
  let (a, b) = line1
  let (c, d) = line2

  let r = (b - a)
  let s = (d - c)

  let denominator = r[0] * s[1] - r[1] * s[0]
  if denominator == 0: return false
  let u = ((c[0] - a[0]) * r[1] - (c[1] - a[1]) * r[0]) / denominator
  let t = ((c[0] - a[0]) * s[1] - (c[1] - a[1]) * s[0]) / denominator


  # only allow u to be 0 and 1 to avoid junction points
  # which we are not calling intersections for our purposes
  result = 0 <= u and u <= 1 and
           0 < t and t < 1
  
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
        let edge1: Edge = (p, q)
        let edge2: Edge = ((p[0], q[1]), (q[0], p[1]))
        for polygonEdge in polygon.edges:
          if edge1.intersects(polygonEdge) or edge2.intersects(polygonEdge):
            valid = false
            break
        if valid:
          answer = area

  echo answer
