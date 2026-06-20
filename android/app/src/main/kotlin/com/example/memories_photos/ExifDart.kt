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

    public fun getUsefulExif(path: String): HashMap<String, String> {
        val result = HashMap<String, String>()
        val exif = EX(path)

        val flash = exif.getAttribute(EX.TAG_FLASH)!!
        var flashText = ""
        when (flash) {
            "${EX.FLAG_FLASH_MODE_AUTO}" -> flashText = "Flash used (auto)"
            "${EX.FLAG_FLASH_FIRED}" -> flashText = "Flash used"
        }
        val sceneCaptureType = exif.getAttribute(EX.TAG_SCENE_CAPTURE_TYPE)!!
        var sceneCaptureTypeText = ""
        when (sceneCaptureType) {
            "${EX.SCENE_CAPTURE_TYPE_STANDARD}" -> sceneCaptureTypeText = ""
            "${EX.SCENE_CAPTURE_TYPE_LANDSCAPE}" -> sceneCaptureTypeText = "Landscape"
            "${EX.SCENE_CAPTURE_TYPE_PORTRAIT}" -> sceneCaptureTypeText = "Portrait"
            "${EX.SCENE_CAPTURE_TYPE_NIGHT}" -> sceneCaptureTypeText = "Night"
        }
        val meteringMode = exif.getAttribute(EX.TAG_METERING_MODE)!!
        var meteringModeText = ""
        when (meteringMode) {
            "${EX.METERING_MODE_UNKNOWN}" -> meteringModeText = "Unknown"
            "${EX.METERING_MODE_AVERAGE}" -> meteringModeText = "Average"
            "${EX.METERING_MODE_CENTER_WEIGHT_AVERAGE}" -> meteringModeText = "Center weight average"
            "${EX.METERING_MODE_SPOT}" -> meteringModeText = "Spot"
            "${EX.METERING_MODE_MULTI_SPOT}" -> meteringModeText = "Multi spot"
            "${EX.METERING_MODE_PATTERN}" -> meteringModeText = "Pattern"
            "${EX.METERING_MODE_PARTIAL}" -> meteringModeText = "Partial"
            "${EX.METERING_MODE_OTHER}" -> meteringModeText = "Other"
        }

        result[EX.TAG_DATETIME_ORIGINAL] = exif.getAttribute(EX.TAG_DATETIME_ORIGINAL)!!
        result[EX.TAG_OFFSET_TIME_ORIGINAL] = exif.getAttribute(EX.TAG_OFFSET_TIME_ORIGINAL)!!

        result[EX.TAG_MAKE] = exif.getAttribute(EX.TAG_MAKE)!!
        result[EX.TAG_MODEL] = exif.getAttribute(EX.TAG_MODEL)!!
        result[EX.TAG_SOFTWARE] = exif.getAttribute(EX.TAG_SOFTWARE)!!

        result[EX.TAG_PIXEL_X_DIMENSION] = exif.getAttribute(EX.TAG_PIXEL_X_DIMENSION)!!
        result[EX.TAG_PIXEL_Y_DIMENSION] = exif.getAttribute(EX.TAG_PIXEL_Y_DIMENSION)!!

        result[EX.TAG_PHOTOGRAPHIC_SENSITIVITY] = exif.getAttribute(EX.TAG_PHOTOGRAPHIC_SENSITIVITY)!!
        result[EX.TAG_F_NUMBER] = exif.getAttribute(EX.TAG_F_NUMBER)!!
        result[EX.TAG_SHUTTER_SPEED_VALUE] = exif.getAttribute(EX.TAG_SHUTTER_SPEED_VALUE)!!
        result[EX.TAG_FOCAL_LENGTH_IN_35MM_FILM] = exif.getAttribute(EX.TAG_FOCAL_LENGTH_IN_35MM_FILM)!!
        result[EX.TAG_EXPOSURE_BIAS_VALUE] = exif.getAttribute(EX.TAG_EXPOSURE_BIAS_VALUE)!!

        result[EX.TAG_SCENE_CAPTURE_TYPE] = sceneCaptureTypeText
        result[EX.TAG_FLASH] = flashText;
        result[EX.TAG_DIGITAL_ZOOM_RATIO] = exif.getAttribute(EX.TAG_DIGITAL_ZOOM_RATIO)!!
        result[EX.TAG_APERTURE_VALUE] = exif.getAttribute(EX.TAG_APERTURE_VALUE)!!
        result[EX.TAG_MAX_APERTURE_VALUE] = exif.getAttribute(EX.TAG_MAX_APERTURE_VALUE)!!

        result[EX.TAG_EXPOSURE_TIME] = exif.getAttribute(EX.TAG_EXPOSURE_TIME)!!
        result[EX.TAG_EXPOSURE_PROGRAM] = exif.getAttribute(EX.TAG_EXPOSURE_PROGRAM)!! //TODO: make it like flash tag

        result[EX.TAG_METERING_MODE] = meteringModeText
        result[EX.TAG_IMAGE_UNIQUE_ID] = exif.getAttribute(EX.TAG_IMAGE_UNIQUE_ID)!! //TODO: make it like flash tag

        result[EX.TAG_GPS_ALTITUDE] = exif.getAttribute(EX.TAG_GPS_ALTITUDE)!!
        result[EX.TAG_GPS_LATITUDE] = exif.getAttribute(EX.TAG_GPS_LATITUDE)!!
        result[EX.TAG_GPS_LONGITUDE] = exif.getAttribute(EX.TAG_GPS_LONGITUDE)!!
        result[EX.TAG_GPS_LATITUDE_REF] = exif.getAttribute(EX.TAG_GPS_LATITUDE_REF)!!
        result[EX.TAG_GPS_LONGITUDE_REF] = exif.getAttribute(EX.TAG_GPS_LONGITUDE_REF)!!

        return result;
    }

}








