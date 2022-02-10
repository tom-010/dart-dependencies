
import 'package:dependencies/dependencies.dart';

import 'fakes.dart';
import 'repos.dart';

registerDeps() {
  Preset.of("test").fallsBackTo("dev");
  Preset.of("dev").fallsBackTo("prod");

  registerProjectDeps();
}

registerProjectDeps() {
  Preset.addDefaults(["dev", "prod"], {
    ProjectRepo: (deps) => ProjectRepoFake(deps.use<InvoiceRepo>(), deps.use<OfferRepo>(), deps.use<FileSystem>()),
    FileSystem: (deps) => FileSystemFake(),
    ReleaseRepo: (deps) => ReleaseRepoFake(),
    OfferRepo: (deps) => OfferRepoFake(),
    InvoiceRepo: (deps) => InvoiceRepoFake(deps.use<OfferRepo>()),
  });
}

