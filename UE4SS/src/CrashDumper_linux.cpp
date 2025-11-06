#include <CrashDumper.hpp>

#include <chrono>
#include <string>
#include <format>
#include <filesystem>
#include <csignal>
#include <cstdio>
#include <cstdlib>
#include <execinfo.h>
#include <unistd.h>

namespace fs = std::filesystem;

using std::chrono::seconds;
using std::chrono::system_clock;
using std::chrono::time_point_cast;

namespace RC
{
    static bool FullMemoryDump = false;
    static void (*PreviousHandlers[6])(int) = {nullptr};

    static void SignalHandler(int signum)
    {
        const auto now = time_point_cast<seconds>(system_clock::now());
        const std::string crash_log_path = (fs::current_path() / std::format("crash_{:%Y_%m_%d_%H_%M_%S}.log", now)).string();
        
        FILE* crash_file = fopen(crash_log_path.c_str(), "w");
        if (!crash_file)
        {
            fprintf(stderr, "Failed to create crash log file\n");
            exit(1);
        }
        
        // Write signal information
        fprintf(crash_file, "Signal %d received\n", signum);
        fprintf(crash_file, "Backtrace:\n");
        
        // Get backtrace
        void* array[50];
        int size = backtrace(array, 50);
        char** strings = backtrace_symbols(array, size);
        
        if (strings)
        {
            for (int i = 0; i < size; i++)
            {
                fprintf(crash_file, "%s\n", strings[i]);
            }
            free(strings);
        }
        
        fclose(crash_file);
        
        fprintf(stderr, "Crash log written to: %s\n", crash_log_path.c_str());
        
        // Re-raise the signal with default handler
        signal(signum, SIG_DFL);
        raise(signum);
    }

    CrashDumper::CrashDumper()
    {
    }

    CrashDumper::~CrashDumper()
    {
        if (enabled)
        {
            // Restore previous handlers
            signal(SIGSEGV, PreviousHandlers[0]);
            signal(SIGABRT, PreviousHandlers[1]);
            signal(SIGFPE, PreviousHandlers[2]);
            signal(SIGILL, PreviousHandlers[3]);
            signal(SIGBUS, PreviousHandlers[4]);
            signal(SIGTRAP, PreviousHandlers[5]);
        }
    }

    void CrashDumper::enable()
    {
        // Install signal handlers for common crash signals
        PreviousHandlers[0] = signal(SIGSEGV, SignalHandler); // Segmentation fault
        PreviousHandlers[1] = signal(SIGABRT, SignalHandler); // Abort
        PreviousHandlers[2] = signal(SIGFPE, SignalHandler);  // Floating point exception
        PreviousHandlers[3] = signal(SIGILL, SignalHandler);  // Illegal instruction
        PreviousHandlers[4] = signal(SIGBUS, SignalHandler);  // Bus error
        PreviousHandlers[5] = signal(SIGTRAP, SignalHandler); // Trap
        
        this->enabled = true;
    }

    void CrashDumper::set_full_memory_dump(bool enabled)
    {
        FullMemoryDump = enabled;
    }

} // namespace RC
