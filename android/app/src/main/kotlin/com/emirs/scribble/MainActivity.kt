package com.emirs.scribble

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    private val channel = "widgets.emirs.scribble"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            if (call.method == "getWidgetStatus") {
                val status = getWidgetStatus()

                result.success(status)
            }
        }
    }

    private fun getWidgetStatus(): Boolean {
        val appWidgetManager = AppWidgetManager.getInstance(context)
        val appWidgetIds = appWidgetManager.getAppWidgetIds(
            ComponentName(
                context,
                HomeWidgetProvider::class.java
            )
        )
        return appWidgetIds.isNotEmpty()
    }
}
