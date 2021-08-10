# Package

version     = "1.0.0"
author      = "bs"
description = "A good alternative to Makefile."
license     = "GNU"

bin = @["main"]
srcDir = "src"
installExt = @["nim"]

# Deps

requires "nim >= 0.10.0"
