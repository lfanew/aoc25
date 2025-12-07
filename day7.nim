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

  var work: seq[Point] = @[start]
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

  paths[start] = 1
  for point in grid.points:
    # skip first row
    if point[1] == 0: continue
    let value = grid[point]
    if value != '|': continue
    # echo point
    let n = point + (0, -1)
    var count = paths[n]
    let e = point + (1,  0)
    if grid.contains(e) and grid[e] == '^':
      # echo point
      count += paths[point + (1, -1)]
    let w = point + (-1, 0)
    if grid.contains(w) and grid[w] == '^':
      # echo point
      count += paths[point + (-1, -1)]
    paths[point] = count

  var answer = 0
  for path in paths[^1]:
    answer += path
  echo answer
  # grid.print()
  # paths.print()
