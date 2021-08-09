import ../src/main

var b = Bake()

# TODO: make a actual test

b.addTask("publish", @["build-release"], "print publish")
b.addTask("build-release", @["nim-installed"], "print exec command to build release mode")
b.addTask("nim-installed", @["curl-installed"], "print curl LINK | bash")
b.addTask("curl-installed", @["apt-installed"], "apt-get install curl")
b.addTask("apt-installed", @["ls"], "code to install apt...")
b.runTask("publish")