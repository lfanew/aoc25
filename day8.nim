import std/math
import std/sets
import std/strutils
import utils

const filename = "sample.txt"

type
  Vector3 = object
    x, y, z: int

func distance(self, other: Vector3): float =
  let dx = self.x - other.x
  let dy = self.y - other.y
  let dz = self.z - other.z
  return sqrt(float(dx^2 + dy^2 + dz^2))

func parseVector3(s: string): Vector3 =
  var i = 0
  for numString in s.split(','):
    var num = numString.parseInt
    case i:
      of 0: result.x = num
      of 1: result.y = num
      of 2: result.z = num
      else: raise newException(IndexDefect, "Invalid Vector3 index")
    inc(i)

block part1:
  var points: seq[Vector3]
  var groups: seq[HashSet[Vector3]]
  withFile(f, filename, FileMode.fmRead):
    var line: string
    while f.readLine(line):
      let v = line.parseVector3
      points.add(v)
      var set: HashSet[Vector3]
      set.incl(v)
      groups.add(set)

  for i, p in points:
    var min = Vector3(x: int.high, y: int.high, z: int.high)
    var minDistance = float.high
    for j, q in points:
      if i == j: continue
      let distance = distance(p, q)
      if distance < minDistance:
        min = q
        minDistance = distance
    var pGroup, minGroup: int = -1
    for group in 0 ..< groups.len:
      if groups[group].contains(p): pGroup = group
      if groups[group].contains(min): minGroup = group
    if pGroup == minGroup: continue
    groups[pGroup] = groups[pGroup].union(groups[minGroup])
    groups.del(minGroup)

  for group in groups:
    echo group

    # echo p, "<->", min
      
