# Helper templates

template withFile*(f: untyped, filename: string, mode: FileMode, body: untyped) =
  let fn = filename
  var f: File
  if open(f, fn, mode):
    try:
      body
    finally:
      close(f)
  else:
    quit("Cannot open file: " & fn)

# No-copy data view

type
  View*[T] = object
    data: ptr UncheckedArray[T]
    len*: int

func toView*[T](s: openarray[T], first, last: int): View[T] =
  assert first >= 0 and last < s.len and first <= last
  result.len = last - first + 1
  result.data = cast[ptr UncheckedArray[T]](addr s[first])

func `[]`*[T](self: View[T], i: int): T =
  assert i >= 0 and i < self.len
  return self.data[i]

func `==`*[T](self, other: View[T]): bool =
  if self.len != other.len: return false
  for i in 0 ..< self.len:
    if self[i] != other[i]: return false

  return true

func maxIndex*[T](self: View[T]): int =
  var maxValue = self[0]
  for i in 1 ..< self.len:
    let current = self[i]
    if current > maxValue:
      maxValue = self[i]
      result = i

  return result

proc print*[T](self: View[T]) =
  for i in 0 ..< self.len:
    stdout.write(self[i])
    stdout.write(' ')
  echo ""

# Grid
type
  Grid*[T] = seq[Row[T]]
  Row*[T] = seq[T]
  Point* = (int, int)

const NEIGHBOR_DELTAS: array[8, Point] = [
  (1,   0),
  (0,   1),
  (-1,  0),
  (0,  -1),
  (1,   1),
  (1,  -1),
  (-1,  1),
  (-1, -1)
]

func `[]`*[T](grid: Grid[T], point: Point): T =
  let (x, y) = point
  return grid[y][x]

proc `[]=`*[T](grid: var Grid[T], point: Point, value: T) =
  let (x, y) = point
  grid[y][x] = value

func `+`*(point: Point, delta: Point): Point =
  (point[0] + delta[0], point[1] + delta[1])

func contains*(grid: Grid, point: Point): bool =
  let (x, y) = point
  return y >= 0 and y < grid.len and x >= 0 and x < grid[0].len

iterator points*(grid: Grid): Point =
  for y in 0 ..< grid.len:
    for x in 0 ..< grid[y].len:
      yield (x, y)

iterator pairs*[T](grid: Grid[T]): (Point, T) =
  for point in grid.points:
    yield (point, grid[point])

iterator adjacentValues*[T](grid: Grid[T], point: Point): T =
  for delta in NEIGHBOR_DELTAS:
    let point = point + delta
    if grid.contains(point): yield grid[point]

iterator adjacentPoints*(grid: Grid, point: Point): Point =
  for delta in NEIGHBOR_DELTAS:
    let point = point + delta
    if grid.contains(point): yield point

# Helper procs

func parseInt*(c: char): int =
  assert c >= '0' and c <= '9'
  return ord(c) - ord('0')

