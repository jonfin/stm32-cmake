IF(STM32_CHIP_TYPE OR STM32_CHIP)
    IF(NOT STM32_CHIP_TYPE)
        STM32_GET_CHIP_TYPE(${STM32_CHIP} STM32_CHIP_TYPE)
        IF(NOT STM32_CHIP_TYPE)
            MESSAGE(FATAL_ERROR "Unknown chip: ${STM32_CHIP}. Try to use STM32_CHIP_TYPE directly.")
        ENDIF()
        MESSAGE(STATUS "${STM32_CHIP} is ${STM32_CHIP_TYPE} device")
    ENDIF()
    STRING(TOLOWER ${STM32_CHIP_TYPE} STM32_CHIP_TYPE_LOWER)
ENDIF()

IF(NOT STM32Cube_DIR)
	SET(STM32Cube_DIR "/opt/STM32Cube_FW_F1_V1.2.0")
	MESSAGE(STATUS "No STM32Cube_DIR specified, using default: " ${STM32Cube_DIR})
ENDIF()

SET(FREERTOS_HEAP_COMPONENTS heap_1 heap_2 heap_3 heap_4 heap_5)
SET(FREERTOS_REQUIRED_COMPONENTS tasks list queue)
SET(FREERTOS_COMPONENTS timers croutine event_groups)
LIST(APPEND FREERTOS_COMPONENTS ${FREERTOS_REQUIRED_COMPONENTS} ${FREERTOS_HEAP_COMPONENTS})

IF(NOT FREERTOS_FIND_COMPONENTS)
	SET(FREERTOS_FIND_COMPONENTS ${FREERTOS_REQUIRED_COMPONENTS})
	MESSAGE(STATUS "No FREERTOS components selected, using only required ones: ${FREERTOS_FIND_COMPONENTS}")
ENDIF()

LIST(APPEND FREERTOS_FIND_COMPONENTS ${FREERTOS_REQUIRED_COMPONENTS})
LIST(REMOVE_DUPLICATES FREERTOS_FIND_COMPONENTS)

FOREACH(cmp ${FREERTOS_FIND_COMPONENTS})
	LIST(FIND FREERTOS_COMPONENTS ${cmp} FREERTOS_FOUND_INDEX)
	IF(${FREERTOS_FOUND_INDEX} LESS 0)
		MESSAGE(FATAL_ERROR "Unknown FREERTOS component: ${cmp}. Available components: ${FREERTOS_COMPONENTS}")
    ENDIF()
	LIST(FIND FREERTOS_HEAP_COMPONENTS ${cmp} FREERTOS_FOUND_INDEX)
	IF(${FREERTOS_FOUND_INDEX} LESS 0)
		LIST(APPEND FREERTOS_COMMON_HEADERS ${cmp}.h)
		LIST(APPEND FREERTOS_COMMON_SOURCES ${cmp}.c)
    ELSE()
		LIST(APPEND FREERTOS_HEAP_SOURCE ${cmp}.c)
	ENDIF()
ENDFOREACH()

LIST(LENGTH FREERTOS_HEAP_SOURCE FREERTOS_LENGTH)
IF(${FREERTOS_LENGTH} LESS 1)
	MESSAGE(FATAL_ERROR "No heap for FREERTOS choosen.")
ENDIF()

IF(STM32_FAMILY STREQUAL "F1")
	SET(FREERTOS_DEVICE_SOURCES ARM_CM3)
ELSEIF(STM32_FAMILY STREQUAL "F2")
	SET(FREERTOS_DEVICE_SOURCES ARM_CM3)
ELSEIF(STM32_FAMILY STREQUAL "F4")
	SET(FREERTOS_DEVICE_SOURCES ARM_CM4F)
ELSEIF(STM32_FAMILY STREQUAL "F7")
	SET(FREERTOS_DEVICE_SOURCES ARM_CM7)
ELSEIF(STM32_FAMILY STREQUAL "F0")
	SET(FREERTOS_DEVICE_SOURCES ARM_CM0)
ELSEIF(STM32_FAMILY STREQUAL "L0")
	SET(FREERTOS_DEVICE_SOURCES ARM_CM0)
ENDIF()

FIND_PATH(FREERTOS_COMMON_INCLUDE_DIR ${FREERTOS_COMMON_HEADERS}
	HINTS ${STM32Cube_DIR}/Middlewares/Third_Party/FreeRTOS/Source/include
    CMAKE_FIND_ROOT_PATH_BOTH
)

FIND_PATH(FREERTOS_COMMON_INCLUDE_DIR2 cmsis_os.h
	HINTS ${STM32Cube_DIR}/Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS
    CMAKE_FIND_ROOT_PATH_BOTH
)

FIND_PATH(FREERTOS_DEVICE_INCLUDE_DIR portmacro.h
	HINTS ${STM32Cube_DIR}/Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/${FREERTOS_DEVICE_SOURCES}
    CMAKE_FIND_ROOT_PATH_BOTH
)

SET(FREERTOS_INCLUDE_DIRS
    ${FREERTOS_COMMON_INCLUDE_DIR}
    ${FREERTOS_COMMON_INCLUDE_DIR2}
	${FREERTOS_DEVICE_INCLUDE_DIR}
)

FIND_FILE(FREERTOS_HEAP ${FREERTOS_HEAP_SOURCE}
	HINTS ${STM32Cube_DIR}/Middlewares/Third_Party/FreeRTOS/Source/portable/MemMang/
	CMAKE_FIND_ROOT_PATH_BOTH
)
LIST(APPEND FREERTOS_SOURCES ${FREERTOS_HEAP})

FIND_FILE(FREERTOS_PORT_SOURCE port.c
	HINTS ${STM32Cube_DIR}/Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/${FREERTOS_DEVICE_SOURCES}
	CMAKE_FIND_ROOT_PATH_BOTH
)
LIST(APPEND FREERTOS_SOURCES ${FREERTOS_PORT_SOURCE})

FIND_FILE(FREERTOS_CMSIS_SOURCE cmsis_os.c
	HINTS ${STM32Cube_DIR}/Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS
	CMAKE_FIND_ROOT_PATH_BOTH
)
LIST(APPEND FREERTOS_SOURCES ${FREERTOS_CMSIS_SOURCE})

FOREACH(SRC ${FREERTOS_COMMON_SOURCES})
    SET(SRC_FILE SRC_FILE-NOTFOUND)
	FIND_FILE(SRC_FILE ${SRC}
		HINTS ${STM32Cube_DIR}/Middlewares/Third_Party/FreeRTOS/Source/
        CMAKE_FIND_ROOT_PATH_BOTH
    )
    LIST(APPEND FREERTOS_SOURCES ${SRC_FILE})
ENDFOREACH()

INCLUDE(FindPackageHandleStandardArgs)

FIND_PACKAGE_HANDLE_STANDARD_ARGS(FREERTOS DEFAULT_MSG FREERTOS_INCLUDE_DIRS FREERTOS_SOURCES)
