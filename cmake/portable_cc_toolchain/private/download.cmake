include(FetchContent)
include("${CMAKE_CURRENT_LIST_DIR}/assets.cmake")

function(find_root_binary_dir root_binary_dir)
  set(current_dir "${CMAKE_BINARY_DIR}")

  while(1)
    if(EXISTS "${current_dir}/_portable_cc_toolchain")
      set("${root_binary_dir}" "${current_dir}" PARENT_SCOPE)
      return()
    endif()

    get_filename_component(parent_dir "${current_dir}" DIRECTORY)
    if("${parent_dir}" STREQUAL "${current_dir}")
      # We are the root project, or it simply couldn't find the directory
      set("${root_binary_dir}" "${CMAKE_BINARY_DIR}" PARENT_SCOPE)
      return()
    endif()
    set(current_dir "${parent_dir}")
  endwhile()
endfunction()

find_root_binary_dir(_root_binary_dir)

function(download location asset variable)
    set(_url "${_ASSET_URL_${asset}}")
    set(_sha "${_ASSET_SHA256_${asset}}")
    set(_out "${_root_binary_dir}/_portable_cc_toolchain/${asset}")

    if(DEFINED ${variable})
        set(_override ${${variable}})
    elseif(DEFINED ENV{${variable}})
        set(_override $ENV{${variable}})
    endif()

    set(DOWNLOAD_ARGS)
	if (CMAKE_VERSION VERSION_GREATER_EQUAL "3.24.0")
        set(DOWNLOAD_ARGS DOWNLOAD_EXTRACT_TIMESTAMP OFF)
	endif()

    if(DEFINED _override)
        execute_process(
            COMMAND ${CMAKE_COMMAND} -E tar xvf "${_override}"
            WORKING_DIRECTORY "${_out}"
            OUTPUT_QUIET
            RESULT_VARIABLE _status
        )
        if(NOT _status EQUAL 0)
            message(FATAL_ERROR "Could not extract ${_override}")
        endif()
    else()
        FetchContent_Declare(
            ${asset}
            URL "${_url}"
            URL_HASH "SHA256=${_sha}"
            SOURCE_DIR "${_out}"
            ${DOWNLOAD_ARGS}
        )
        FetchContent_MakeAvailable(${asset})
    endif()

    set("${location}" "${_out}" PARENT_SCOPE)
endfunction()
