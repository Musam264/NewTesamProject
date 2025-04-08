class Goods {
  final String name;
  final String imageUrl;
  final int price;
  final String description;

  Goods({
    required this.name,
    required this.imageUrl,
    required this.price,
    this.description = '',
  });
}

final List<Goods> goodsList = [
  Goods(
    name: '아스피린',
    imageUrl: 'assets/images/aspirin.jpg',
    price: 1000,
    description: '통증 완화제',
  ),
  Goods(
    name: '비타민 D',
    imageUrl: 'assets/images/vitamin_d.jpg',
    price: 2000,
    description: '비타민 D 보충제',
  ),
  Goods(
    name: '게보린',
    imageUrl: 'assets/images/geborin.jpg',
    price: 3000,
    description: '두통 완화제',
  ),
  Goods(
    name: '텐텐',
    imageUrl: 'assets/images/tenten.jpg',
    price: 4000,
    description: '소화제',
  ),
  Goods(
    name: '와파린',
    imageUrl: 'assets/images/warfarin.jpg',
    price: 9000,
    description: '혈액 응고 방지제',
  ),
  Goods(
    name: '우루사',
    imageUrl: 'assets/images/urusa.jpg',
    price: 2000,
    description: '간 건강 보조제',
  ),
  Goods(
    name: '레모나',
    imageUrl: 'assets/images/lemona.jpg',
    price: 3000,
    description: '비타민 C 보충제',
  ),
  Goods(
    name: '인사돌',
    imageUrl: 'assets/images/insadol.jpg',
    price: 4000,
    description: '인삼 보충제',
  ),
];
