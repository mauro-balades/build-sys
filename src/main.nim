import strformat, tables, ./shell

type Task = object
    requires*: seq[string]
    actions*: string
    name: string

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
    
proc runTaskHelper(this: Bake, taskname: string, deps: var seq[string], seen: var seq[string]) : void = 
    if taskname in seen:
        echo fmt("\e[92m[+] Solved {taskname} before no need to repeat action\e[0m")
    var tsk = this.tasks.getOrDefault(taskname)

    seen.add(taskname)
    deps.add(taskname)
    if len(tsk.requires) > 0:
        for c in this.tasksgraph[tsk.name]:
            this.runTaskHelper(c, deps, seen)

proc runTask*(this: Bake, taskname: string): void =
    var deps = newSeq[string]()
    var seen = newSeq[string]()

    this.runTaskHelper(taskname, deps, seen)      

    # TODO: check for a cycle

    for tsk in deps:
        let t = this.tasks.getOrDefault(tsk)

        if t.actions != "":
            echo(fmt("\e[94m[task]\e[0m : {t.actions}"))
        else:
            shell:
              ($tsk)