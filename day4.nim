import utils

const filename = "input.txt"

type
  Grid = seq[Row]
  Row = seq[char]
  Point = (int, int)

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

func `[]`(grid: Grid, point: Point): char =
  let (x, y) = point
  return grid[y][x]

proc `[]=`(grid: var Grid, point: Point, value: char) =
  let (x, y) = point
  grid[y][x] = value

func add(point: Point, delta: Point): Point =
  (point[0] + delta[0], point[1] + delta[1])

func contains(grid: Grid, point: Point): bool =
  let (x, y) = point
  return y >= 0 and y < grid.len and x >= 0 and x < grid[0].len

iterator points(grid: Grid): Point =
  for y in 0 ..< grid.len:
    for x in 0 ..< grid[y].len:
      yield (x, y)

iterator adjacent(grid: Grid, point: Point): char =
  for delta in NEIGHBOR_DELTAS:
    let point = point.add(delta)
    if grid.contains(point): yield grid[point]


block part1:
  withFile(f, filename, FileMode.fmRead):
    var line: string
    var answer = 0
    var grid: Grid
    while f.readLine(line):
      var row: Row
      for ch in line:
        row.add(ch)
      grid.add(row)

    for point in grid.points:
      var rolls = 0
      if grid[point] == '.': continue
      for adjacent in grid.adjacent(point):
        if adjacent == '@': inc(rolls)
      if rolls < 4:
        inc answer

    echo "Part 1: ", answer

block part2:
  withFile(f, filename, FileMode.fmRead):
    var line: string
    var answer = 0
    var grid: Grid
    while f.readLine(line):
      var row: Row
      for ch in line:
        row.add(ch)
      grid.add(row)

    var removed = true
    while removed:
      removed = false
      for point in grid.points:
        var rolls = 0
        if grid[point] == '.': continue
        for adjacent in grid.adjacent(point):
          if adjacent == '@':
            inc(rolls)
        if rolls < 4:
          grid[point] = '.'
          inc(answer)
          removed = true

    echo "Part 1: ", answer
