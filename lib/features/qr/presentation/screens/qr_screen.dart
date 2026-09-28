import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../domain/entities/qr_entity.dart';
import '../cubit/qr_cubit.dart';
import '../cubit/qr_state.dart';

class QrScreen extends StatelessWidget {
  const QrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QrCubit>()..load(),
      child: Builder(
        builder: (context) => AppScaffold(
          appBar: AppBar(title: const Text('QR Code')),
          body: BlocBuilder<QrCubit, QrState>(
            builder: (context, state) {
              if (state.status == QrStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == QrStatus.error && state.qrs.isEmpty) {
                return ErrorView(
                  message: state.errorMessage ?? 'Could not load the QR code',
                  onRetry: () => context.read<QrCubit>().load(),
                );
              }
              if (state.qrs.isEmpty) {
                return const EmptyState(
                  icon: Icons.qr_code_2_rounded,
                  title: 'No QR code available',
                  message: 'This store hasn\'t set up a QR code yet.',
                );
              }

              return PageView.builder(
                itemCount: state.qrs.length,
                itemBuilder: (context, index) => _QrPage(qr: state.qrs[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _QrPage extends StatefulWidget {
  final QrEntity qr;
  const _QrPage({required this.qr});

  @override
  State<_QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<_QrPage> {
  bool _sharing = false;

  Future<void> _share() async {
    setState(() => _sharing = true);
    try {
      final file = await DefaultCacheManager().getSingleFile(widget.qr.image);
      await Share.shareXFiles([XFile(file.path)]);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Could not share the QR code')));
      }
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSvg = widget.qr.image.toLowerCase().endsWith('.svg');

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SizedBox(
              width: 260,
              height: 260,
              child: isSvg
                  ? SvgPicture.network(widget.qr.image, fit: BoxFit.contain)
                  : AppNetworkImage(url: widget.qr.image, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 24),
          Text('Scan to connect', style: AppTextStyles.titleLarge),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _sharing ? null : _share,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(64),
                textStyle: AppTextStyles.titleLarge,
                side: const BorderSide(color: AppColors.primary, width: 1.6),
              ),
              icon: _sharing
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    )
                  : const Icon(Icons.ios_share_rounded, size: 26),
              label: Text(_sharing ? 'Preparing…' : 'Share / Save'),
            ),
          ),
        ],
      ),
    );
  }
}
