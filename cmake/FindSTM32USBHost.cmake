IF(NOT STM32Cube_DIR)
	SET(STM32Cube_DIR "/opt/STM32Cube_FW_F1_V1.2.0")
	MESSAGE(STATUS "No STM32Cube_DIR specified, using default: " ${STM32Cube_DIR})
ENDIF()

SET(STM32USBHost_COMMON
	usbh_core
	usbh_ctlreq
	usbh_ioreq
	usbh_pipes
	)

SET(STM32USBHost_COMPONENTS
	AUDIO
	CDC
	HID
	MSC
	MTP
	)

SET(STM32USBHost_AUDIO
	usbh_audio
	)

SET(STM32USBHost_CDC
	usbh_cdc
	)

SET(STM32USBHost_HID
	usbh_hid
	usbh_hid_keybd
	usbh_hid_mouse
	usbh_hid_parser
	)

SET(STM32USBHost_MSC
	usbh_msc_bot
	usbh_msc
	usbh_msc_scsi
	)

SET(STM32USBHost_MTP
	usbh_mtp
	usbh_mtp_ptp
	)

IF(NOT STM32USBHost_FIND_COMPONENTS)
	MESSAGE(STATUS "No STM32USBHost components selected, using only main library.")
ENDIF()

FOREACH(cmp ${STM32USBHost_FIND_COMPONENTS})
	LIST(FIND STM32USBHost_COMPONENTS ${cmp} STM32USBHost_FOUND_INDEX)
	IF(${STM32USBHost_FOUND_INDEX} LESS 0)
		MESSAGE(FATAL_ERROR "Unknown STM32USBHost component: ${cmp}. Available components: ${STM32USBHost_COMPONENTS}")
	ENDIF()

	# include *.c files for the component
	FOREACH(source ${STM32USBHost_${cmp}})
		FIND_FILE(STM32USBHost_${source} ${source}.c
			HINTS ${STM32Cube_DIR}/Middlewares/ST/STM32_USB_Host_Library/Class/${cmp}/Src
			CMAKE_FIND_ROOT_PATH_BOTH
			)
		LIST(APPEND STM32USBHost_SOURCES ${STM32USBHost_${source}})

		# include include-dir for the component
		FIND_PATH(STM32USBHost_HEADER_${source} ${source}.h
			HINTS ${STM32Cube_DIR}/Middlewares/ST/STM32_USB_Host_Library/Class/${cmp}/Inc
			CMAKE_FIND_ROOT_PATH_BOTH
			)
		LIST(APPEND STM32USBHost_INCLUDE_DIRS ${STM32USBHost_HEADER_${source}})
	ENDFOREACH()
ENDFOREACH()

# include main files
FOREACH(source ${STM32USBHost_COMMON})
	# include *.c files
	FIND_FILE(STM32USBHost_${source} ${source}.c
		HINTS ${STM32Cube_DIR}/Middlewares/ST/STM32_USB_Host_Library/Core/Src
		CMAKE_FIND_ROOT_PATH_BOTH
		)
	LIST(APPEND STM32USBHost_SOURCES ${STM32USBHost_${source}})

	# include include-dir
	FIND_PATH(STM32USBHost_HEADER_${source} ${source}.h
		HINTS ${STM32Cube_DIR}/Middlewares/ST/STM32_USB_Host_Library/Core/Inc
		CMAKE_FIND_ROOT_PATH_BOTH
		)
	LIST(APPEND STM32USBHost_INCLUDE_DIRS ${STM32USBHost_HEADER_${source}})
ENDFOREACH()

LIST(REMOVE_DUPLICATES STM32USBHost_INCLUDE_DIRS)

INCLUDE(FindPackageHandleStandardArgs)

FIND_PACKAGE_HANDLE_STANDARD_ARGS(STM32USBHost DEFAULT_MSG STM32USBHost_SOURCES STM32USBHost_INCLUDE_DIRS)
