SET(mbedtls_COMPONENTS aes aesni arc4 asn1parse asn1write base64 bignum blowfish camellia ccm certs cipher cipher_wrap cmac ctr_drbg debug des dhm ecdh ecdsa ecjpake ecp ecp_curves entropy entropy_poll error gcm havege hmac_drbg Makefile md2 md4 md5 md md_wrap memory_buffer_alloc net_sockets oid padlock pem pk pkcs11 pkcs12 pkcs5 pkparse pk_wrap pkwrite platform ripemd160 rsa sha1 sha256 sha512 ssl_cache ssl_ciphersuites ssl_cli ssl_cookie ssl_srv ssl_ticket ssl_tls threading timing version version_features x509 x509_create x509_crl x509_crt x509_csr x509write_crt x509write_csr xtea)

IF(NOT mbedtls_FIND_COMPONENTS)
	SET(mbedtls_FIND_COMPONENTS ${mbedtls_COMPONENTS})
	MESSAGE(STATUS "No mbedtls components selected, using all: ${mbedtls_FIND_COMPONENTS}")
ENDIF()

IF(NOT mbedtls_DIR)
	MESSAGE(FATAL_ERROR "No path to library given in mbedtls_DIR")
ENDIF()

FOREACH(cmp ${mbedtls_FIND_COMPONENTS})
	LIST(FIND mbedtls_COMPONENTS ${cmp} mbedtls_FOUND_INDEX)
	IF(${mbedtls_FOUND_INDEX} LESS 0)
		MESSAGE(FATAL_ERROR "Unknown mbedtls component: ${cmp}. Available components: ${mbedtls_COMPONENTS}")
    ENDIF()
	LIST(APPEND mbedtls_SELECTED_COMPONETS ${cmp})
ENDFOREACH()

FOREACH(cmp ${mbedtls_SELECTED_COMPONETS})
	FIND_FILE(SRC_FILE_${cmp} ${cmp}.c
		PATH ${mbedtls_DIR}/library
		NO_DEFAULT_PATH
        CMAKE_FIND_ROOT_PATH_BOTH
    )
    LIST(APPEND mbedtls_SOURCES ${SRC_FILE_${cmp}})

	FIND_PATH(INCLUDE_FILE_${cmp} mbedtls/${cmp}.h
		PATH ${mbedtls_DIR}/include
		NO_DEFAULT_PATH
		)
	LIST(APPEND mbedtls_INCLUDE_DIRS ${INCLUDE_FILE_${cmp}})
ENDFOREACH()

LIST(REMOVE_DUPLICATES mbedtls_INCLUDE_DIRS)

INCLUDE(FindPackageHandleStandardArgs)

FIND_PACKAGE_HANDLE_STANDARD_ARGS(mbedtls DEFAULT_MSG mbedtls_INCLUDE_DIRS mbedtls_SOURCES)
