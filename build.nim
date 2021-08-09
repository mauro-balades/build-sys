import ./src/main, os, strformat

var b = Bake()

# TODO: check for paramStr

b.addTask("publish", @["cd-dir"], "publish to git")
b.addTask("cd-dir", @["cd ../..", "ls", "publish-git"], "cd to root directory")
b.addTask("publish-git", @["git add .", fmt("git commit -m \"{paramStr(1)}\""), "git push"], "Push to git")
b.runTask("publish")