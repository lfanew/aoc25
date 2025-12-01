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
