import strformat, strutils, tables, sequtils, algorithm, ./shell

type Task = object
    requires*: seq[string]
    actions*: string
    name: string
    # cmd: string

type NodeColor = enum
  ncWhite, ncGray, ncBlack

proc `$`(this: Task): string = 
    return fmt("Task {this.name} \nRequirements: {this.requires} \nactions: {this.actions}")

type Bake = ref object
    tasksgraph* : Table[string, seq[string]]
    tasks*      : Table[string, Task]
export Bake

proc addTask*(this: Bake, taskname: string, deps: seq[string], actions:string) : void = 
    var t =  Task(name:taskname, requires:deps, actions:actions)
    this.tasksgraph[taskname] = deps
    this.tasks[taskname] = t

proc hasCycleDFS(graph:Table[string, seq[string]] , node: string, colors: var Table[string, NodeColor], has_cycle: var bool, parentMap: var Table[string, string]) =
  if hasCycle:
      return
  colors[node] = ncGray 

  for dep in graph[node]:
    parentMap[dep] = node
    if colors[dep] == ncGray:
      hasCycle = true   
      parentMap["__CYCLESTART__"] = dep
      return
    if colors[dep] == ncWhite:  
      hasCycleDFS(graph, dep, colors, hasCycle, parentMap)
  colors[node] = ncBlack  

proc graphHasCycle(graph: Table[string, seq[string]]): (bool, Table[string, string]) =
  var colors = initTable[string, NodeColor]()
  for node, deps in graph:
    colors[node] = ncWhite
  
  var parentMap = initTable[string, string]()
  var hasCycle = false 
  for node, deps in graph:
    parentMap[node] = "null"
    if colors[node] == ncWhite:
      hasCycleDFS(graph, node, colors, hasCycle, parentMap)
    if hasCycle:
      return (true, parentMap)
  return (false, parentMap)

proc runTaskHelper(this: Bake, taskname: string, deps: var seq[string], seen: var seq[string]) : void = 
    if taskname in seen:
        echo fmt("[+] Solved {taskname} before no need to repeat action")
    var tsk = this.tasks.getOrDefault(taskname)

    seen.add(taskname)
    if len(tsk.requires) > 0:
        for c in this.tasksgraph[tsk.name]:
            this.runTaskHelper(c, deps, seen)
    deps.add(taskname)

proc runTask*(this: Bake, taskname: string): void =
    var deps = newSeq[string]()
    var seen = newSeq[string]()

    this.runTaskHelper(taskname, deps, seen)      

    for tsk in deps:
        let t = this.tasks.getOrDefault(tsk)

        if t.actions != "":
            echo(fmt("[task]: {t.actions}"))
        else:
            shell:
                ($tsk)
            # execShell("ls")