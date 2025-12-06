import utils

const filename = "input.txt"

block part1:
  withFile(f, filename, FileMode.fmRead):
    var line: string
    var answer = 0
    var grid: Grid[char]
    while f.readLine(line):
      var row: Row[char]
      for ch in line:
        row.add(ch)
      grid.add(row)

    for point, value in grid:
      var rolls = 0
      echo value
      if value == '.': continue
      for adjacent in grid.adjacentValues(point):
        if adjacent == '@': inc(rolls)
      if rolls < 4:
        inc answer

    echo "Part 1: ", answer

block part2:
  withFile(f, filename, FileMode.fmRead):
    var line: string
    var answer = 0
    var grid: Grid[char]
    while f.readLine(line):
      var row: Row[char]
      for ch in line:
        row.add(ch)
      grid.add(row)

    var work: seq[Point]
    for point in grid.points:
      work.add(point)
    while work.len > 0:
      var newWork: seq[Point]
      for point in work:
        var rolls = 0
        if grid[point] == '.': continue
        for adjacent in grid.adjacentValues(point):
          if adjacent == '@':
            inc(rolls)
        if rolls < 4:
          grid[point] = '.'
          for adjacent in grid.adjacentPoints(point):
            if grid[adjacent] == '@':
              newWork.add(adjacent)
          inc(answer)
      work = newWork

    echo "Part 2: ", answer
