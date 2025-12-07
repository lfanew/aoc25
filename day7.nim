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

type
  Place = object
    terrain: char
    value: int

block part2:
  var grid: Grid[Place]
  withFile(f, filename, FileMode.fmRead):
    var line: string
    while f.readLine(line):
      var row = newSeq[Place](line.len)
      for i, c in line:
        if c == 'S': 
          row[i] = Place(terrain: c, value: 1)
        else:
          row[i] = Place(terrain: c, value: 0)
      grid.add(row)

  for point, place in grid:
    # skip last row
    if point[1] == grid.len - 1: break
    # no work to do
    if place.value == 0: continue
    let s = point + SOUTH
    # split?
    if grid[s].terrain == '^':
      let se = point + SOUTH_EAST
      if grid.contains(se):
        let newPlace = Place(terrain: grid[se].terrain, value: grid[se].value + place.value)
        grid[se] = newPlace
      let sw = point + SOUTH_WEST
      if grid.contains(sw):
        let newPlace = Place(terrain: grid[sw].terrain, value: grid[sw].value + place.value)
        grid[sw] = newPlace
    # flow downwards
    else:
      let newPlace = Place(terrain: grid[s].terrain, value: grid[s].value + place.value)
      grid[s] = newPlace
    
  var answer = 0
  for place in grid[^1]:
    answer += place.value
  echo answer
