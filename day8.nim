import std/heapqueue
import std/math
import std/sets
import std/strutils
import utils

const filename = "sample.txt"

when filename == "input.txt":
  const iters = 1000
when filename == "sample.txt":
  const iters = 10

type
  Vector3 = object
    x, y, z: int
  DistancePair = object
    a, b: Vector3
    distance: float

func `<`(self, other: DistancePair): bool =
  return self.distance < other.distance

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
var queue: HeapQueue[DistancePair]
var groups: seq[HashSet[Vector3]]
var processed: HashSet[(Vector3, Vector3)]

withFile(f, filename, FileMode.fmRead):
  var line: string
  while f.readLine(line):
    let v = line.parseVector3
    points.add(v)
    var set: HashSet[Vector3]
    set.incl(v)
    groups.add(set)

for i, p in points:
  for j, q in points:
    if i == j: continue
    let distance = distance(p, q)
    if not processed.contains((p, q)):
      let dp = DistancePair(a: p, b: q, distance: distance(p, q))
      queue.push(dp)
      processed.incl((q, p))

for i in 1 .. iters:
  let dp = queue.pop()
  var aGroup, bGroup: int = -1
  for group in 0 ..< groups.len:
    if groups[group].contains(dp.a): aGroup = group
    if groups[group].contains(dp.b): bGroup = group
  if aGroup == bGroup:
    continue
  groups[aGroup] = groups[aGroup].union(groups[bGroup])
  groups.del(bGroup)

var top1, top2, top3 = 0
for group in groups:
  if group.len > top1:
    swap(top1, top2)
    swap(top1, top3)
    top1 = group.len
  elif group.len > top2:
    swap(top2, top3)
    top2 = group.len
  elif group.len > top3: top3 = group.len

echo top1 * top2 * top3

var dp: DistancePair
while groups.len > 1:
  dp = queue.pop()
  var aGroup, bGroup: int = -1
  for group in 0 ..< groups.len:
    if groups[group].contains(dp.a): aGroup = group
    if groups[group].contains(dp.b): bGroup = group
  if aGroup == bGroup:
    continue
  groups[aGroup] = groups[aGroup].union(groups[bGroup])
  groups.del(bGroup)

echo (dp.a.x * dp.b.x)
