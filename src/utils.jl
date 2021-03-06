defs(mod::LLVM.Module)  = filter(f -> !isdeclaration(f), collect(functions(mod)))
decls(mod::LLVM.Module) = filter(f ->  isdeclaration(f) && !LLVM.isintrinsic(f),
                                 collect(functions(mod)))


## lazy module loading

using UUIDs

struct LazyModule
    pkg::Base.PkgId
    LazyModule(name, uuid) = new(Base.PkgId(uuid, name))
end

function Base.getproperty(lazy_mod::LazyModule, sym::Symbol)
    pkg = getfield(lazy_mod, :pkg)
    mod = get(Base.loaded_modules, pkg, nothing)
    if mod === nothing
        error("This functionality requires the $(pkg.name) package, which should be installed and loaded first.")
    end
    getfield(mod, sym)
end
