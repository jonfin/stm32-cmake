SET(uGFX_GWIN_MODULES 
	gwin_radio
	gwin_progressbar
	gwin_mk
	gwin_gl3d
	gwin_wm
	gwin_tabset
	gwin_keyboard_layout
	gwin_textedit
	gwin_label
	gwin_container
	gwin_widget
	gwin_image
	gwin_checkbox
	gwin_button
	gwin_slider
	gwin_graph
	gwin_console
	gwin_keyboard
	gwin_list
	gwin_frame
)

FOREACH(uGFX_GWIN_MODULE ${uGFX_GWIN_MODULES})
	SET(uGFX_${uGFX_GWIN_MODULE}_SEARCH_PATH ${uGFX_DIR}/src/gwin)
	SET(uGFX_${uGFX_GWIN_MODULE}_HEADERS ${uGFX_GWIN_MODULE}.h)
	SET(uGFX_${uGFX_GWIN_MODULE}_SOURCES ${uGFX_GWIN_MODULE}.c)
ENDFOREACH()

SET(uGFX_gwin_SEARCH_PATH ${uGFX_DIR}/src/gwin)
SET(uGFX_gwin_HEADERS gwin_options.h gwin_rules.h gwin.h)
SET(uGFX_gwin_SOURCES gwin.c gwin_wm.c)

LIST(APPEND uGFX_GWIN_MODULES gwin)
