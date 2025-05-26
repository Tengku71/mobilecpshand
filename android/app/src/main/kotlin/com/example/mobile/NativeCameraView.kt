package com.example.mobile

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.FrameLayout
import androidx.camera.view.PreviewView

class NativeCameraView(context: Context) : FrameLayout(context) {
    val previewView: PreviewView

    init {
        val inflater = LayoutInflater.from(context)
        previewView = PreviewView(context)
        addView(previewView)
    }
}
