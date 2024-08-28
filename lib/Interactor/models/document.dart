class Document {
  String? id;
  String? name;
  String? fileUri;
  String? startDate;
  String? validUntil;

  Document({
    this.id,
    this.name,
    this.fileUri,
    this.startDate,
    this.validUntil
  });

  Document.empty();
}