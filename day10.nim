import std/sets
import std/pegs
import std/strutils
import utils

const filename = "input.txt"

type
  Machine = seq[bool]
  Button = HashSet[int]

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
    result.incl(numString.parseInt)

proc apply(machine: Machine, button: Button): Machine =
  result = machine
  for wire in button:
    result[wire] = not result[wire]

type
  Node = ref object
    data: Machine
    children: seq[Node]

var answer = 0

withFile(f, filename, FileMode.fmRead):
  var line: string
  while f.readLine(line):
    let desiredString = line.findAll(peg"\[[\.\#]+\]")[0]
    let buttonStrings = line.findAll(peg"\(\d+(\,\d)*\)")
    let desired = desiredString.parseMachine
    var current: Machine = newSeq[bool](desired.len)
    var buttons: seq[Button]
    for s in buttonStrings:
      buttons.add(s.parseButton)
    # echo current, " | Pressing ", buttons[0]
    # echo current
    var variants: HashSet[Machine]
    variants.incl(current)
    var presses = 0
    while not variants.contains(desired):
      var newVariants: HashSet[Machine]
      for variant in variants:
        for button in buttons:
          newVariants.incl(variant.apply(button))
      variants = newVariants
      inc(presses)
    answer += presses

echo answer
