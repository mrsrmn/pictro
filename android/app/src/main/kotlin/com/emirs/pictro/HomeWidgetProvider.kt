package com.emirs.pictro

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

                val scribbUrl: String? = "https://firebasestorage.googleapis.com/v0/b/scribble-98cba.appspot.com/o/images%2F%2B905323314939%2F1694010626416.png?alt=media&token=94f81179-f039-4e40-a4ba-d7a7d51d2792"

                Thread {
                    val views = this
                    val bitmap: Bitmap = Picasso.get().load(scribbUrl).resize(
                        500, 500
                    ).get()

                    views.setViewVisibility(R.id.scribb_view, View.VISIBLE)
                    views.setViewVisibility(R.id.default_text, View.GONE)
                    views.setImageViewBitmap(R.id.scribb_view, bitmap)

                    appWidgetManager.updateAppWidget(widgetId, views)
                    bitmap.recycle()
                }.start()

                /*
                if (scribbUrl == null) {
                    setViewVisibility(R.id.default_text, View.VISIBLE)
                    setViewVisibility(R.id.scribb_view, View.GONE)
                    setTextViewText(R.id.default_text, "Nothing yet!")
                } else {
                    Thread {
                        val views = this
                        val bitmap: Bitmap = Picasso.get().load(scribbUrl).resize(
                        500, 500
                        ).get()

                        views.setViewVisibility(R.id.scribb_view, View.VISIBLE)
                        views.setViewVisibility(R.id.default_text, View.GONE)
                        views.setImageViewBitmap(R.id.scribb_view, bitmap)

                        appWidgetManager.updateAppWidget(widgetId, views)
                        bitmap.recycle()
                    }.start()
                }
                 */
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}