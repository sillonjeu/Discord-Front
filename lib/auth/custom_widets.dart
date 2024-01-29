import 'package:flutter/material.dart';
import 'package:discord_front/config/palette.dart';

// 커스텀 컨테이너
class CustomContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final BoxDecoration decoration;

  CustomContainer({
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    this.decoration = const BoxDecoration(
      color: Palette.blackColor1,
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
    ),
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    // 마진 설정하는 부분
    var verticalMargin = screenSize.height * 0.12;
    var horizontalMargin = screenSize.width * 0.06;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: verticalMargin,
        horizontal: horizontalMargin,
      ),
      padding: padding,
      decoration: decoration,
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            // 최소 높이를 화면 높이에서 상하 마진을 뺀 만큼으로 설정
            minHeight: screenSize.height - (verticalMargin * 2),
          ),
          child: IntrinsicHeight(
            child: child,
          ),
        ),
      ),
    );
  }
}

// 커스텀 텍스트 필드
class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;

  CustomTextFormField({
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            fillColor: Palette.blackColor4,
            filled: true,
          ),
        ),
      ],
    );
  }
}

// 커스텀 버튼 위젯
class CustomElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  CustomElevatedButton({
    required this.label,
    required this.onPressed,
    this.backgroundColor = Palette.btnColor,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label, style: TextStyle(color: textColor)),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
      ),
    );
  }
}

class CustomWidgets {
  // 커스텀 다이어로그
  static void showCustomDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) { // 수정된 부분
        return AlertDialog(
          backgroundColor: Palette.blackColor1,
          title: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // dialogContext를 사용
              },
              child: Text(
                'Close',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  // 커스텀 스낵바
  static void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

// 커스텀 날짜 선택 드롭다운
class CustomDatePickerDropdown extends StatelessWidget {
  final List<String> yearsList;
  final String selectedYear;
  final String selectedMonth;
  final String selectedDay;
  final ValueChanged<String?> onYearChanged;
  final ValueChanged<String?> onMonthChanged;
  final ValueChanged<String?> onDayChanged;

  CustomDatePickerDropdown({
    required this.yearsList,
    required this.selectedYear,
    required this.selectedMonth,
    required this.selectedDay,
    required this.onYearChanged,
    required this.onMonthChanged,
    required this.onDayChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date', style: TextStyle(color: Colors.white, fontSize: 16.0)),
        SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: _buildDropdownWithTheme(yearsList, selectedYear, onYearChanged, context),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: _buildDropdownWithTheme(_generateMonths(), selectedMonth, onMonthChanged, context),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: _buildDropdownWithTheme(_generateDays(selectedYear, selectedMonth), selectedDay, onDayChanged, context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdownWithTheme(List<String> items, String selectedValue, ValueChanged<String?> onChanged, BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Palette.blackColor4,
      ),
      child: _buildDropdown(items, selectedValue, onChanged),
    );
  }

  DropdownButtonFormField<String> _buildDropdown(List<String> items, String selectedValue, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      onChanged: onChanged,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(color: Colors.white)),
        );
      }).toList(),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        fillColor: Palette.blackColor4,
        filled: true,
      ),
    );
  }

  List<String> _generateMonths() {
    return List.generate(12, (int index) => (index + 1).toString().padLeft(2, '0'));
  }

  List<String> _generateDays(String year, String month) {
    int dayCount = DateUtils.getDaysInMonth(int.parse(year), int.parse(month));
    return List.generate(dayCount, (int index) => (index + 1).toString().padLeft(2, '0'));
  }
}