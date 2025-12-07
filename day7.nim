import std/sets
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
  echo answer
