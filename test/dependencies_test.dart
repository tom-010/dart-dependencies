
import 'package:dependencies/dependencies.dart';
import 'package:test/test.dart';

main() {
  test('sample usage', () {
    expect('1', equals(2));
    // registerDeps();
    // final deps = Preset.use("test").override<InvoiceRepo>((deps) => DummyInvoiceRepo(deps.use<OfferRepo>()));
    // final repo = deps.use<ProjectRepo>();
    // print(repo.doStuff());
  });
}
