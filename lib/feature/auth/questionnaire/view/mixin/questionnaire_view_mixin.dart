part of '../questionnaire_view.dart';

/// Mixin for [QuestionnaireView] to encapsulate common functionality
mixin QuestionnaireViewMixin
    on BaseState<QuestionnaireView>, ValidationMixin<QuestionnaireView> {
  late final QuestionnaireViewModel _viewModel;

  /// [viewModel] is the instance of [QuestionnaireViewModel] used in this view
  QuestionnaireViewModel get viewModel => _viewModel;

  /// [nickNameController] is a controller for the nickname input field
  late final TextEditingController nickNameController;

  /// [gradeController] is a controller for the school name input field
  late final TextEditingController gradeController;

  /// [nickNameFocusNode] is a focus node for the nickname input field
  late final FocusNode nickNameFocusNode;

  /// [gradeFocusNode] is a focus node for the birth year input field
  late final FocusNode gradeFocusNode;

  /// [schoolNameFocusNode] is a focus node for the school name input field
  late final FocusNode schoolNameFocusNode;

  /// [cityFocusNode] is a focus node for the city input field
  late final FocusNode cityFocusNode;

  @override
  void initState() {
    super.initState();
    _viewModel = QuestionnaireViewModel();

    _initializeControllersAndFocusNodes();
  }

  @override
  void dispose() {
    super.dispose();
    nickNameController.dispose();
    gradeController.dispose();
  }

  void _initializeControllersAndFocusNodes() {
    nickNameController = TextEditingController();
    gradeController = TextEditingController();
    nickNameFocusNode = FocusNode();
    gradeFocusNode = FocusNode();
    schoolNameFocusNode = FocusNode();
    cityFocusNode = FocusNode();
  }

  /// Validates form data using core validation system
  bool _validateForm() {
    return validateMultipleFields([
      () => validateDropdown(
            viewModel.state.selectedCity,
            fieldName: 'Şehir',
          ),
      () => validateDropdown(
            viewModel.state.selectedGrade,
            fieldName: 'Sınıf',
          ),
    ]);
  }

  /// Creates a unique nickname with UUID prefix (short version)
  String createUniqueNickname(String originalNickname) {
    const uuid0 = Uuid();

    final uuid = uuid0.v4();
    final shortUuid = uuid.split('-').first;
    final uniqueNickname = '${shortUuid}_$originalNickname';

    // Debug print to show the generated nickname
    if (kDebugMode) {
      print('🔹 Original Nickname: $originalNickname');
      print('🆔 Generated UUID: $uuid');
      print('🔹 Short UUID: $shortUuid');
      print('✅ Unique Nickname: $uniqueNickname');
      print('─' * 50);
    }

    return uniqueNickname;
  }

  /// Handles form submission with validation and data processing
  Future<void> _handleSubmit() async {
    if (!_validateForm()) return;

    try {
      final uniqueNickname =
          createUniqueNickname(nickNameController.text.trim());
      if (kDebugMode) {
        print('✅ Unique Nickname: $uniqueNickname');
      }
      // Create UserData with UUID + Nickname
      final userData = viewModel.createUserData(
        nickName: uniqueNickname,
        schoolName: gradeController.text.trim(),
      );

      await AuthApiService.login();

      // Show success message using core system
      showSuccess('Bilgileriniz başarıyla kaydedildi');

      // Navigate to next screen after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        context.router.push(const BookListRoute());
      });

      // Optional: Log or save userData
      debugPrint('User Data Created: $userData');
    } catch (e) {
      showError('Bir hata oluştu. Lütfen tekrar deneyiniz.');
      debugPrint('Error creating user data: $e');
    }
  }

  Column _body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Assets.icons.splash.svg(
          package: 'gen',
          width: 200,
          height: 200,
        ),
        const SizedBox(height: 40),
        ProductInput(
          prefixIcon: const Icon(Icons.person, color: Colors.black45),
          controller: nickNameController,
          focusNode: nickNameFocusNode,
          hintText: 'Kullanıcı Adı Giriniz',
        ),
        const SizedBox(height: 16),
        ProductInput(
          prefixIcon: const Icon(Icons.school, color: Colors.black45),
          controller: gradeController,
          focusNode: schoolNameFocusNode,
          hintText: 'Okul Adı Giriniz',
        ),
        const SizedBox(height: 16),
        BlocBuilder<QuestionnaireViewModel, QuestionnaireState>(
          builder: (context, state) {
            return TurkishCitiesDropdownNoKeyboard(
              value: state.selectedCity,
              onChanged: (city) => viewModel.changeCity(city: city!),
            );
          },
        ),
        const SizedBox(height: 16),
        BlocBuilder<QuestionnaireViewModel, QuestionnaireState>(
          builder: (context, state) {
            return SchoolGradesDropdownNoKeyboard(
              value: state.selectedGrade,
              onChanged: (grade) => viewModel.changeGrade(grade: grade!),
            );
          },
        ),
        const SizedBox(height: 30),
        ProductButtonPresets.greenBlue(
          onPressed: _handleSubmit,
          text: 'İlerle',
        ),
      ],
    );
  }
}
