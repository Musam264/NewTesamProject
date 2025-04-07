
// 상품의 형태 클래스
class Goods {
  final String name;
  final String imageUrl;
  final int price;
  Goods({required this.name, required this.imageUrl, required this.price});
}

// 상품 리스트. 경로는 assets/images 폴더에 위치하고, 모두 jpg파일
final List<Goods> goodsList = [
  Goods(name: '아스피린', imageUrl: 'assets/images/aspirin.jpg', price: 1000),
  Goods(name: '비타민 D', imageUrl: 'assets/images/vitamin_d.jpg', price: 2000),
  Goods(name: '게보린', imageUrl: 'assets/images/geborin.jpg', price: 3000),
  Goods(name: '텐텐', imageUrl: 'assets/images/tenten.jpg', price: 4000),
  Goods(name: '와파린', imageUrl: 'assets/images/warfarin.jpg', price: 9000),
  Goods(name: '우루사', imageUrl: 'assets/images/urusa.jpg', price: 2000),
  Goods(name: '레모나', imageUrl: 'assets/images/lemona.jpg', price: 3000),
  Goods(name: '인사돌', imageUrl: 'assets/images/insadol.jpg', price: 4000),
];