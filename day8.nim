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


var points: seq[Vector3]
withFile(f, filename, FileMode.fmRead):
  var line: string
  while f.readLine(line):
    points.add(line.parseVector3)
echo points
