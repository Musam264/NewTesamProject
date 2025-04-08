import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NameAndInputText extends StatefulWidget {
  final String name;
  final bool isPrice;
  final TextEditingController? controller;

  const NameAndInputText({
    super.key,
    required this.name,
    this.isPrice = false,
    this.controller,
  });

  @override
  State<NameAndInputText> createState() => _NameAndInputTextState();
}

class _NameAndInputTextState extends State<NameAndInputText> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      // 포커스가 있을 때는 숫자만 표시
      _controller.text = _controller.text.replaceAll(RegExp(r'[^0-9]'), '');
    } else if (_controller.text.isNotEmpty) {
      // 포커스가 없을 때는 천 단위 구분자와 '원' 추가
      final number = int.tryParse(
        _controller.text.replaceAll(RegExp(r'[^0-9]'), ''),
      );
      if (number != null) {
        _controller.text =
            '${number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원';
      }
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    // 외부에서 전달받은 컨트롤러는 여기서 dispose하지 않음
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Colors.grey.shade400)),
            ),
            child: Text(
              widget.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              keyboardType:
                  widget.isPrice ? TextInputType.number : TextInputType.text,
              textInputAction: TextInputAction.done,
              enableIMEPersonalizedLearning: true,
              enableSuggestions: true,
              autocorrect: true,
              textCapitalization: TextCapitalization.none,
              style: const TextStyle(fontSize: 16, height: 1.5),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                border: InputBorder.none,
                hintText: '입력해주세요',
              ),
              onTap: () {
                _controller.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _controller.text.length,
                );
              },
              onSubmitted: (value) {
                FocusScope.of(context).unfocus();
              },
            ),
          ),
        ],
      ),
    );
  }
}
