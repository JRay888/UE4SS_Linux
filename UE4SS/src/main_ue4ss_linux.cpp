#include <dlfcn.h>
#include <pthread.h>
#include <cstdio>
#include <cstring>
#include <iostream>
#include <memory>
#include <unistd.h>

#include "UE4SSProgram.hpp"
#include <DynamicOutput/DynamicOutput.hpp>
#include <Helpers/String.hpp>

using namespace RC;

static UE4SSProgram* g_program = nullptr;

// Thread function to start UE4SS
void* thread_so_start(void* arg)
{
    auto* program = static_cast<UE4SSProgram*>(arg);
    
    // Initialize the program
    program->init();

    if (auto e = program->get_error_object(); e->has_error())
    {
        // If the output system errored out then use printf as a fallback
        if (!Output::has_internal_error())
        {
            Output::send<LogLevel::Error>(STR("Fatal Error: {}\n"), to_wstring(e->get_message()));
        }
        else
        {
            printf("Error: %s\n", e->get_message());
        }
    }

    return nullptr;
}

// Get the path of the current shared object
static std::string get_so_path()
{
    Dl_info dl_info;
    if (dladdr((void*)get_so_path, &dl_info))
    {
        return dl_info.dli_fname;
    }
    return "";
}

// Constructor function - called when the .so is loaded
__attribute__((constructor))
static void on_load()
{
    // Get the path of this .so file
    std::string so_path = get_so_path();
    
    // Convert to wstring for UE4SSProgram
    std::wstring wso_path;
    wso_path.resize(so_path.size());
    mbstowcs(&wso_path[0], so_path.c_str(), so_path.size());
    
    // Create the program instance
    g_program = new UE4SSProgram(wso_path, {});
    
    // Create a detached thread to run the initialization
    pthread_t thread;
    pthread_attr_t attr;
    pthread_attr_init(&attr);
    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
    
    if (pthread_create(&thread, &attr, thread_so_start, g_program) != 0)
    {
        fprintf(stderr, "Failed to create initialization thread\n");
        delete g_program;
        g_program = nullptr;
    }
    
    pthread_attr_destroy(&attr);
}

// Destructor function - called when the .so is unloaded
__attribute__((destructor))
static void on_unload()
{
    if (g_program)
    {
        UE4SSProgram::static_cleanup();
        // Note: We don't delete g_program here as the thread might still be using it
        // In a real implementation, you'd want proper thread synchronization
    }
}
