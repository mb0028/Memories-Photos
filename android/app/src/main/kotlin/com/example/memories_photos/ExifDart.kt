package com.example.memories_photos

import androidx.exifinterface.media.ExifInterface as EX

class ExifDart {

    public fun getAttribute(path: String, att: String): String {
        val exif = EX(path)
        val result = exif.getAttribute(att)
        if (result != null)
            return result
        return ""
    }

    public fun setAttribute(path: String, att: String, value: String): Boolean {
        try {
            val exif = EX(path)
            exif.setAttribute(att, value)
            exif.saveAttributes()
            return true
        } catch (e: Exception) {
            return false
        }
    }

}








