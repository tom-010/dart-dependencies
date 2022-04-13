T locate<T>(String preset) {
  return Preset.use(preset).use<T>();
}

class Deps {
  final Map<Type, dynamic Function(Deps)> mappings;
  final Map<String, dynamic> config;

  Deps({final Map<Type, dynamic Function(Deps)>? mappings, Map<String, dynamic>? config})
    : mappings = mappings ?? {}, config = config ?? {};

  static Deps merge(Iterable<Deps> depsChain) {
    final res = Deps();
    for(Deps deps in depsChain) {
      for(Type t in deps.mappings.keys) {
        if(!res.mappings.containsKey(t)) {
          res.mappings[t] = deps.mappings[t]!;
        }
      }
    }
    return res;
  }

  dynamic operator[](Type T) {
    assert(mappings.containsKey(T), "type $T not found in $mappings");
    return mappings[T]!(this);
  }

  T use<T>() {
    assert(mappings.containsKey(T), "type $T not found in $mappings");
    return mappings[T]!(this);
  }

  Deps override<T>(T Function(Deps deps) builder) {
    assert(mappings.containsKey(T), "$T not known. Use register");
    mappings[T] = builder;
    return this;
  }

  register(Map<Type, dynamic Function(Deps deps)> mappings) {
    this.mappings.addAll(mappings);
  }

  Deps copy() {
    return Deps(mappings: {...mappings}, config: {...config});
  }
}

class Preset {

  static final Map<String, Preset> _presets = {};

  static addDefaults(List<String> configurations, Map<Type, dynamic Function(Deps deps)> mappings) {
    for(final String config in configurations) {
      Preset.of(config)._deps.register(mappings);
    }
  }

  static Preset of(String id) {
    if(!_presets.containsKey(id)) {
      _presets[id] = Preset(id);
    }
    return _presets[id]!;
  }

  static Deps use(String id) {
    return Preset.of(id).deps;
  }

  // ==== dynamic area ======

  final String id;
  final Deps _deps = Deps();
  Preset? parent;

  Preset(this.id);

  Deps get deps {
    List<Preset> chain = [];
    Preset? current = this;
    while(current != null) {
      chain.add(current);
      current = current.parent;
    }
    return Deps.merge(chain.map((preset) => preset._deps));
  }

  fallsBackTo(String id) {
    parent = Preset.of(id);
  }
}