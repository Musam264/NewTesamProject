import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/nameandinputtext.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'mainpage.dart';
import 'goods.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      // 에러 발생 시 사용자에게 알림
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('이미지를 선택하는 중 오류가 발생했습니다.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      print('이미지 선택 오류: $e');
    }
  }

  Future<String> _saveImage(File imageFile) async {
    // 앱의 로컬 문서 디렉토리 가져오기
    final directory = await getApplicationDocumentsDirectory();
    final String imageDir = '${directory.path}/product_images';

    // 디렉토리가 없으면 생성
    final imageDirectory = Directory(imageDir);
    if (!await imageDirectory.exists()) {
      await imageDirectory.create(recursive: true);
    }

    // 이미지 파일 이름 생성 (현재 시간을 기반으로)
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final imageFileName = 'product_$timestamp.jpg';
    final String imagePath = '$imageDir/$imageFileName';

    // 이미지 파일 복사
    await imageFile.copy(imagePath);

    return imagePath;
  }

  Future<void> _registerProduct() async {
    // 입력값 검증
    if (_nameController.text.isEmpty) {
      _showSnackBar('상품명을 입력해주세요.');
      return;
    }

    if (_priceController.text.isEmpty) {
      _showSnackBar('가격을 입력해주세요.');
      return;
    }

    if (_image == null) {
      _showSnackBar('이미지를 선택해주세요.');
      return;
    }

    // 가격 문자열에서 숫자만 추출
    final priceString = _priceController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final price = int.tryParse(priceString);

    if (price == null) {
      _showSnackBar('올바른 가격을 입력해주세요.');
      return;
    }

    try {
      // 이미지 파일 저장
      final String imagePath = await _saveImage(_image!);

      // 새 상품 생성
      final newProduct = Goods(
        name: _nameController.text,
        imageUrl: imagePath, // 실제 저장된 이미지 경로 사용
        price: price,
        description: _descriptionController.text,
      );

      // 상품 목록에 추가
      goodsList.add(newProduct);

      // 등록 완료 메시지 표시
      _showSnackBar('상품이 등록되었습니다.');

      // 메인 페이지로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } catch (e) {
      print('상품 등록 오류: $e');
      _showSnackBar('상품 등록 중 오류가 발생했습니다.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "상품등록",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainPage(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: const Text(
                          "등록취소",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      _image != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(_image!, fit: BoxFit.cover),
                          )
                          : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 50,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '이미지 추가',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                ),
              ),
              const SizedBox(height: 30),
              NameAndInputText(name: "상품명", controller: _nameController),
              const SizedBox(height: 20),
              NameAndInputText(
                name: "가격",
                isPrice: true,
                controller: _priceController,
              ),
              const SizedBox(height: 20),
              const Text(
                "상품 설명",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: '상품에 대한 설명을 입력해주세요',
                    contentPadding: EdgeInsets.all(12),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _registerProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    '상품 등록',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
