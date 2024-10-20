set(CMAKE_C_COMPILER "/usr/bin/clang")
set(CMAKE_C_COMPILER_ARG1 "")
set(CMAKE_C_COMPILER_ID "Clang")
set(CMAKE_C_COMPILER_VERSION "18.1.8")
set(CMAKE_C_COMPILER_VERSION_INTERNAL "")
set(CMAKE_C_COMPILER_WRAPPER "")
set(CMAKE_C_STANDARD_COMPUTED_DEFAULT "11")
set(CMAKE_C_EXTENSIONS_COMPUTED_DEFAULT "ON")
set(CMAKE_C_STANDARD_LATEST "23")
set(CMAKE_C_COMPILE_FEATURES "c_std_90;c_function_prototypes;c_std_99;c_restrict;c_variadic_macros;c_std_11;c_static_assert;c_std_17;c_std_23")
set(CMAKE_C90_COMPILE_FEATURES "c_std_90;c_function_prototypes")
set(CMAKE_C99_COMPILE_FEATURES "c_std_99;c_restrict;c_variadic_macros")
set(CMAKE_C11_COMPILE_FEATURES "c_std_11;c_static_assert")
set(CMAKE_C17_COMPILE_FEATURES "c_std_17")
set(CMAKE_C23_COMPILE_FEATURES "c_std_23")

set(CMAKE_C_PLATFORM_ID "Linux")
set(CMAKE_C_SIMULATE_ID "")
set(CMAKE_C_COMPILER_FRONTEND_VARIANT "GNU")
set(CMAKE_C_SIMULATE_VERSION "")




set(CMAKE_AR "/usr/bin/llvm-ar")
set(CMAKE_C_COMPILER_AR "/usr/bin/llvm-ar")
set(CMAKE_RANLIB "/usr/bin/llvm-ranlib")
set(CMAKE_C_COMPILER_RANLIB "/usr/bin/llvm-ranlib")
set(CMAKE_LINKER "/usr/bin/ld.lld")
set(CMAKE_LINKER_LINK "")
set(CMAKE_LINKER_LLD "")
set(CMAKE_C_COMPILER_LINKER "/usr/bin/ld")
set(CMAKE_C_COMPILER_LINKER_ID "GNU")
set(CMAKE_C_COMPILER_LINKER_VERSION 2.43.0)
set(CMAKE_C_COMPILER_LINKER_FRONTEND_VARIANT GNU)
set(CMAKE_MT "")
set(CMAKE_TAPI "CMAKE_TAPI-NOTFOUND")
set(CMAKE_COMPILER_IS_GNUCC )
set(CMAKE_C_COMPILER_LOADED 1)
set(CMAKE_C_COMPILER_WORKS TRUE)
set(CMAKE_C_ABI_COMPILED TRUE)

set(CMAKE_C_COMPILER_ENV_VAR "CC")

set(CMAKE_C_COMPILER_ID_RUN 1)
set(CMAKE_C_SOURCE_FILE_EXTENSIONS c;m)
set(CMAKE_C_IGNORE_EXTENSIONS h;H;o;O;obj;OBJ;def;DEF;rc;RC)
set(CMAKE_C_LINKER_PREFERENCE 10)
set(CMAKE_C_LINKER_DEPFILE_SUPPORTED FALSE)

# Save compiler ABI information.
set(CMAKE_C_SIZEOF_DATA_PTR "8")
set(CMAKE_C_COMPILER_ABI "ELF")
set(CMAKE_C_BYTE_ORDER "LITTLE_ENDIAN")
set(CMAKE_C_LIBRARY_ARCHITECTURE "x86_64-linux-gnu")

if(CMAKE_C_SIZEOF_DATA_PTR)
  set(CMAKE_SIZEOF_VOID_P "${CMAKE_C_SIZEOF_DATA_PTR}")
endif()

if(CMAKE_C_COMPILER_ABI)
  set(CMAKE_INTERNAL_PLATFORM_ABI "${CMAKE_C_COMPILER_ABI}")
endif()

if(CMAKE_C_LIBRARY_ARCHITECTURE)
  set(CMAKE_LIBRARY_ARCHITECTURE "x86_64-linux-gnu")
endif()

set(CMAKE_C_CL_SHOWINCLUDES_PREFIX "")
if(CMAKE_C_CL_SHOWINCLUDES_PREFIX)
  set(CMAKE_CL_SHOWINCLUDES_PREFIX "${CMAKE_C_CL_SHOWINCLUDES_PREFIX}")
endif()





set(CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES "/usr/lib/gcc/x86_64-pc-linux-gnu/14.2.1/include;/opt/libtorch/include;/opt/libtorch/include/torch/csrc/api/include;/home/phaedrus/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/include;/home/phaedrus/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library;/usr/include/ruby-3.2.0;/usr/include/php/ext/date/lib;/usr/include/php/ext;/usr/include/php/Zend;/usr/include/php/TSRM;/usr/include/php/main;/usr/include/php;/opt/openresty/luajit/include;/usr/include/lua5.1;/usr/include/node;/usr/lib/jvm/default/include;/usr/include/ghc;/usr/include/openssl;/usr/lib/gcc/x86_64-pc-linux-gnu/14.2.1/include-fixed;/usr/include/c++/14.2.1/x86_64-pc-linux-gnu;/usr/include/c++/14.2.1;/opt/intel/oneapi/mkl/2024.1/include;/opt/intel/oneapi/tbb/2021.12/include;/opt/intel/oneapi/mpi/2021.12/include;/opt/intel/oneapi/ippcp/2021.11/include;/opt/intel/oneapi/ipp/2021.11/include;/opt/intel/oneapi/dpl/2022.5/include;/opt/intel/oneapi/dpcpp-ct/2024.1/include;/opt/intel/oneapi/dnnl/2024.1/include;/opt/intel/oneapi/dev-utilities/2024.1/include;/opt/intel/oneapi/dal/2024.2/include/dal;/opt/intel/oneapi/compiler/2024.1/opt/oclfpga/include;/opt/intel/oneapi/ccl/2021.12/include;/usr/include/python3.12;/usr/lib/go/pkg/include;/usr/lib/clang/18/include;/usr/local/include;/usr/include")
set(CMAKE_C_IMPLICIT_LINK_LIBRARIES "omp;gcc;gcc_s;pthread;c;gcc;gcc_s")
set(CMAKE_C_IMPLICIT_LINK_DIRECTORIES "/usr/local/lib;/usr/lib64/gcc/x86_64-pc-linux-gnu/14.2.1;/usr/lib64;/lib/x86_64-linux-gnu;/lib64;/usr/lib/x86_64-linux-gnu;/lib;/usr/lib;/opt/libtorch/lib;/opt/intel/oneapi/mkl/2024.1/lib;/opt/intel/oneapi/tbb/2021.12/lib/intel64/gcc4.8;/opt/intel/oneapi/mpi/2021.12/lib;/opt/intel/oneapi/ippcp/2021.11/lib;/opt/intel/oneapi/ipp/2021.11/lib;/opt/intel/oneapi/dpl/2022.5/lib;/opt/intel/oneapi/dnnl/2024.1/lib;/opt/intel/oneapi/dal/2024.2/lib;/opt/intel/oneapi/compiler/2024.1/lib;/opt/intel/oneapi/ccl/2021.12/lib")
set(CMAKE_C_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "")
