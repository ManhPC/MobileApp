import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';

import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class ScanCCCD extends StatefulWidget {
  const ScanCCCD({super.key});

  @override
  State<ScanCCCD> createState() => _ScanCCCDState();
}

class _ScanCCCDState extends State<ScanCCCD> {
  // Uint8List? _image;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 30),
                  child: customTextStyleBody(
                    text: "CHỤP ẢNH CMND/CCCD",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Image.network(
                    'https://lawnet.vn/uploads/image/2020/10/15/CCCD-gan-chip-moi-va-nhung-dieu-cong-dan-nen-biet.jpg',
                  ),
                ),
                customTextStyleBody(
                  txalign: TextAlign.start,
                  text: "• Đảm bảo thiết bị đã được cấp quyền truy cập máy ảnh",
                  color: const Color(0xFFE2E2E2),
                ),
                customTextStyleBody(
                  txalign: TextAlign.start,
                  text:
                      "• Giấy tờ tùy thân chính chủ và còn hạn sử dụng (là ảnh gốc, không scan và photocopy)",
                  color: const Color(0xFFE2E2E2),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 10,
          right: 10,
          bottom: 15,
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D2029),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFFE7AB21),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        )),
                    onPressed: () {
                      // _pickImageFromGallery();
                    },
                    child: customTextStyleBody(
                      text: "Tải ảnh",
                      color: const Color(0xFFE7AB21),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE7AB21),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                    onPressed: () {
                      // _pickImageFromCamera();
                    },
                    child: customTextStyleBody(
                      text: "Chụp ảnh",
                      color: const Color(0xFF131721),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
