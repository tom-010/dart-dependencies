
import 'package:dependencies/dependencies.dart';
import 'package:test/test.dart';
import 'fakes.dart';
import 'register_deps.dart';
import 'repos.dart';

main() {
  test('sample usage', () {
    registerDeps();
    final deps = Preset.use('test').override<InvoiceRepo>((deps) => DummyInvoiceRepo(deps.use<OfferRepo>()));
    final repo = deps.use<ProjectRepo>();
    print(repo.doStuff());
    // expect('1', equals(2));
  });

  test('register a dep', () {
    final deps = Dependencies();
    deps.register({OfferRepo: (deps) => OfferRepoFake()});
    expect(deps.use<OfferRepo>() is OfferRepoFake, isTrue);
  });

  test('register two concerete implementations for one abstract type. Last wins.', () {
    final deps = Dependencies();
    deps.register({OfferRepo: (deps) => OfferRepoFake()});
    deps.register({OfferRepo: (deps) => OfferRepoFake2()});

    expect(deps.use<OfferRepo>() is OfferRepoFake, isFalse);
    expect(deps.use<OfferRepo>() is OfferRepoFake2, isTrue);
  });

  test('override a dependency', () {
    final deps = Dependencies();
    deps.register({OfferRepo: (deps) => OfferRepoFake()});
    deps.override<OfferRepo>((deps) => OfferRepoFake2());
    expect(deps.use<OfferRepo>() is OfferRepoFake, isFalse);
    expect(deps.use<OfferRepo>() is OfferRepoFake2, isTrue);
  });

  test('copy dependencies', () {
    final deps = Dependencies();
    deps.register({OfferRepo: (deps) => OfferRepoFake()});
    final copy = deps.copy();
    deps.register({OfferRepo: (deps) => OfferRepoFake2()});
    expect(deps.use<OfferRepo>() is OfferRepoFake2, isTrue);
    expect(copy.use<OfferRepo>() is OfferRepoFake, isTrue); // copy has still the old
  });

  // preset-land

  test('adding a default to environments', () {
    registerDeps();
    final deps = Preset.use('custom');
    expect(deps.use<ReleaseRepo>() is ReleaseRepoFake, isTrue);
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
    expect(deps.use<ProjectRepo>() is ProjectRepoFake, isTrue);
  });

  test('my implemenation is prefered over the fallback', () {
    final deps = Preset.use('test');
    expect(deps.use<ReleaseRepo>() is ReleaseRepoFake2, isTrue);
  });

  test('nearest implementation is preffered', () {
    final deps = Preset.use('dev');
    expect(deps.use<OfferRepo>() is OfferRepoFake2, isTrue);
  });
}
