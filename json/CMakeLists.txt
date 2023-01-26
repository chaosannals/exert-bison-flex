cmake_minimum_required(VERSION 3.20)

set(CMAKE_C_STANDARD_REQUIRED 11)
set(CMAKE_C_STANDARD 11)

set(OUT_DIR "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CONFIGURATION_TYPES}")
set(BISON_FLEX_OUT_DIR "${OUT_DIR}/bf")

if(NOT EXISTS "${OUT_DIR}")
    file(MAKE_DIRECTORY "${OUT_DIR}")
endif()
if(EXISTS "${BISON_FLEX_OUT_DIR}")
    file(REMOVE_RECURSE "${BISON_FLEX_OUT_DIR}")
endif()


project(json)

set(BISON_FLEX_DIR "${PROJECT_SOURCE_DIR}/bf")
file(COPY "${BISON_FLEX_DIR}" DESTINATION "${OUT_DIR}")

add_custom_target(
    flex_make
    ALL
    COMMAND rm -rf bf
    COMMAND cp -r "${BISON_FLEX_DIR}" "${OUT_DIR}/bf"
    COMMAND cp -f "${PROJECT_SOURCE_DIR}/json.h" "${OUT_DIR}"
    COMMAND flex -o json.lex.c bf/json.l
    COMMENT "flex make."
    DEPENDS bf/json.l
)
add_custom_target(
    bison_make
    ALL
    COMMAND bison -d bf/json.y
    COMMENT "bison make"
    DEPENDS bf/json.y
)

add_executable(json)
add_dependencies(json flex_make)
add_dependencies(json bison_make)
target_sources(
    json
    PRIVATE
    "main.c"
    "json.c"
    "${OUT_DIR}/json.lex.c"
    "${OUT_DIR}/json.tab.h"
    "${OUT_DIR}/json.tab.c"
)