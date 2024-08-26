class Document {
  String? id;
  String? name;
  String? fileUri;
  DateTime? startDate;
  DateTime? validUntil;

  Document({
    this.id,
    this.name,
    this.fileUri,
    this.startDate,
    this.validUntil
  });

  Document.empty();
}