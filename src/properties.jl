################################################# FILE DESCRIPTION #########################################################

# ParallelGraphs allows the assignment of properties (key-value pairs) the the edges and vertices in a graph. Property
# modules are parameterized by a vertex template V and an edge template E. These templates must be types, where the fields
# and their types describe properties.

################################################# IMPORT/EXPORT ############################################################
export
# Types
PropertyModule,
# Properties Interface
listvprops, listeprops

abstract PropertyModule{V,E}


################################################# DEFAULT VALUES ###########################################################

# Char
Base.zero(::Type{Char}) = Char(0)

# String
Base.zero{T<:String}(::Type{T}) = ""

# Dict
Base.zero(::Type{Dict}) = Dict()
Base.zero{K,V}(::Type{Dict{K,V}}) = Dict{K,V}()

# Arrays
Base.zero{T,N}(::Type{Array{T,N}}) = Array{T,N}(zeros(Int, N)...)

# User defined types
Base.zero{T}(::Type{T}) = T([zero(fieldtype(T, field)) for field in fieldnames(T)]...)

# Everything else
Base.zero(::Type{Any}) = nothing

# Array of default values
function default_vector{T}(::Type{T}, nv::Int)
   if isa(zero(T), T)
      zeros(T, nv)
   else
      fill!(Array{Any}(nv), nv)
   end
end

# Matrix of default values
function default_matrix{T}(::Type{T}, nv::Int)
   if isa(zero(T), T)
      spzeros(T, nv, nv)
   else
      spzeros(Any, nv, nv)
   end
end


################################################# INTERFACE ################################################################

@interface deepcopy{V,E}(x::PropertyModule{V,E})

@interface addvertex!{V,E}(x::PropertyModule{V,E}, num::Int=1)

@interface rmvertex!{V,E}(x::PropertyModule{V,E}, v)

@interface addedge!{V,E}(x::PropertyModule{V,E}, u::VertexID, v::VertexID)
@interface addedge!{V,E}(x::PropertyModule{V,E}, e::EdgeID)
@interface addedge!{V,E}(x::PropertyModule{V,E}, elist::AbstractVector{EdgeID})

@interface rmedge!{V,E}(x::PropertyModule{V,E}, u::VertexID, v::VertexID)
@interface rmedge!{V,E}(x::PropertyModule{V,E}, e::EdgeID)
@interface rmedge!{V,E}(x::PropertyModule{V,E}, elist::AbstractVector{EdgeID})

@interface hasvprop{V,E}(x::PropertyModule{V,E}, prop)
@interface haseprop{V,E}(x::PropertyModule{V,E}, prop)
@interface listvprops{V,E}(x::PropertyModule{V,E})
@interface listeprops{V,E}(x::PropertyModule{V,E})

@interface getvprop{V,E}(x::PropertyModule{V,E}, v::VertexID)
@interface getvprop{V,E}(x::PropertyModule{V,E}, v::VertexID, propname)
@interface getvprop{V,E}(x::PropertyModule{V,E}, vlist::AbstractVector{VertexID}, propname)

@interface geteprop{V,E}(x::PropertyModule{V,E}, u::VertexID, v::VertexID)
@interface geteprop{V,E}(x::PropertyModule{V,E}, e::EdgeID)
@interface geteprop{V,E}(x::PropertyModule{V,E}, u::VertexID, v::VertexID, propname)
@interface geteprop{V,E}(x::PropertyModule{V,E}, e::EdgeID, propname)
@interface geteprop{V,E}(x::PropertyModule{V,E}, elist::AbstractVector{EdgeID}, propname)


@interface setvprop!{V,E}(x::PropertyModule{V,E}, v::VertexID, val, propname)
@interface setvprop!{V,E}(x::PropertyModule{V,E}, vlist::AbstractVector{VertexID}, vals::Vector, propname)
@interface setvprop!{V,E}(x::PropertyModule{V,E}, vlist::AbstractVector{VertexID}, f::Function, propname)
@interface setvprop!{V,E}(x::PropertyModule{V,E}, ::Colon, vals::Vector, propname)
@interface setvprop!{V,E}(x::PropertyModule{V,E}, ::Colon, f::Function, propname)


@interface seteprop!{V,E}(x::PropertyModule{V,E}, u::VertexID, v::VertexID, val, propname)
@interface seteprop!{V,E}(x::PropertyModule{V,E}, e::EdgeID, val, propname)
@interface seteprop!{V,E}(x::PropertyModule{V,E}, elist::AbstractVector{EdgeID}, vals::Vector, propname)
@interface seteprop!{V,E}(x::PropertyModule{V,E}, elist::AbstractVector{EdgeID}, f::Function, propname)

################################################# SUBGRAPHING ##############################################################

@interface subgraph{V,E}(x::PropertyModule{V,E}, vlist::AbstractVector{VertexID})
@interface subgraph{V,E}(x::PropertyModule{V,E}, vlist::AbstractVector{VertexID}, vproplist::AbstractVector)

@interface subgraph{V,E}(x::PropertyModule{V,E}, elist::AbstractVector{EdgeID})
@interface subgraph{V,E}(x::PropertyModule{V,E}, elist::AbstractVector{EdgeID}, eproplist::AbstractVector)

@interface subgraph{V,E}(x::PropertyModule{V,E}, vlist::AbstractVector{VertexID}, elist::AbstractVector{EdgeID})
@interface subgraph{V,E}(
   x::PropertyModule{V,E},
   vlist::AbstractVector{VertexID},
   elist::AbstractVector{EdgeID},
   vproplist::AbstractVector,
   eproplist::AbstractVector
)

################################################# VALIDATION ###############################################################

function validate_vertex_property(x::PropertyModule, prop)
   hasvprop(x, prop) || error("Vertex property $prop doesn't exist")
   nothing
end

function validate_vertex_property(x::PropertyModule, props::AbstractVector)
   for prop in props
      validate_vertex_property(x, prop)
   end
end

function validate_edge_property(x::PropertyModule, prop)
   haseprop(x, prop) || error("Edge property $prop doesn't exist")
   nothing
end

function validate_edge_property(x::PropertyModule, props::AbstractVector)
   for prop in props
      validate_edge_property(x, prop)
   end
end

# Provision for new/existing vertex property
@interface propmote_vertex_type!(x::PropertyModule, val, propname)

# Provision for new/existing edge property
@interface propmote_edge_type!(x::PropertyModule, val, propname)
################################################# IMPLEMENTATIONS ##########################################################

# Array of Structures Implementations
include("propmods/linear.jl")

# Structure of Arrays Implementations
include("propmods/vector.jl")
