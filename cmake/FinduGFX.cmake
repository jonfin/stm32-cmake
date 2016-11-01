IF(NOT uGFX_FIND_COMPONENTS) 
    SET(uGFX_FIND_COMPONENTS gos gos_chibios)
    MESSAGE(STATUS "No uGFX components specified, using default: ${uGFX_FIND_COMPONENTS}")
ENDIF()

LIST(APPEND uGFX_FIND_COMPONENTS gfx gdriver)

SET(uGFX_gfx_SEARCH_PATH ${uGFX_DIR} ${uGFX_DIR}/src)
SET(uGFX_gfx_HEADERS gfx.h)
SET(uGFX_gfx_SOURCES gfx.c)

SET(uGFX_gdriver_SEARCH_PATH ${uGFX_DIR}/src/gdriver)
SET(uGFX_gdriver_HEADERS gdriver_options.h gdriver_rules.h gdriver.h)
SET(uGFX_gdriver_SOURCES gdriver.c)

SET(uGFX_gevent_SEARCH_PATH ${uGFX_DIR}/src/gevent)
SET(uGFX_gevent_HEADERS gevent_options.h gevent_rules.h gevent.h)
SET(uGFX_gevent_SOURCES gevent.c)

SET(uGFX_gtimer_SEARCH_PATH ${uGFX_DIR}/src/gtimer)
SET(uGFX_gtimer_HEADERS gtimer_options.h gtimer_rules.h gtimer.h)
SET(uGFX_gtimer_SOURCES gtimer.c)

INCLUDE(uGFX_GOS)
INCLUDE(uGFX_GDISP)
INCLUDE(uGFX_GWIN)

SET(uGFX_COMPONENTS gfx gdriver gos ${uGFX_GOS_MODULES} gdisp ${uGFX_GDISP_MODULES} gtimer gevent ${uGFX_GWIN_MODULES})

FOREACH(comp ${uGFX_FIND_COMPONENTS})
    LIST(FIND uGFX_COMPONENTS ${comp} INDEX)
    IF(INDEX EQUAL -1)
        MESSAGE(FATAL_ERROR "Unknown uGFX component: ${comp}\nSupported uGFX components: ${uGFX_COMPONENTS}")
    ENDIF()
    IF(uGFX_${comp}_SOURCES)
        FOREACH(source ${uGFX_${comp}_SOURCES})
            FIND_FILE(uGFX_${comp}_${source} NAMES ${source}
				PATHS ${uGFX_${comp}_SEARCH_PATH}
				NO_DEFAULT_PATH CMAKE_FIND_ROOT_PATH_BOTH)
            LIST(APPEND uGFX_SOURCES ${uGFX_${comp}_${source}})
        ENDFOREACH()
    ENDIF()
	IF(uGFX_${comp}_HEADERS)
		FIND_PATH(uGFX_${comp}_INCLUDE_DIR NAMES ${uGFX_${comp}_HEADERS}
			PATHS ${uGFX_${comp}_SEARCH_PATH} NO_DEFAULT_PATH CMAKE_FIND_ROOT_PATH_BOTH)
		LIST(APPEND uGFX_INCLUDE_DIRS ${uGFX_${comp}_INCLUDE_DIR})
    ENDIF()
ENDFOREACH()
