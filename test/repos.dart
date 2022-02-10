


import 'models.dart';

abstract class FileSystem {}

abstract class Repo<T> {
  String store(T element);
  T? load(String key);
  Set<T> all();
}

abstract class ProjectRepo implements Repo<Project> {

  final InvoiceRepo invoiceRepo;
  final OfferRepo offerRepo;
  final FileSystem fileSystem;

  ProjectRepo(this.invoiceRepo, this.offerRepo, this.fileSystem);
  
  String doStuff() {
    String invoiceRes = invoiceRepo.invoiceStuff();
    return "Project says hello, $invoiceRes";
  }
}

abstract class InvoiceRepo implements Repo<Invoice> {
  
  final OfferRepo offerRepo;


  InvoiceRepo(this.offerRepo);

  String invoiceStuff() {
    offerRepo.sayHello();
    return "invoice says hello";
  }
}

abstract class OfferRepo implements Repo<Offer> {
  sayHello() {
    print("Hello from OfferRepo");
  }
}

abstract class ReleaseRepo implements Repo<Release> {}