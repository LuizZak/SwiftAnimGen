import MiniDigraph

class ReachabilityAnalyzer {
    typealias Graph = AbstractDirectedGraph<Node, Edge>

    var graph: Graph

    init() {
        graph = Graph()
    }

    func populate(_ file: AnimationsFile) {
        graph.clear()

        // Populate nodes first
        for state in file.states {
            graph.addNode(.state(state.name))
        }
        if let entryPoints = file.entryPoints {
            for entryPoint in entryPoints {
                graph.addNode(.entryPoint(entryPoint.name))
            }
        }

        // Populate transitions
        for state in file.states {
            if let transitions = state.transitions {
                for next in transitions {
                    graph.addEdge(from: .state(state.name), to: .state(next.state))
                }
            }

            if let onEnd = state.onEnd {
                for next in onEnd {
                    graph.addEdge(from: .state(state.name), to: .state(next.state))
                }
            }
        }

        // Populate entry points
        if let entryPoints = file.entryPoints {
            for entryPoint in entryPoints {
                graph.addEdge(from: .entryPoint(entryPoint.name), to: .state(entryPoint.name))
            }
        }
    }

    func diagnose() -> [Diagnostic] {
        var result: [Diagnostic] = []

        var remaining: Set<Node> = Set(graph.nodes)

        for case .entryPoint(let name) in graph.nodes {
            let node = Node.entryPoint(name)

            graph.breadthFirstVisit(start: node) { visit in
                remaining.remove(visit.node)

                return true
            }
        }

        for node in remaining {
            switch node {
            case .entryPoint:
                break

            case .state(let name):
                result.append(
                    .unreachableState(stateName: name)
                )
            }
        }

        return result
    }

    enum Node: Hashable {
        case state(String)
        case entryPoint(String)
    }

    struct Edge: SimpleDirectedGraphEdge {
        var start: Node
        var end: Node
    }

    enum Diagnostic: Hashable, CustomStringConvertible {
        case unreachableState(stateName: String)

        var description: String {
            switch self {
            case .unreachableState(let stateName):
                return "Found unreachable state '\(stateName)'"
            }
        }
    }
}
