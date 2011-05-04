#!/bin/sh
#
# Copyright 2009 Huygens Instituut for the History of the Netherlands, Den Haag, The Netherlands.
#
# This file is part of New Women Writers.
#
# New Women Writers is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# New Women Writers is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with New Women Writers.  If not, see <http://www.gnu.org/licenses/>.
#


SERVER_DIR=`dirname $0`
cd $SERVER_DIR

PIDFILE=log/mongrel.pid

if [ `id -u` -eq 0 ]; then
	echo Dont start the server as root!
	exit 1
fi

if [ -e $PIDFILE ]; then
	PID=`cat $PIDFILE`
	if [ ! -d /proc/$PID ]; then
		echo Stale pidfile detected!
		rm -f $PIDFILE
	else
		echo Server is still running! \(PID $PID\)
		exit 1
	fi
fi	

mongrel_rails start -p 8000 -e production -d
