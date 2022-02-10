
import 'package:dependencies/dependencies.dart';

import 'fakes.dart';
import 'repos.dart';

registerDeps() {
  Preset.of('test').fallsBackTo('dev');
  Preset.of('dev').fallsBackTo('prod');

  registerProjectDeps();
}

registerProjectDeps() {
  Preset.addDefaults(['prod', 'custom'], {
    ProjectRepo: (deps) => ProjectRepoFake(deps.use<InvoiceRepo>(), deps.use<OfferRepo>(), deps.use<FileSystem>()),
    FileSystem: (deps) => FileSystemFake(),
    OfferRepo: (deps) => OfferRepoFake(),
    InvoiceRepo: (deps) => InvoiceRepoFake(deps.use<OfferRepo>()),
  });
  Preset.addDefaults(['custom'], {
    ReleaseRepo: (deps) => ReleaseRepoFake(),
  });
  Preset.addDefaults(['dev'], {
    OfferRepo: (deps) => OfferRepoFake2()
  });
  Preset.addDefaults(['test'], {
    ReleaseRepo: (deps) => ReleaseRepoFake2()
  });
}
