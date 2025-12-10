import std/strutils
import utils

const filename = "sample.txt"

type
  Machine = seq[bool]
  Button = seq[int]

func parseMachine(s: string): Machine =
  let lightView = s.toView(1, s.len - 2) # discard []
  result = newSeq[bool](lightView.len)
  for i in 0 ..< lightView.len:
    let c = lightView[i]
    case c:
      of '.': result[i] = false
      of '#': result[i] = true
      else: raise newException(Defect, "Invalid light configuration: " & c)

# func parseButton(s: string): Button =
proc parseButton(s: string): Button =
  let wiringString = s[1..^2] # discard ()
  for numString in wiringString.split(','):
    result.add(numString.parseInt)

withFile(f, filename, FileMode.fmRead):
  var line: string
  # echo parseMachine("[.###.#]")
  # echo parseButton("(0,1,2,3,4)")
  while f.readLine(line):
    echo line
