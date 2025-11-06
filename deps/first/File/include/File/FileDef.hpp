#pragma once

namespace RC::File
{
#ifndef RC_DETECTED_OS
#ifdef _WIN32
#define RC_DETECTED_OS _WIN32
#elif defined(__linux__)
#define RC_DETECTED_OS __linux__
#else
    static_assert(false, "Could not setup the 'Handle' typedef because a supported OS was not detected.");
#endif
#endif

#if RC_DETECTED_OS == _WIN32
#ifndef RC_OS_FILE_TYPE_INCLUDE_FILE
#define RC_OS_FILE_TYPE_INCLUDE_FILE <File/FileType/WinFile.hpp>
#endif
#elif RC_DETECTED_OS == __linux__
#ifndef RC_OS_FILE_TYPE_INCLUDE_FILE
#define RC_OS_FILE_TYPE_INCLUDE_FILE <File/FileType/LinuxFile.hpp>
#endif
#else
    static_assert(false, "Could not setup the 'RC_OS_FILE_TYPE_INCLUDE_FILE' macro because a supported OS was not detected.");
#endif

} // namespace RC::File
