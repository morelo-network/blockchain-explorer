#------------------------------------------------------------------------------
# CMake helper for the majority of the cpp-ethereum modules.
#
# This module defines
#     GALAXIA_XXX_LIBRARIES, the libraries needed to use ethereum.
#     GALAXIA_FOUND, If false, do not try to use ethereum.
#
# File addetped from cpp-ethereum
#
# The documentation for cpp-ethereum is hosted at http://cpp-ethereum.org
#
# ------------------------------------------------------------------------------
# This file is part of cpp-ethereum.
#
# cpp-ethereum is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# cpp-ethereum is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with cpp-ethereum.  If not, see <http://www.gnu.org/licenses/>
#
# (c) 2014-2016 cpp-ethereum contributors.
#------------------------------------------------------------------------------

set(LIBS common;blocks;cryptonote_basic;cryptonote_core;multisig;net;
         cryptonote_protocol;daemonizer;mnemonics;epee;lmdb;device;
         blockchain_db;ringct;wallet;cncrypto;easylogging;version;checkpoints;randomx)

set(Galaxia_INCLUDE_DIRS "${CPP_GALAXIA_DIR}")

# if the project is a subset of main cpp-ethereum project
# use same pattern for variables as Boost uses

foreach (l ${LIBS})

	string(TOUPPER ${l} L)

	find_library(Galaxia_${L}_LIBRARY
		NAMES ${l}
		PATHS ${CMAKE_LIBRARY_PATH}
		PATH_SUFFIXES "/src/${l}" "/src/" "/external/db_drivers/lib${l}" "/lib" "/src/crypto" "/contrib/epee/src" "/external/easylogging++/" "/external/randomarq"
		NO_DEFAULT_PATH
	)

	set(Galaxia_${L}_LIBRARIES ${Galaxia_${L}_LIBRARY})

	message(STATUS FindGalaxia " Galaxia_${L}_LIBRARIES ${Galaxia_${L}_LIBRARY}")

	add_library(${l} STATIC IMPORTED)
	set_property(TARGET ${l} PROPERTY IMPORTED_LOCATION ${Galaxia_${L}_LIBRARIES})

endforeach()

if (EXISTS ${GALAXIA_BUILD_DIR}/src/ringct/libringct_basic.a)
	message(STATUS FindGalaxia " found libringct_basic.a")
	add_library(ringct_basic STATIC IMPORTED)
	set_property(TARGET ringct_basic
			PROPERTY IMPORTED_LOCATION ${GALAXIA_BUILD_DIR}/src/ringct/libringct_basic.a)
endif()


message(STATUS ${GALAXIA_SOURCE_DIR}/build)

# include galaxia headers
include_directories(
		${GALAXIA_SOURCE_DIR}/src
		${GALAXIA_SOURCE_DIR}/external
		${GALAXIA_SOURCE_DIR}/external/randomarq/src
		${GALAXIA_SOURCE_DIR}/build/release
		${GALAXIA_SOURCE_DIR}/external/easylogging++
		${GALAXIA_SOURCE_DIR}/contrib/epee/include
		${GALAXIA_SOURCE_DIR}/external/db_drivers/liblmdb)
