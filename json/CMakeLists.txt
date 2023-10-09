cmake_minimum_required(VERSION 3.20)

set(CMAKE_C_STANDARD_REQUIRED 11)
set(CMAKE_C_STANDARD 11)

# Windows 下：
# 可以通过 CMAKE 定制下载 bison 和 flex 的二进制程序（参见 trial-cpp 里的 gnuwin32 示例）
# cmake 文件夹内有部分来自 trial-cpp 里的 gnuwin32 示例的脚本。（但是本示例没有使用）
# 本实例不使用 CMAKE 自动下载，而是通过手动下载 GNUWIN32 并配置 PATH 。所以假定和 Linux 一样命令行直接就有  bison 和 flex 命令。
# bison 目录必须在  bin 下 且兄弟目录有 share 提供数个 *.m4 脚本。

set(OUT_DIR "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_BUILD_TYPE}")
message(STATUS "out dir: ${OUT_DIR}")

if(NOT EXISTS "${OUT_DIR}")
    file(MAKE_DIRECTORY "${OUT_DIR}")
endif()

message(STATUS "PATH: $ENV{PATH}")


project(json)

set(BISON_FLEX_DIR "${PROJECT_SOURCE_DIR}/bf")
message(STATUS "bison & flex src dir: ${BISON_FLEX_DIR}")

add_custom_target(flex_and_bison_gencode)

# flex
add_custom_command(
    TARGET flex_and_bison_gencode
    PRE_BUILD
    WORKING_DIRECTORY ${BISON_FLEX_DIR}
    BYPRODUCTS "${OUT_DIR}/json.lex.c"
    DEPENDS "${BISON_FLEX_DIR}/json.l"
    COMMENT "flex gencode."
    # flex -o[output] 的参数必须紧贴着 -o 后面，参见 flex --help
    COMMAND flex "-o${OUT_DIR}/json.lex.c" "${BISON_FLEX_DIR}/json.l"
)

# bison
add_custom_command(
    TARGET flex_and_bison_gencode
    PRE_BUILD
    WORKING_DIRECTORY ${BISON_FLEX_DIR}
    BYPRODUCTS "${OUT_DIR}/json.tab.h" "${OUT_DIR}/json.tab.c"
    DEPENDS "${BISON_FLEX_DIR}/json.y"
    COMMENT "bison gencode."
    # -b 是前缀，包括了文件名的前半部分，所以 json.tab.c json.tab.h 就需要下面那样配置路径后加上 json 名。
    COMMAND bison -b "${OUT_DIR}/json" -d "${BISON_FLEX_DIR}/json.y"
)

add_executable(json)
add_dependencies(json flex_and_bison_gencode)
target_include_directories(
    json
    PRIVATE
    ${PROJECT_SOURCE_DIR}
    ${OUT_DIR}
)
target_sources(
    json
    PRIVATE
    "main.c"
    "json.c"
    "${OUT_DIR}/json.lex.c"
    "${OUT_DIR}/json.tab.c"
)
