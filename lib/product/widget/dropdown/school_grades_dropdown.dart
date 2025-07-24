import 'package:edumind_intro_app/product/widget/dropdown/model/school_grade.dart';
import 'package:flutter/material.dart';

/// School Grades Dropdown - No Keyboard Version
class SchoolGradesDropdownNoKeyboard extends StatelessWidget {
  const SchoolGradesDropdownNoKeyboard({
    required this.onChanged,
    super.key,
    this.value,
    this.hintText = 'Sınıf Seçiniz',
  });

  final ValueChanged<SchoolGrade?> onChanged;
  final SchoolGrade? value;
  final String hintText;

  static final List<SchoolGrade> _grades = [
    const SchoolGrade(name: '1. Sınıf', level: 1, id: '1'),
    const SchoolGrade(name: '2. Sınıf', level: 2, id: '2'),
    const SchoolGrade(name: '3. Sınıf', level: 3, id: '3'),
    const SchoolGrade(name: '4. Sınıf', level: 4, id: '4'),
  ];

  void _showGradeSelectionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        maxChildSize: 0.45,
        initialChildSize: 0.45,
        minChildSize: 0.2,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 24),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Sınıf Seçiniz',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.black38,
                ),
              ),

              // Grades list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _grades.length,
                  itemBuilder: (context, index) {
                    final grade = _grades[index];
                    final isSelected = value?.id == grade.id;
                    var subtitle = '';

                    if (grade.level <= 4) {
                      subtitle = 'İlkokul';
                    } else if (grade.level <= 8) {
                      subtitle = 'Ortaokul';
                    } else {
                      subtitle = 'Lise';
                    }

                    return ListTile(
                      title: Text(
                        grade.name,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.black87,
                        ),
                      ),
                      subtitle: Text(subtitle),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: Theme.of(context).primaryColor,
                            )
                          : null,
                      onTap: () {
                        onChanged(grade);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showGradeSelectionModal(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Icon(Icons.grade, color: Colors.black45),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value?.name ?? hintText,
                style: TextStyle(
                  fontSize: 16,
                  color: value != null ? Colors.black87 : Colors.grey.shade600,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
