
import 'package:deps/deps.dart';
import 'package:test/test.dart';
import 'fakes.dart';
import 'register_deps.dart';
import 'repos.dart';

main() {
  test('sample usage', () {
    registerDeps();
    final deps = Preset.use('test').override<InvoiceRepo>((deps) => DummyInvoiceRepo(deps.use<OfferRepo>()));
    final repo = deps[ProjectRepo];
    String res = repo.doStuff();
    expect(res, equals('Project says hello, invoice says hello(dummy was here)'));
  });

  test('register a dep', () {
    final deps = Deps();
    deps.register({OfferRepo: (deps) => OfferRepoFake()});
    expect(deps.use<OfferRepo>() is OfferRepoFake, isTrue);
  });

  test('access via []', () {
    final deps = Deps();
    deps.register({OfferRepo: (deps) => OfferRepoFake()});
    expect(deps[OfferRepo] is OfferRepoFake, isTrue);
  });

  test('register two concerete implementations for one abstract type. Last wins.', () {
    final deps = Deps();
    deps.register({OfferRepo: (deps) => OfferRepoFake()});
    deps.register({OfferRepo: (deps) => OfferRepoFake2()});

    expect(deps[OfferRepo] is OfferRepoFake, isFalse);
    expect(deps[OfferRepo] is OfferRepoFake2, isTrue);
  });

  test('override a dependency', () {
    final deps = Deps();
    deps.register({OfferRepo: (deps) => OfferRepoFake()});
    deps.override<OfferRepo>((deps) => OfferRepoFake2());
    expect(deps[OfferRepo] is OfferRepoFake, isFalse);
    expect(deps[OfferRepo] is OfferRepoFake2, isTrue);
  });

  test('copy dependencies', () {
    final deps = Deps();
    deps.register({OfferRepo: (deps) => OfferRepoFake()});
    final copy = deps.copy();
    deps.register({OfferRepo: (deps) => OfferRepoFake2()});
    expect(deps[OfferRepo] is OfferRepoFake2, isTrue);
    expect(copy[OfferRepo] is OfferRepoFake, isTrue); // copy has still the old
  });

  // preset-land

  test('adding a default to environments', () {
    registerDeps();
    final deps = Preset.use('custom');
    expect(deps[ReleaseRepo] is ReleaseRepoFake, isTrue);
  });

  test('Preset.of with id found', () {
    Preset.of('custom');
  });

  test('Preset.of with id not found creates it', () {
    Preset.of('asfdadsfdsafas');
  });

  test('setting fallback', () {
    // nothing was registered on test, but it has the fallback prod
    final deps = Preset.use('test');
    expect(deps[ProjectRepo] is ProjectRepoFake, isTrue);
  });

  test('my implemenation is prefered over the fallback', () {
    final deps = Preset.use('test');
    expect(deps[ReleaseRepo] is ReleaseRepoFake2, isTrue);
  });

  test('nearest implementation is preffered', () {
    final deps = Preset.use('dev');
    expect(deps[OfferRepo] is OfferRepoFake2, isTrue);
  });

  // Configuration
  test('storing and retrieving configurations', () {
    final deps = Deps();
    String stringEntry = 'entry';
    int intEntry = 1;
    double doubleEntry = 1.4;
    OfferRepoFake customTypeEntry = OfferRepoFake();

    deps.config['stringEntry'] = stringEntry;
    deps.config['intEntry'] = intEntry;
    deps.config['doubleEntry'] = doubleEntry;
    deps.config['customTypeEntry'] = customTypeEntry;

    String resStringEntry = deps.config['stringEntry'] ?? '';
    int resIntEntry = deps.config['intEntry'] ?? 0;
    double resDoubleEntry = deps.config['doubleEntry'] ?? 0.0;
    OfferRepoFake resCustomTypeEntry = deps.config['customTypeEntry'] ?? OfferRepoFake();

    expect(resStringEntry, equals(stringEntry));
    expect(resIntEntry, equals(intEntry));
    expect(resDoubleEntry, equals(doubleEntry));
    expect(resCustomTypeEntry, equals(customTypeEntry));
  });


  test('config is cloned', () {
    final deps = Deps();
    deps.config['key'] = 'value';
    final copy = deps.copy();
    deps.config['key'] = 'new value';

    expect(deps.config['key'], equals('new value'));
    expect(copy.config['key'], equals('value'));

  });
}
