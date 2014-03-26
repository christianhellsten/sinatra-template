#
# Add Firebug/Chrome methods to prevent errors.
#
try
  window.console = window.console or {}
  names = [
    "log", "debug", "info", "warn", "error", "assert", "dir",
    "dirxml", "group", "groupEnd", "time", "timeEnd", "count",
    "trace", "profile", "profileEnd"
  ]
  nada = ->
  for name in names
    window.console[name] = window.console[name] or nada
