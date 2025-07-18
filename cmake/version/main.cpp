#include <features.h>
#include <iostream>
#include <linux/version.h>
#include <sstream>

std::string pad(std::string s) {
  if (s.length() < 10)
    return s + std::string(10 - s.length(), ' ');
  return s;
}

std::string format_version(int major, int minor, int patch = -1) {
  std::ostringstream os;
  os << major << "." << minor;
  if (patch != -1)
    os << "." << patch;
  return pad(os.str());
}

int main() {
  std::cout << "| Component            | Version   |" << std::endl;
  std::cout << "| -------------------- | --------- |" << std::endl;
  std::cout << "| LLVM (clang)         | "
            << format_version(__clang_major__, __clang_minor__,
                              __clang_patchlevel__)
            << "|" << std::endl;
  std::cout << "| libstdc++            | "
            << format_version(_GLIBCXX_RELEASE, __GNUC_MINOR__,
                              __GNUC_PATCHLEVEL__)
            << "|" << std::endl;
  std::cout << "| glibc                | "
            << format_version(__GLIBC__, __GLIBC_MINOR__) << "|" << std::endl;
  std::cout << "| Linux kernel headers | "
            << format_version(LINUX_VERSION_CODE >> 16,
                              (LINUX_VERSION_CODE >> 8) & 0xFF,
                              LINUX_VERSION_CODE & 0xFF)
            << "|" << std::endl;
}
