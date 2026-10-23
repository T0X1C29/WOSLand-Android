# Architecture support policy

ARM64/aarch64 is the first supported target because the verified ONNX Runtime,
OpenCV, NumPy, and related wheels were tested there on Debian ARM64. ARMv7 and
x86_64 are detection targets only until a complete dependency and OCR test is
performed on each platform. The installer stops rather than substituting an
incomplete dependency set.

Root is not required for ordinary Debian/Termux operations when file ownership
allows them. Root may be needed for a particular device's process supervision,
but the toolkit never changes boot partitions, SELinux policy, root-manager
settings, or Android system partitions.

