class OnBoardingModel {
  final String title;
  final String subtitle;
  final String image;

  OnBoardingModel({
    required this.title,
    required this.subtitle,
    required this.image,
  });

  static final List<OnBoardingModel> onBoardingData = [
    OnBoardingModel(
      title: "تسوق ذكي، أسعار أذكى",
      subtitle:
          "اكتشف عروضًا يومية لا مثيل لها على الأساسيات والإلكترونيات والمزيد. يقدم لك شيفت ماركت أفضل قيمة تحت أطراف أصابعك.",
      image: 'assets/images/png/on_boarding_1.png',
    ),
    OnBoardingModel(
      title: "أسلوب حياتك، كله في مكان واحد",
      subtitle:
          "من الأزياء إلى ديكور المنزل، يقدم سنترو ماركت مجموعة مختارة من المنتجات العصرية لتتناسب مع أسلوبك اليومي واحتياجاتك.",
      image: 'assets/images/png/on_boarding_2.png',
    ),
    OnBoardingModel(
      title: "تسوق من المول، في أي مكان",
      subtitle:
          "استمتع بتجربة مول كاملة من هاتفك — مع أفضل الماركات، والإصدارات الجديدة، وعروض حصرية عبر الإنترنت في ياسر مول.",
      image: 'assets/images/png/on_boarding_3.png',
    ),
  ];
}
