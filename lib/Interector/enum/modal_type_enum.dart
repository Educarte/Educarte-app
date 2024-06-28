enum ModalType {
  confirmEntry(title: "Confirmar Entrada", height: 550),
  confirmExit(title: "Confirmar Saída", height: 550),
  menu(title: "Cardápio em PDF", height: 277),
  archive(title: "Arquivo em PDF", height: 277);

  final String title;
  final double height;
  const ModalType({
    required this.title,
    required this.height
  });
}