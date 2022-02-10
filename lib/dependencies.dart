class Config {

}

class Dependencies {
  final Map<Type, dynamic Function(Dependencies)> mappings;

  Dependencies([final Map<Type, dynamic Function(Dependencies)>? mappings])
    : mappings = mappings ?? {};

  static Dependencies merge(Iterable<Dependencies> depsChain) {
    final res = Dependencies();
    for(Dependencies deps in depsChain) {
      for(Type t in deps.mappings.keys) {
        if(!res.mappings.containsKey(t)) {
          res.mappings[t] = deps.mappings[t]!;
        }
      }
    }
    return res;
  }

  T use<T>() {
    assert(mappings.containsKey(T), "type $T not found in $mappings");
    return mappings[T]!(this);
  }

  Dependencies override<T>(T Function(Dependencies deps) builder) {
    assert(mappings.containsKey(T), "$T not known. Use register");
    mappings[T] = builder;
    return this;
  }

  register(Map<Type, dynamic Function(Dependencies deps)> mappings) {
    this.mappings.addAll(mappings);
  }

  Dependencies copy() {
    return Dependencies({...mappings});
  }
}

class Preset {

  static final Map<String, Preset> _presets = {};

  static addDefaults(List<String> configurations, Map<Type, dynamic Function(Dependencies deps)> mappings) {
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

  static Dependencies use(String id) {
    return Preset.of(id).deps;
  }

  // ==== dynamic area ======

  final String id;
  final Dependencies _deps = Dependencies();
  Preset? parent;

  Preset(this.id);

  Dependencies get deps {
    List<Preset> chain = [];
    Preset? current = this;
    while(current != null) {
      chain.add(current);
      current = current.parent;
    }
    return Dependencies.merge(chain.map((preset) => preset._deps));
  }

  fallsBackTo(String id) {
    parent = Preset.of(id);
  }
}