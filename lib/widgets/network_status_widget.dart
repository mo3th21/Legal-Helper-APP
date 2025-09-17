import 'package:flutter/material.dart';
import 'package:qanon/utils/network_helper.dart';

class NetworkStatusWidget extends StatefulWidget {
  const NetworkStatusWidget({super.key});

  @override
  State<NetworkStatusWidget> createState() => _NetworkStatusWidgetState();
}

class _NetworkStatusWidgetState extends State<NetworkStatusWidget> {
  bool? _hasConnection;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    if (mounted) {
      setState(() => _isChecking = true);
    }

    try {
      final hasConnection = await NetworkHelper.hasInternetConnection();
      if (mounted) {
        setState(() {
          _hasConnection = hasConnection;
          _isChecking = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasConnection = false;
          _isChecking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'جار التحقق من الاتصال...',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      );
    }

    if (_hasConnection == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _hasConnection! ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _hasConnection! ? Colors.green.shade200 : Colors.red.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _hasConnection! ? Icons.wifi : Icons.wifi_off,
            size: 16,
            color: _hasConnection! ? Colors.green.shade600 : Colors.red.shade600,
          ),
          const SizedBox(width: 8),
          Text(
            _hasConnection! ? 'متصل بالإنترنت' : 'غير متصل بالإنترنت',
            style: TextStyle(
              fontSize: 12,
              color: _hasConnection! ? Colors.green.shade800 : Colors.red.shade800,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: _checkConnection,
            child: Icon(
              Icons.refresh,
              size: 16,
              color: _hasConnection! ? Colors.green.shade600 : Colors.red.shade600,
            ),
          ),
        ],
      ),
    );
  }
} 