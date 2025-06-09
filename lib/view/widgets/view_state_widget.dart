import 'package:flutter/material.dart';
import '../../viewmodel/base_viewmodel.dart';

class ViewStateWidget extends StatelessWidget {
  final BaseViewModel viewModel;
  final Widget child;
  final String? loadingMessage;
  final Widget? customLoadingWidget;
  final Widget? customErrorWidget;

  const ViewStateWidget({
    super.key,
    required this.viewModel,
    required this.child,
    this.loadingMessage,
    this.customLoadingWidget,
    this.customErrorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        // Mostrar loading
        if (viewModel.isLoading) {
          return customLoadingWidget ?? _buildDefaultLoading();
        }

        // Mostrar error
        if (viewModel.errorMessage != null) {
          return customErrorWidget ?? _buildDefaultError(context);
        }

        // Mostrar contenido normal
        return child;
      },
    );
  }

  Widget _buildDefaultLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (loadingMessage != null) ...[
            const SizedBox(height: 16),
            Text(loadingMessage!),
          ],
        ],
      ),
    );
  }

  Widget _buildDefaultError(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.clearError(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
