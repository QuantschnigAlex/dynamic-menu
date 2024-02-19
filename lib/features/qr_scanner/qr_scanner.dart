import 'package:dynamic_menu/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({super.key});

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  final _controller = MobileScannerController();

  Future<void> _signOut() async {
    final theme = Theme.of(context);
    try {
      await supabase.auth.signOut();
    } on AuthException catch (error) {
      SnackBar(
        content: Text(error.message),
        backgroundColor: theme.colorScheme.error,
      );
    } catch (error) {
      SnackBar(
        content: const Text('Unexpected error occurred'),
        backgroundColor: theme.colorScheme.error,
      );
    } finally {
      if (mounted) {
        context.pushReplacement('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR Code on the Table"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async => _signOut(),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: MobileScanner(
        scanWindow:
            Rect.fromCenter(center: Offset.zero, width: 250, height: 250),
        controller: _controller,
        onDetect: (barcodes) {
          print("Detected barcodes: $barcodes");
        },
      ),
    );
  }
}
