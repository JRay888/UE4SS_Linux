#pragma once

#include <cstdio>
#include <File/Common.hpp>
#include <File/HandleTemplate.hpp>

namespace RC::File
{
    using Handle = HandleTemplate<FILE*>;
} // namespace RC::File
