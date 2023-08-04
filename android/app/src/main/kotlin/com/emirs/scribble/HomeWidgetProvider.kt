package com.emirs.scribble

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.view.View
import android.widget.RemoteViews
import com.squareup.picasso.Picasso
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider


class HomeWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.home_widget_layout).apply {
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_container, pendingIntent)

                val scribbUrl: String? = widgetData.getString("scribb_url", null)

                if (scribbUrl == null) {
                    setViewVisibility(R.id.default_text, View.VISIBLE)
                    setViewVisibility(R.id.scribb_view, View.INVISIBLE)
                    setTextViewText(R.id.default_text, "Nothing yet!")
                } else {
                    Thread {
                        val views = this
                        val bitmap: Bitmap = Picasso.get().load(scribbUrl).get()

                        views.setViewVisibility(R.id.scribb_view, View.VISIBLE)
                        views.setViewVisibility(R.id.default_text, View.INVISIBLE)
                        views.setImageViewBitmap(R.id.scribb_view, bitmap)

                        appWidgetManager.updateAppWidget(widgetId, views)
                    }.start()
                }
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}