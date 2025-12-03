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

# No-copy StringView
# TODO: Make this a generic view

type
  StringView* = object
    data: ptr UncheckedArray[char]
    len*: int

proc toStringView*(s: string, first, last: int): StringView =
  assert first >= 0 and last < s.len and first <= last
  result.len = last - first + 1
  result.data = cast[ptr UncheckedArray[char]](addr s[first])

proc `[]`*(self: StringView, i: int): char =
  assert i >= 0 and i < self.len
  return self.data[i]

proc `==`*(self, other: StringView): bool =
  if self.len != other.len: return false
  for i in 0 ..< self.len:
    if self[i] != other[i]: return false

  return true
