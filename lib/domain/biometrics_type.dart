enum BiometricsType {
  faceId('Khuôn mặt'),
  touchId('Vân tay'),
  noSupport('Không hỗ trợ'),
  noActivated('Không kích hoạt');

  final String displayName;
  const BiometricsType(this.displayName);
}
