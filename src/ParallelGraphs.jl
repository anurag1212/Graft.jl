module ParallelGraphs

using NDSparseData
import LightGraphs
using Faker

# Core definitions
include("core.jl")

# Package Wide Utilities
include("util.jl")

# Property Modules
include("properties.jl")

# Adjacency Modules
include("adjacency.jl")

# Basic Graph Definition
include("graph.jl")

# Querying
include("query.jl")

# Parse Graphs from files etc.
include("parse.jl")

# Graph Algortithms
include("algorithms.jl")

end # module
