import 'dart:math';

import 'models.dart';
import 'repos.dart';

class Entry<T> {
  final String id;
  final T payload;
  Entry(this.id, this.payload);
}


abstract class FakeRepoMixin<T> {

  final List<Entry<T>> _entries = [];

  Set<T> all() {
    return _entries.map((e) => e.payload).toSet();
  }


  T? load(String key) {
    for(final entry in _entries) {
      if(key == entry.id) {
        return entry.payload;
      }
    }
    return null;
  }


  String store(T project) {
    String id = generateId();
    _entries.add(Entry(id, project));
    return id;
  }

  String generateId() {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(40, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  }
}


class ProjectRepoFake extends ProjectRepo with FakeRepoMixin<Project> {
  ProjectRepoFake(InvoiceRepo invoiceRepo, OfferRepo offerRepo, FileSystem fileSystem) : super(invoiceRepo, offerRepo, fileSystem);
}

class InvoiceRepoFake extends InvoiceRepo with FakeRepoMixin<Invoice> {
  InvoiceRepoFake(OfferRepo offerRepo) : super(offerRepo);
}

class OfferRepoFake extends OfferRepo with FakeRepoMixin<Offer> {
}

class OfferRepoFake2 extends OfferRepo with FakeRepoMixin<Offer> {
}

class ReleaseRepoFake extends ReleaseRepo with FakeRepoMixin<Release> {
}

class ReleaseRepoFake2 extends ReleaseRepo with FakeRepoMixin<Release> {
}

class FileSystemFake extends FileSystem {
}

class DummyInvoiceRepo extends InvoiceRepo with FakeRepoMixin<Invoice> {
  DummyInvoiceRepo(OfferRepo offerRepo) : super(offerRepo);

  @override
  String invoiceStuff() {
    return super.invoiceStuff() + "(dummy was here)";
  }
}