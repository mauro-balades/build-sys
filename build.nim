import ./src/main, os, strformat

var b = Bake()

b.addTask("publish", @["build-release"], "print publish")
b.addTask("build-release", @["cd ../..", "ls", "publish-git"], "cd to root directory")
b.addTask("publish-git", @["git add .", fmt("git commit -m \"{paramStr(1)}\""), "git push"], "Push to git")
b.runTask("publish")