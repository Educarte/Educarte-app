enum ModalType {
  confirmEntry(title: "Confirmar Entrada", height: 550);

  final String title;
  final double height;
  const ModalType({
    required this.title,
    required this.height
  });
}