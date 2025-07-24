import 'package:auto_route/auto_route.dart';
import 'package:edumind_intro_app/feature/auth/questionnaire/service/auth_api_service.dart';
import 'package:edumind_intro_app/feature/auth/questionnaire/view_model/questionnaire_state.dart';
import 'package:edumind_intro_app/feature/auth/questionnaire/view_model/questionnaire_view_model.dart';
import 'package:edumind_intro_app/product/navigation/app_router.dart';
import 'package:edumind_intro_app/product/state/base/base_state.dart';
import 'package:edumind_intro_app/product/utility/extension/product_button_extension.dart';
import 'package:edumind_intro_app/product/utility/validation/mixin/validation_mixin.dart';
import 'package:edumind_intro_app/product/widget/dropdown/school_grades_dropdown.dart';
import 'package:edumind_intro_app/product/widget/dropdown/turkish_cities_dropdown.dart';
import 'package:edumind_intro_app/product/widget/input/product_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen/gen.dart';
import 'package:uuid/uuid.dart';

part './mixin/questionnaire_view_mixin.dart';

@RoutePage()

/// [QuestionnaireView] is a view for displaying a questionnaire
class QuestionnaireView extends StatefulWidget {
  /// Creates a new instance of [QuestionnaireView]
  const QuestionnaireView({super.key});

  @override
  State<QuestionnaireView> createState() => _QuestionnaireViewState();
}

class _QuestionnaireViewState extends BaseState<QuestionnaireView>
    with ValidationMixin<QuestionnaireView>, QuestionnaireViewMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => viewModel,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context)
              .unfocus(); // Dismiss keyboard on tap outside input fields
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: LayoutBuilder(
            builder: (context, constraints) {
              final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
              final isKeyboardVisible = keyboardHeight > 0;

              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: isKeyboardVisible ? keyboardHeight + 20 : 20,
                      ),
                      child: _body(context),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
