// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:nvs_trading/data/model/list_nice_number.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class NiceNumber extends StatefulWidget {
  NiceNumber({
    super.key,
    required this.currentStep,
    required this.onNextPressed,
  });
  int currentStep;
  VoidCallback onNextPressed;

  @override
  State<NiceNumber> createState() => _NiceNumberState();
}

class _NiceNumberState extends State<NiceNumber> {
  int selectedRowIndex = -1;
  List<NiceNum> niceNum = [
    NiceNum('811668', '500,000'),
    NiceNum('868686', '200,000'),
    NiceNum('666688', '500,000'),
    NiceNum('667715', '250,000'),
    NiceNum('444444', '500,000'),
  ];
  bool isAscending = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 30),
              child: customTextStyleBody(
                text: "CHỌN LOẠI TÀI KHOẢN SỐ ĐẸP",
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.amber),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: "Tìm kiếm số mong muốn",
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            late NiceNum selectedNiceNum;
                            if (selectedRowIndex >= 0) {
                              selectedNiceNum = niceNum[selectedRowIndex];
                            }
                            // Sắp xếp niceNum dựa trên số tài khoản
                            niceNum.sort(
                              (a, b) {
                                if (isAscending) {
                                  return a.stk.compareTo(b.stk);
                                } else {
                                  return b.stk.compareTo(a.stk);
                                }
                              },
                            );
                            if (selectedRowIndex >= 0) {
                              selectedRowIndex =
                                  niceNum.indexOf(selectedNiceNum);
                            }

                            // Đảo ngược trạng thái sắp xếp
                            isAscending = !isAscending;
                          });
                        },
                        child: Row(
                          children: [
                            customTextStyleBody(
                              text: "Sắp xếp",
                              color: Colors.orange,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.orange,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            customTextStyleBody(
                              text: "Vị trí thứ tự mong muốn",
                              color: Colors.orange,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.orange,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Colors.amber,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: customTextStyleBody(
                      text: "Đặt lại",
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white,
                ),
              ),
              child: FittedBox(
                child: DataTable(
                  dividerThickness: 0,
                  columns: const [
                    DataColumn(
                      label: Text("STT"),
                    ),
                    DataColumn(
                      label: Text("Số tài khoản"),
                    ),
                    DataColumn(
                      label: Text("Giá trị"),
                    ),
                    DataColumn(
                      label: Text(""),
                    ),
                  ],
                  rows: niceNum.asMap().entries.map((entry) {
                    int index = entry.key;
                    NiceNum niNu = entry.value;
                    return DataRow(
                      cells: [
                        DataCell(
                          customTextStyleBody(
                            text: (index + 1).toString(),
                            size: 16,
                            color: selectedRowIndex == index
                                ? Colors.amber
                                : Colors.white,
                          ),
                        ),
                        DataCell(
                          customTextStyleBody(
                            text: niNu.stk,
                            size: 16,
                            color: selectedRowIndex == index
                                ? Colors.amber
                                : Colors.white,
                          ),
                        ),
                        DataCell(
                          customTextStyleBody(
                            text: niNu.giatri,
                            size: 16,
                            color: selectedRowIndex == index
                                ? Colors.amber
                                : Colors.white,
                          ),
                        ),
                        DataCell(
                          ButtonClick(index),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: const Color(0xFF1D2029),
        padding: const EdgeInsets.all(12),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE7AB21),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            if (widget.currentStep != 5) {
              widget.onNextPressed();
            }
          },
          child: customTextStyleBody(
            text: "Tiếp theo",
            size: 14,
            color: const Color(0xFF131721),
          ),
        ),
      ),
    );
  }

  ElevatedButton ButtonClick(rowIndex) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(90, 40),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor:
            selectedRowIndex == rowIndex ? Colors.amber : Colors.grey.shade800,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: selectedRowIndex == rowIndex ? Colors.amber : Colors.white,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        setState(() {
          selectedRowIndex = rowIndex;
        });
      },
      child: customTextStyleBody(
        text: selectedRowIndex == rowIndex ? "Đã chọn" : "Chọn",
        color: selectedRowIndex == rowIndex ? Colors.black : Colors.white,
      ),
    );
  }
}
