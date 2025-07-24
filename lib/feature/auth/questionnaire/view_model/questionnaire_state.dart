import 'package:edumind_intro_app/product/widget/dropdown/model/school_grade.dart';
import 'package:edumind_intro_app/product/widget/dropdown/model/turkish_city.dart';
import 'package:equatable/equatable.dart';

/// QuestionnaireState represents the state of the questionnaire view
final class QuestionnaireState extends Equatable {
  /// Creates a new instance of [QuestionnaireState]
  const QuestionnaireState({this.selectedCity, this.selectedGrade});

  /// [selectedCity] is the currently selected city from the dropdown
  final TurkishCity? selectedCity;

  /// [selectedGrade] is the currently selected school grade from the dropdown
  final SchoolGrade? selectedGrade;

  @override
  List<Object?> get props => [
        selectedCity,
        selectedGrade,
      ];

  /// Creates a copy of the current state with optional new values for selectedCity and selectedGrade
  QuestionnaireState copyWith({
    TurkishCity? selectedCity,
    SchoolGrade? selectedGrade,
  }) {
    return QuestionnaireState(
      selectedCity: selectedCity ?? this.selectedCity,
      selectedGrade: selectedGrade ?? this.selectedGrade,
    );
  }
}
