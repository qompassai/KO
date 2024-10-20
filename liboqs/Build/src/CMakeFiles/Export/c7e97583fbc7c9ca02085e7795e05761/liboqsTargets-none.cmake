#----------------------------------------------------------------
# Generated CMake target import file for configuration "None".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "OQS::oqs" for configuration "None"
set_property(TARGET OQS::oqs APPEND PROPERTY IMPORTED_CONFIGURATIONS NONE)
set_target_properties(OQS::oqs PROPERTIES
  IMPORTED_LOCATION_NONE "${_IMPORT_PREFIX}/lib/liboqs.so.0.11.1-dev"
  IMPORTED_SONAME_NONE "liboqs.so.6"
  )

list(APPEND _cmake_import_check_targets OQS::oqs )
list(APPEND _cmake_import_check_files_for_OQS::oqs "${_IMPORT_PREFIX}/lib/liboqs.so.0.11.1-dev" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
