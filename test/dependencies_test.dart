
import 'package:dependencies/dependencies.dart';
import 'package:test/test.dart';
import 'fakes.dart';
import 'register_deps.dart';
import 'repos.dart';

main() {
  test('sample usage', () {
    registerDeps();
    final deps = Preset.use("test").override<InvoiceRepo>((deps) => DummyInvoiceRepo(deps.use<OfferRepo>()));
    final repo = deps.use<ProjectRepo>();
    print(repo.doStuff());
    // expect('1', equals(2));
  });
}
