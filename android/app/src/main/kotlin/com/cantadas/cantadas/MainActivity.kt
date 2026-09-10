package com.cantadas.cantadas

import android.content.Intent
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val channel = "cantadas/share"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "toWhatsAppImage" -> {
                        val path = call.argument<String>("path")
                        val text = call.argument<String>("text") ?: ""
                        result.success(sendImageToWhatsApp(path, text))
                    }
                    else -> result.notImplemented()
                }
            }
    }

    /// Envia a imagem [path] direto pro WhatsApp (com legenda [text]).
    /// Retorna true se abriu; false se o WhatsApp não está instalado (aí o
    /// Flutter cai no compartilhamento padrão).
    private fun sendImageToWhatsApp(path: String?, text: String): Boolean {
        if (path == null) return false
        val file = File(path)
        if (!file.exists()) return false
        val uri = FileProvider.getUriForFile(
            this, "$packageName.fileprovider", file
        )
        for (pkg in listOf("com.whatsapp", "com.whatsapp.w4b")) {
            try {
                val intent = Intent(Intent.ACTION_SEND).apply {
                    type = "image/png"
                    putExtra(Intent.EXTRA_STREAM, uri)
                    if (text.isNotEmpty()) putExtra(Intent.EXTRA_TEXT, text)
                    setPackage(pkg)
                    addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                }
                startActivity(intent)
                return true
            } catch (_: Exception) {
                // tenta o próximo pacote
            }
        }
        return false
    }
}
