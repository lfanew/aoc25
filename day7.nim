import utils

const filename = "input.txt"

block part1:
  var grid: Grid[char]
  withFile(f, filename, FileMode.fmRead):
    var line: string
    while f.readLine(line):
      let row = cast[seq[char]](line)
      grid.add(row)

  var start: Point
  for i, c in grid[0]:
    if c == 'S':
      start = (i, 0)
      break

  var work: seq[Point] = @[start]
  var answer = 0
  while work.len > 0:
    var p = work.pop
    if not grid.contains(p): continue
    # split beam
    if grid[p] == '^':
      let (x, y) = p
      let l = (x - 1, y)
      if grid[l] != '|' and grid[l] != '^': work.add(l)
      let r = (x + 1, y)
      if grid[r] != '|' and grid[r] != '^': work.add(r)
    else:
      grid[p] = '|'
      inc(p[1])
      work.add(p)

  for point in grid.points:
    if grid[point] == '^':
      let north = (point[0], point[1] - 1)
      if grid[north] == '|': inc answer

  # grid.print()
  echo answer

block part2:
  var grid: Grid[char]
  var paths: Grid[int]
  withFile(f, filename, FileMode.fmRead):
    var line: string
    while f.readLine(line):
      let row = cast[seq[char]](line)
      grid.add(row)
      let r: Row[int] = newSeq[int](row.len)
      paths.add(r)

  var start: Point
  for i, c in grid[0]:
    if c == 'S':
      start = (i, 0)
      break

  paths[start] = 1
  for point, count in paths:
    if point[1] == paths.len - 1: break
    if count == 0: continue
    let s = grid[point + SOUTH]
    if s == '^':
      let se = point + SOUTH_EAST
      if paths.contains(se):
        paths[se] = paths[se] + count
      let sw = point + SOUTH_WEST
      if paths.contains(sw):
        paths[sw] = paths[sw] + count
    else:
      paths[point + SOUTH] = paths[point + SOUTH] + count
    
  var answer = 0
  for path in paths[^1]:
    answer += path
  echo answer
  # grid.print()
  # paths.print()
