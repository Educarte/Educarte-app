enum CardHomeType{
  timer(
    firstTitle: "Entrada",
    secondaryTitle: "e saída",
    backgroundImage: "assets/imgEntSd.png"
  ),
  menu(
    firstTitle: "Atualização\ndo ",
    secondaryTitle: "CARDÁPIO",
    backgroundImage: "assets/imgAtualizacao.png"
  );

  final String firstTitle;
  final String secondaryTitle;
  final String backgroundImage;
  const CardHomeType({
    required this.firstTitle,
    required this.secondaryTitle,
    required this.backgroundImage
  });
}