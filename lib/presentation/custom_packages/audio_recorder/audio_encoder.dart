enum AudioEncoderType {
  /// will output to MPEG_4 format container
  AAC,
  AAC_LD,
  AAC_HE,

  /// sampling rate should be set to 8kHz.
  /// Will output to 3GP format container on Android.
  AMR_NB,

  // set to 16kHz
  AMR_WB,

  OPUS,
}
