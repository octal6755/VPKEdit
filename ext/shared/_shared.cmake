# sourcepp
set(SOURCEPP_LIBS_START_ENABLED OFF CACHE INTERNAL "" FORCE)
set(SOURCEPP_USE_BSPPP          ON  CACHE INTERNAL "" FORCE)
set(SOURCEPP_USE_DMXPP          ON  CACHE INTERNAL "" FORCE)
set(SOURCEPP_USE_KVPP           ON  CACHE INTERNAL "" FORCE)
set(SOURCEPP_USE_MDLPP          ON  CACHE INTERNAL "" FORCE)
set(SOURCEPP_USE_STEAMPP        ON  CACHE INTERNAL "" FORCE)
set(SOURCEPP_USE_VCRYPTPP       ON  CACHE INTERNAL "" FORCE)
set(SOURCEPP_USE_VPKPP          ON  CACHE INTERNAL "" FORCE)
set(SOURCEPP_USE_VTFPP          ON  CACHE INTERNAL "" FORCE)
add_subdirectory("${CMAKE_CURRENT_LIST_DIR}/sourcepp")

# LibTomMath's platform RNG dispatcher intentionally references several
# platform-specific readers from compile-time-dead branches and relies on the
# compiler to remove those branches. MSVC leaves those references in place when
# optimization is disabled, which can happen for transitive/submodule targets in
# GitHub Actions and causes unresolved symbols such as s_read_getrandom,
# s_read_arc4random, and s_read_urandom while linking tommath.lib. Force a small
# amount of optimization for the vendored tommath target on MSVC so dead code is
# eliminated without affecting other dependencies.
if(MSVC)
    foreach(LIBTOMMATH_TARGET libtommath tommath)
        if(TARGET ${LIBTOMMATH_TARGET})
            target_compile_options(${LIBTOMMATH_TARGET} PRIVATE /O1)
        endif()
    endforeach()
endif()
