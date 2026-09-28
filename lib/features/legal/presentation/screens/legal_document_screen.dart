import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/error_view.dart';
import '../cubit/legal_document_cubit.dart';
import '../cubit/legal_document_state.dart';

/// Renders any one of the legal documents — Privacy Policy, Terms of
/// Service, Anti-Spam Policy — from the same backend endpoint, switched by
/// [type] (see LegalDocumentType). [title] is purely local, just what the
/// app bar shows.
class LegalDocumentScreen extends StatelessWidget {
  final String title;
  final String type;

  const LegalDocumentScreen({super.key, required this.title, required this.type});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LegalDocumentCubit>()..load(type),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: BlocBuilder<LegalDocumentCubit, LegalDocumentState>(
            builder: (context, state) {
              if (state.status == LegalDocumentStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == LegalDocumentStatus.error) {
                return ErrorView(
                  message: state.errorMessage ?? 'Could not load this page',
                  onRetry: () => context.read<LegalDocumentCubit>().load(type),
                );
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: SelectableText(
                  state.content,
                  style: AppTextStyles.bodyLarge.copyWith(height: 1.6),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
