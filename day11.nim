import std/pegs
import std/tables
import utils

const filename = "input.txt"

type
  Device = ref object
    id: string
    outputs: seq[Device]

func `$`(device: Device): string =
  return device.id

block part1:
  var nodes: Table[string, Device]
  withFile(f, filename, FileMode.fmRead):
    var line: string
    while f.readLine(line):
      let parts = line.findAll(peg"\w+")
      let deviceString = parts[0]
      if not nodes.contains(deviceString):
        nodes[deviceString] = Device(id: deviceString, outputs: @[])
      let device = nodes[deviceString]
      for outputString in parts[1..^1]:
        if not nodes.contains(outputString):
          nodes[outputString] = Device(id: outputString, outputs: @[])
        let output = nodes[outputString]
        device.outputs.add(output) 

  let start = nodes["you"]
  var stack = @[start]
  var answer = 0

  while stack.len > 0:
    let current = stack.pop
    if current.id == "out":
      inc(answer)
      continue
    for output in current.outputs:
      stack.add(output)
  echo answer

var cache: Table[(string, bool, bool), int]
proc numOfPaths(device: Device, dac = false, fft = false): int =
  # echo cache
  if device.id == "out":
    if dac and fft: return 1 else: return 0
  # if dac and fft: return 1
  # elif device.id == "out": return 0

  for output in device.outputs:
    let dac = dac or device.id == "dac"
    let fft = fft or device.id == "fft"
    let key = (output.id, dac, fft)
    if cache.hasKey(key):
      result += cache[key]
    else:
      let paths = numOfPaths(output, dac, fft)
      cache[key] = paths
      result += paths

  cache[(device.id, dac, fft)] = result
  
  return result

block part2:
  var nodes: Table[string, Device]
  withFile(f, filename, FileMode.fmRead):
    var line: string
    while f.readLine(line):
      let parts = line.findAll(peg"\w+")
      let deviceString = parts[0]
      if not nodes.contains(deviceString):
        nodes[deviceString] = Device(id: deviceString, outputs: @[])
      let device = nodes[deviceString]
      for outputString in parts[1..^1]:
        if not nodes.contains(outputString):
          nodes[outputString] = Device(id: outputString, outputs: @[])
        let output = nodes[outputString]
        device.outputs.add(output) 

  # let start = nodes["svr"]
  # var stack = @[(start, false, false)]
  var answer = numOfPaths(nodes["svr"])

  # while stack.len > 0:
  #   let current = stack.pop
  #   if current[0].id == "out":
  #     if current[1] and current[2]:
  #       inc(answer)
  #     continue
  #   for output in current[0].outputs:
  #     let dac = current[1] or output.id == "dac"
  #     let fft = current[2] or output.id == "fft"
  #     stack.add((output, dac, fft))
  echo answer
