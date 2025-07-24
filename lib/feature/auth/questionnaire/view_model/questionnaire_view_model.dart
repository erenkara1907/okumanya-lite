import 'package:edumind_intro_app/feature/auth/questionnaire/view_model/questionnaire_state.dart';
import 'package:edumind_intro_app/product/cache/model/user_data.dart';
import 'package:edumind_intro_app/product/state/base/base_cubit.dart';
import 'package:edumind_intro_app/product/state/container/product_items.dart';
import 'package:edumind_intro_app/product/widget/dropdown/model/school_grade.dart';
import 'package:edumind_intro_app/product/widget/dropdown/model/turkish_city.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

/// QuestionnaireViewModel is a ViewModel for managing the state of the questionnaire view
final class QuestionnaireViewModel extends BaseCubit<QuestionnaireState> {
  /// Creates a new instance of [QuestionnaireViewModel]
  QuestionnaireViewModel() : super(const QuestionnaireState());

  final _cacheService = ProductItems.userDataCacheService;

  /// Change the selected city in the questionnaire state
  void changeCity({required TurkishCity city}) {
    emit(state.copyWith(selectedCity: city));
  }

  /// Change the selected grade in the questionnaire state
  void changeGrade({required SchoolGrade grade}) {
    emit(state.copyWith(selectedGrade: grade));
  }

  /// Creates user data with unique nickname and saves to cache
  Future<UserData> createUserData({
    required String nickName,
    required String schoolName,
  }) async {
    try {
      if (kDebugMode) {
        print('🚀 Creating User Data with Cache...');
        print('📝 Form Data:');
        print('   • Nickname: "$nickName"');
        print('   • School: "$schoolName"');
        print('   • City: "${state.selectedCity?.name}"');
        print('   • Grade: "${state.selectedGrade?.name}"');
        print('');
      }

      // Generate a new UUID for user ID
      final userId = const Uuid().v4();

      // Create user data
      final userData = UserData(
        id: userId,
        nickName: nickName,
        originalNickName: nickName,
        schoolName: schoolName,
        city: state.selectedCity!,
        grade: state.selectedGrade!,
        createdAt: DateTime.now(),
      );

      // Save to cache
      await _cacheService.saveCurrentUser(userData);

      if (kDebugMode) {
        print('📋 UserData created and cached successfully!');
        print('💾 Cache operations completed');
        print('═' * 60);
      }

      return userData;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error creating user data: $e');
      }
      rethrow;
    }
  }
}
