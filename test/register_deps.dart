import 'package:deps/deps.dart';

import 'fakes.dart';
import 'repos.dart';

registerDeps() {
  Preset.of('test').fallsBackTo('dev');
  Preset.of('dev').fallsBackTo('prod');

  registerProjectDeps();
}

registerProjectDeps() {
  Preset.addDefaults(['prod', 'custom'], {
    ProjectRepo: (deps) => ProjectRepoFake(deps[InvoiceRepo], deps[OfferRepo], deps[FileSystem]),
    FileSystem: (deps) => FileSystemFake(),
    OfferRepo: (deps) => OfferRepoFake(),
    InvoiceRepo: (deps) => InvoiceRepoFake(deps[OfferRepo]),
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
