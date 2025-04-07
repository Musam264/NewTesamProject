import 'package:flutter/material.dart';
import 'goods.dart'; //상품에 대한 정보들

class MainPage extends StatelessWidget {
  const MainPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //1. 상단 검색 버튼
            Container(
              child: Text('Search'),
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
            ),
            

            // 2. Product list 텍스트 + 상품 추가 버튼.
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12), //
              child: Row(
                children: [
                  const Text(
                    '제품 목록',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      // Navigator.push(context); 상품 추가로 이동 버튼
                    },
                  ),
                ],
              ),
            ),

            // 3. 상품 목록
            Expanded(
              child:
                  goodsList.isEmpty
                      ? const Center(
                        child: Text('상품이 없습니다'),
                      ) //아무것도 없는 경우 텍스트만 띄우기
                      //그리드뷰로 바둑판 배열. crossAxisCount 2개씩
                      : GridView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: goodsList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                            ),
                        itemBuilder: (context, index) {
                          final goods = goodsList[index];
                          return buildGoods(goods); //각 칸마다 상품 컨테이너 삽입
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  // 상품 컨테이너. 여기서 상품 상세로 넘어감
  Widget buildGoods(Goods goods) {
    return GestureDetector(
      onTap: () {
        //// Navigator.push(context, goodsList[name]); 상품 상세로 넘기기
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, //좌측 정렬
          children: [
            //이미지
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  goods.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 8),

            //상품명
            Text(
              goods.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),

            // 가격(세 자리마다 쉼표 적용 완료)
            Text(
              '${goods.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}원',
            ),
          ],
        ),
      ),
    );
  }
}
