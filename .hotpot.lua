return {
build = {
  {verbose = true, atomic = true},
  {"fnl/**/*.fnl", true}, -- compile all other fnl files, automatically becomes lua/**/*.lua
}
}
