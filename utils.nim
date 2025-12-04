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
  View*[T] = object
    data: ptr UncheckedArray[T]
    len*: int

proc toView*[T](s: openarray[T], first, last: int): View[T] =
  assert first >= 0 and last < s.len and first <= last
  result.len = last - first + 1
  result.data = cast[ptr UncheckedArray[T]](addr s[first])

proc `[]`*[T](self: View[T], i: int): T =
  assert i >= 0 and i < self.len
  return self.data[i]

proc `==`*[T](self, other: View[T]): bool =
  if self.len != other.len: return false
  for i in 0 ..< self.len:
    if self[i] != other[i]: return false

  return true

func parseInt*(c: char): int =
  assert c >= '0' and c <= '9'
  return ord(c) - ord('0')
