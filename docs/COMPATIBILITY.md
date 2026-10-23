# Compatibility

These results are from one Motorola Moto G 5G (2025), Android 16, ARM64,
Termux, and Debian 13 ARM64 under proot.

| Item | Tested result |
|---|---|
| Python | CPython 3.13 |
| Python ABI | cp313 |
| Linux wheels | manylinux2014/2.17 ARM64 |
| ONNX Runtime | 1.31.0 imports and initializes |
| RapidOCR | 3.8.4 models load; inference completed |
| NumPy | 2.5.4 |
| OpenCV | 5.0.0.93 |
| Pillow | 13.0.0 |
| Matplotlib | 3.11.2 |
| Bot | v2.1.3, 30/30 modules loaded |

This is not a guarantee for other phones, Android releases, containers, or
Python ABIs. A second-phone installation has not been tested.

